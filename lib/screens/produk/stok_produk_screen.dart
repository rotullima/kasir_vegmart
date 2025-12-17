import 'package:flutter/material.dart';
import '/widgets/bottom_nav.dart';
import '/services/stock_service.dart';

class StokProdukScreen extends StatefulWidget {
  const StokProdukScreen({super.key});

  @override
  State<StokProdukScreen> createState() => _StokProdukScreenState();
}

class _StokProdukScreenState extends State<StokProdukScreen> {
  final StokService stokService = StokService();
  List<Map<String, dynamic>> stokList = [];
  bool isLoading = true;

  final TextEditingController editStokController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStok();
  }

  Future<void> fetchStok() async {
    setState(() => isLoading = true);
    try {
      final data = await stokService.getAllStok();
      stokList = data;
    } catch (e) {
      debugPrint('FETCH STOK ERROR: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showEditPopup(Map<String, dynamic> item) {
    editStokController.text = item['jumlah_stok'].toString();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Edit Stok"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item['PRODUK']['gambar'] ?? '',
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image, size: 50),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item['PRODUK']['nama_produk'],
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: editStokController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(labelText: "Stok terbaru (kg)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                final stokBaru =
                    int.tryParse(editStokController.text) ?? 0;

                await stokService.updateStok(
  stokId: item['id'], // ⬅️ ini ID row STOK
  stokBaru: stokBaru,
);


                await fetchStok();
                if (mounted) Navigator.pop(context, true);

                showSuccessPopup();
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  void showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });

        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.check, color: Colors.white, size: 30),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Stok berhasil diperbarui",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      bottomNavigationBar: const BottomNav(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFA3D87C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Manajemen Stok",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: stokList.length,
              itemBuilder: (context, i) {
                final item = stokList[i];
                final produk = item['PRODUK'];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA3D87C),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          produk['gambar'] ?? '',
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            produk['nama_produk'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "stok = ${item['jumlah_stok']} kg",
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => showEditPopup(item),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
