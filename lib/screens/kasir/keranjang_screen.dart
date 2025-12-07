import 'package:flutter/material.dart';
import '/widgets/bottom_nav.dart'; // IMPORT BOTTOM NAV

class Keranjang extends StatefulWidget {
  const Keranjang({super.key});

  @override
  State<Keranjang> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<Keranjang> {
  String metodePembayaran = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER
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
                const Text(
                  "keranjang",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.shopping_cart_outlined, size: 28),
              ],
            ),
          ),

          // LIST PRODUK
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  itemCard(
                    img: "assets/images/cabe.png",
                    title: "cabe kecil",
                    qty: "250/0gr",
                    harga: "RP 24.500",
                    jumlah: 1,
                  ),
                  const SizedBox(height: 12),
                  itemCard(
                    img: "assets/images/jagung.png",
                    title: "jagung",
                    qty: "500/0gr",
                    harga: "RP 8.000",
                    jumlah: 2,
                  ),
                  const SizedBox(height: 12),
                  itemCard(
                    img: "assets/images/ubi.png",
                    title: "ubi ungu",
                    qty: "500/0gr",
                    harga: "RP 3.000",
                    jumlah: 1,
                  ),
                  const SizedBox(height: 12),
                  itemCard(
                    img: "assets/images/pakcoy.png",
                    title: "pakcoy",
                    qty: "400/0gr",
                    harga: "RP 5.500",
                    jumlah: 1,
                  ),
                  const SizedBox(height: 25),

                  // METODE PEMBAYARAN
                  const Text(
                    "Metode Pembayaran",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Text("Cash", style: TextStyle(fontSize: 15)),
                      const Expanded(child: Divider(thickness: 1)),
                      Radio(
                        value: "cash",
                        groupValue: metodePembayaran,
                        onChanged: (val) {
                          setState(() => metodePembayaran = val!);
                        },
                      )
                    ],
                  ),

                  Row(
                    children: [
                      const Text("Transfer Bank", style: TextStyle(fontSize: 15)),
                      const Expanded(child: Divider(thickness: 1)),
                      Radio(
                        value: "tf",
                        groupValue: metodePembayaran,
                        onChanged: (val) {
                          setState(() => metodePembayaran = val!);
                        },
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  // TOTAL
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.25),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total item:      4",
                            style: TextStyle(fontSize: 15)),
                        Text("harga:          RP.46.000",
                            style: TextStyle(fontSize: 15)),
                        Text("hemat:          RP. 5.000",
                            style: TextStyle(fontSize: 15)),
                        Text(
                          "Grand Total:   RP.41.000",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8BC34A),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        "checkout",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // PAKAI WIDGET BOTTOM NAV
      bottomNavigationBar: const BottomNav(),
    );
  }

  // ==================== ITEM CARD ====================
  Widget itemCard({
    required String img,
    required String title,
    required String qty,
    required String harga,
    required int jumlah,
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
            child: Image.asset(
              img,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold)),
                Text(qty, style: const TextStyle(fontSize: 13)),
                Text(harga,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF8BC34A),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              "+ $jumlah",
              style: const TextStyle(
                  fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}