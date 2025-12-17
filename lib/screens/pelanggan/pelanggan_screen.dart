import 'package:flutter/material.dart';
import '/widgets/bottom_nav.dart';
import '/services/customer_service.dart';

class PelangganScreen extends StatefulWidget {
  const PelangganScreen({super.key});

  @override
  State<PelangganScreen> createState() => _PelangganScreenState();
}

class _PelangganScreenState extends State<PelangganScreen> {
  final PelangganService pelangganService = PelangganService();

  List<Map<String, dynamic>> pelangganList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  Future<void> fetchPelanggan() async {
    setState(() => isLoading = true);
    try {
      pelangganList = await pelangganService.getAllPelanggan();
    } catch (e) {
      debugPrint('FETCH PELANGGAN ERROR: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ================= POPUP TAMBAH / EDIT =================
  Future<void> showPelangganPopup({Map<String, dynamic>? data}) async {
    final nameCtrl =
        TextEditingController(text: data?['nama_pelanggan'] ?? '');
    final noCtrl =
        TextEditingController(text: data?['no_pelanggan']?.toString() ?? '');
    final trxCtrl =
        TextEditingController(text: data?['transaksi_terbaru'] ?? '');

    final isEdit = data != null;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Text(isEdit ? "Edit Pelanggan" : "Tambah Pelanggan"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration:
                      const InputDecoration(labelText: "Nama Pelanggan"),
                ),
                TextField(
                  controller: noCtrl,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: "Nomor Pelanggan"),
                ),
                TextField(
                  controller: trxCtrl,
                  decoration: const InputDecoration(
                    labelText: "Transaksi Terakhir",
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
                  if (isEdit) {
                    await pelangganService.updatePelanggan(
                      id: data['id'],
                      nama: nameCtrl.text,
                      nomor: int.parse(noCtrl.text),
                      transaksiTerbaru: trxCtrl.text,
                    );
                  } else {
                    await pelangganService.addPelanggan(
                      nama: nameCtrl.text,
                      nomor: int.parse(noCtrl.text),
                      transaksiTerbaru: trxCtrl.text,
                    );
                  }

                  await fetchPelanggan();
                  if (mounted) Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gagal menyimpan: $e")),
                  );
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  // ================= DELETE =================
  void deletePelanggan(int id) async {
    await pelangganService.deletePelanggan(id);
    await fetchPelanggan();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showPelangganPopup(),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Daftar Pelanggan"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pelangganList.length,
              itemBuilder: (context, i) {
                final item = pelangganList[i];
                return Card(
                  child: ListTile(
                    title: Text(item['nama_pelanggan']),
                    subtitle: Text(
                      "No: ${item['no_pelanggan']}\n${item['transaksi_terbaru'] ?? '-'}",
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              showPelangganPopup(data: item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deletePelanggan(item['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
