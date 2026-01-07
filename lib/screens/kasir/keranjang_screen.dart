// lib/screens/kasir/keranjang_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';  
import '/widgets/bottom_nav.dart';
import '/providers/cart_provider.dart';
import '/services/transaksi_service.dart';              
import '/screens/kasir/struk_cash.dart';

class KeranjangScreen extends StatefulWidget {
  const KeranjangScreen({super.key});

  @override
  State<KeranjangScreen> createState() => _KeranjangScreenState();
}

class _KeranjangScreenState extends State<KeranjangScreen> {
  String metodePembayaran = "cash";

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        if (cart.items.isEmpty) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: const Color(0xFF9CCC65),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text("Keranjang", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            ),
            body: const Center(
              child: Text(
                "Keranjang kosong\nTambahkan produk dari halaman kasir",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
            bottomNavigationBar: const BottomNav(),
          );
        }

        double totalHarga = cart.items.fold(0, (sum, item) => sum + (item.harga * item.qty));
        int totalItem = cart.items.fold(0, (sum, item) => sum + item.qty);

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                width: double.infinity,
                color: const Color(0xFF9CCC65),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, size: 28),
                    ),
                    const SizedBox(width: 10),
                    const Text("Keranjang", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    const Icon(Icons.shopping_cart_outlined, size: 28),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ...cart.items.map((item) {
                        return Column(
                          children: [
                            Dismissible(
                              key: Key(item.produkId.toString()),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.delete, color: Colors.white, size: 28),
                              ),
                              confirmDismiss: (direction) async {
                                return await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: const Color(0xFFF09488),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    content: Text('Hapus "${item.namaProduk}" dari keranjang?', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Tidak")),
                                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Ya")),
                                    ],
                                  ),
                                ) ?? false;
                              },
                              onDismissed: (_) => cart.removeItem(item.produkId),
                              child: itemCard(
                                gambar: item.gambar,
                                title: item.namaProduk,
                                harga: item.harga,
                                qty: item.qty,
                                onQtyChanged: (newQty) {
                                  if (newQty <= 0) {
                                    cart.removeItem(item.produkId);
                                  } else {
                                    cart.updateQty(item.produkId, newQty);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      }),

                      const SizedBox(height: 25),

                      const Text("Metode Pembayaran", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text("Cash", style: TextStyle(fontSize: 15)),
                          const Expanded(child: Divider(thickness: 1)),
                          Radio<String>(
                            value: "cash",
                            groupValue: metodePembayaran,
                            onChanged: (val) => setState(() => metodePembayaran = val!),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Transfer Bank", style: TextStyle(fontSize: 15)),
                          const Expanded(child: Divider(thickness: 1)),
                          Radio<String>(
                            value: "tf",
                            groupValue: metodePembayaran,
                            onChanged: (val) => setState(() => metodePembayaran = val!),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.25), blurRadius: 6, offset: const Offset(0, 3))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total item:      $totalItem", style: const TextStyle(fontSize: 15)),
                            Text("Harga:           Rp ${totalHarga.toStringAsFixed(0)}", style: const TextStyle(fontSize: 15)),
                            const Text("Hemat:           Rp 0", style: TextStyle(fontSize: 15)),
                            Text("Grand Total:     Rp ${totalHarga.toStringAsFixed(0)}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: cart.items.isEmpty
                              ? null
                              : () async {
                                  try {
                                    final kasirId = Supabase.instance.client.auth.currentUser?.id ?? '';
                                    if (kasirId.isEmpty) throw 'Kasir belum login';

                                    // Simpan data untuk struk sebelum clear cart
                                    final transaksiItems = List.from(cart.items);
                                    final totalBelanja = totalHarga;
                                    final metode = metodePembayaran;

                                    await TransaksiService().simpanTransaksi(
                                      items: cart.items,
                                      total: totalHarga,
                                      metodePembayaran: metodePembayaran,
                                      kasirId: kasirId,
                                    );

                                    cart.clear();

                                    if (!mounted) return;
                                    
                                    // Navigasi ke StrukCash dengan data transaksi
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => StrukCash(
                                          items: transaksiItems,
                                          totalBelanja: totalBelanja,
                                          metodePembayaran: metode,
                                          tanggal: DateTime.now(),
                                          noOrder: DateTime.now().millisecondsSinceEpoch.toString().substring(7),
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Gagal transaksi: $e'), backgroundColor: Colors.red),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8BC34A),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                          child: const Text("Konfirmasi & Bayar", style: TextStyle(fontSize: 20, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: const BottomNav(),
        );
      },
    );
  }

  Widget itemCard({
    required String gambar,
    required String title,
    required double harga,
    required int qty,
    required Function(int) onQtyChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFDDEDC6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              gambar,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Image.asset('assets/images/default.png', width: 60, height: 60),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                Text("Rp ${harga.toStringAsFixed(0)}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => onQtyChanged(qty - 1)),
              Text("$qty", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => onQtyChanged(qty + 1)),
            ],
          ),
        ],
      ),
    );
  }
}