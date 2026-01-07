import 'dart:typed_data'; // Ditambahkan untuk Uint8List
import 'package:flutter/material.dart';
import '/widgets/bottom_nav.dart';
import 'stok_produk_screen.dart';
import '/services/product_service.dart';

class KategoriProdukScreen extends StatefulWidget {
  final String title;
  final String headerImage;

  const KategoriProdukScreen({
    super.key,
    required this.title,
    required this.headerImage,
  });

  @override
  State<KategoriProdukScreen> createState() => _KategoriProdukScreenState();
}

class _KategoriProdukScreenState extends State<KategoriProdukScreen> {
  final ProductService productService = ProductService();
  List<Map<String, dynamic>> produkList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() => isLoading = true);
    try {
      final res = await productService.supabase
          .from('PRODUK')
          .select('''
            id,
            nama_produk,
            harga_produk,
            kategori,
            gambar,
            STOK!inner (
              id,
              jumlah_stok,
              created_at
            )
          ''')
          .eq('kategori', widget.title)
          .order('created_at', referencedTable: 'STOK', ascending: false);

      produkList = List<Map<String, dynamic>>.from(res);
      print("Kategori dikirim: '${widget.title}'");
      print("Hasil query: $produkList");
    } catch (e) {
      print("ERROR: $e");
      produkList = [];
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> showProductPopup({Map<String, dynamic>? data}) async {
    final nameCtrl = TextEditingController(text: data?['nama_produk'] ?? '');
    final hargaCtrl = TextEditingController(
      text: data?['harga_produk']?.toString() ?? '',
    );
    final stokCtrl = TextEditingController(
      text: data?['STOK'] != null && (data?['STOK'] as List).isNotEmpty
          ? (data?['STOK'] as List).first['jumlah_stok']?.toString() ?? ''
          : '',
    );
    final isEdit = data != null;

    Uint8List? pickedImgBytes;
    String? pickedImgName;
    String? existingImg = data?['gambar'];

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              title: Text(data == null ? "Tambah Produk" : "Edit Produk"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final result = await productService.pickImageBytes();
                        if (result != null) {
                          setStateDialog(() {
                            pickedImgBytes = result.$1;
                            pickedImgName = result.$2;
                          });
                        }
                      },
                      child: CircleAvatar(
                        radius: 45,
                        backgroundImage: pickedImgBytes != null
                            ? MemoryImage(pickedImgBytes!)
                            : (existingImg != null
                                ? NetworkImage(existingImg)
                                : null) as ImageProvider?,
                        child: (pickedImgBytes == null && existingImg == null)
                            ? const Icon(Icons.camera_alt, size: 30)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: "Nama Produk",
                      ),
                    ),
                    TextField(
                      controller: hargaCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Harga Produk",
                      ),
                    ),
                    if (!isEdit)
                      TextField(
                        controller: stokCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Stok Awal (kg)",
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final stokValue = int.tryParse(stokCtrl.text) ?? 0;
                      final hargaValue = num.tryParse(hargaCtrl.text) ?? 0;

                      if (data == null) {
                        // Tambah produk baru
                        await productService.addProduct(
                          name: nameCtrl.text,
                          harga: hargaValue,
                          kategori: widget.title,
                          imageData: (pickedImgBytes, pickedImgName),
                          stok: stokValue,
                        );
                      } else {
                        // Update produk
                        await productService.updateProduct(
                          id: data['id'],
                          name: nameCtrl.text,
                          harga: hargaValue,
                          kategori: widget.title,
                          imageData: (pickedImgBytes, pickedImgName),
                          stok: stokValue,
                        );
                      }

                      await fetchProducts();
                      if (mounted) Navigator.pop(context);
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Gagal simpan produk: $e")),
                        );
                      }
                    }
                  },
                  child: const Text("Simpan"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> deleteProduct(int id) async {
    try {
      await productService.deleteProduct(id);
      await fetchProducts();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal hapus produk: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFE7),
      bottomNavigationBar: const BottomNav(),
      floatingActionButton: Stack(
        children: [
          Positioned(
            left: 16,
            bottom: 16,
            child: FloatingActionButton.extended(
              onPressed: () => showProductPopup(),
              backgroundColor: const Color(0xFF5F6635),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text("tambah produk"),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StokProdukScreen()),
                );
                await fetchProducts();
              },
              backgroundColor: const Color(0xFF5F6635),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.arrow_forward),
              label: const Text("stok"),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            width: double.infinity,
            color: const Color(0xFF5F6635),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "searching...",
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.headerImage,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : produkList.isEmpty
                    ? const Center(child: Text("Belum ada produk"))
                    : RefreshIndicator(
                        onRefresh: fetchProducts,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: produkList.length,
                          itemBuilder: (context, i) {
                            final item = produkList[i];
                            final stokList = item['STOK'] as List<dynamic>? ?? [];

                            final stok = stokList.isNotEmpty
                                ? (stokList.first['jumlah_stok'] as int? ?? 0)
                                : 0;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFCDE6A3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      item["gambar"] ?? '',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(Icons.image),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item["nama_produk"],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          "harga = ${item["harga_produk"]}",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text("stok = $stok kg"),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () =>
                                            showProductPopup(data: item),
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            deleteProduct(item['id']),
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}