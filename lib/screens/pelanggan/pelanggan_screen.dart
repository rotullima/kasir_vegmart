import 'package:flutter/foundation.dart'; // untuk debugPrint
import 'package:flutter/material.dart';
import '/widgets/bottom_nav.dart';
import '/services/customer_service.dart'; // ganti nama service sesuai kamu (PelangganService)

class PelangganScreen extends StatefulWidget {
  const PelangganScreen({super.key});

  @override
  State<PelangganScreen> createState() => _PelangganScreenState();
}

class _PelangganScreenState extends State<PelangganScreen> {
  final PelangganService pelangganService = PelangganService(); // atau nama service kamu

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
      if (kDebugMode) debugPrint('FETCH PELANGGAN ERROR: $e');
      pelangganList = [];
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ================= POPUP TAMBAH / EDIT =================
  Future<void> showPelangganPopup({Map<String, dynamic>? data}) async {
    final nameCtrl = TextEditingController(text: data?['nama_pelanggan'] ?? '');
    final noCtrl = TextEditingController(text: data?['no_pelanggan']?.toString() ?? '');
    final trxCtrl = TextEditingController(text: data?['transaksi_terbaru'] ?? '');

    final isEdit = data != null;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              title: Text(isEdit ? "Edit Pelanggan" : "Tambah Pelanggan"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: "Nama Pelanggan",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: noCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Nomor Pelanggan",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: trxCtrl,
                      decoration: const InputDecoration(
                        labelText: "Transaksi Terakhir",
                        border: OutlineInputBorder(),
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
                      if (nameCtrl.text.trim().isEmpty) {
                        throw 'Nama pelanggan harus diisi!';
                      }
                      final nomor = int.tryParse(noCtrl.text) ?? 0;

                      if (isEdit) {
                        await pelangganService.updatePelanggan(
                          id: data['id'],
                          nama: nameCtrl.text.trim(),
                          nomor: nomor,
                          transaksiTerbaru: trxCtrl.text.trim(),
                        );
                      } else {
                        await pelangganService.addPelanggan(
                          nama: nameCtrl.text.trim(),
                          nomor: nomor,
                          transaksiTerbaru: trxCtrl.text.trim(),
                        );
                      }

                      await fetchPelanggan();
                      if (mounted) Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Pelanggan berhasil disimpan! ✅"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Gagal menyimpan: $e")),
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

  // ================= DELETE DENGAN KONFIRMASI =================
  Future<void> deletePelanggan(int id, String nama) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text("Hapus Pelanggan?"),
          ],
        ),
        content: Text("Yakin ingin menghapus '$nama'? Data tidak bisa dikembalikan."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await pelangganService.deletePelanggan(id);
        await fetchPelanggan();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Pelanggan berhasil dihapus! 🗑️"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal hapus: $e")),
          );
        }
      }
    }
  }

  // ================= UI MIRIP SCREENSHOT =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFE7), // background krem kasir kamu
      bottomNavigationBar: const BottomNav(),
      appBar: AppBar(
        title: const Text(
          "Daftar Pelanggan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF5F6635), // hijau tua tema kasir
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 80),
        child: FloatingActionButton.extended(
          heroTag: "addPelanggan",
          onPressed: () => showPelangganPopup(),
          backgroundColor: const Color.fromARGB(255, 20, 74, 2),
          elevation: 6,
          icon: const Icon(Icons.person_add, color: Colors.white),
          label: const Text(
            "Tambah Pelanggan Baru",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF5F6635)),
            )
          : pelangganList.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "Belum ada pelanggan",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchPelanggan,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: pelangganList.length,
                    itemBuilder: (context, i) {
                      final item = pelangganList[i];
                      final nama = item['nama_pelanggan'] ?? 'Pelanggan';
                      final no = item['no_pelanggan']?.toString() ?? '-';
                      final trx = item['transaksi_terbaru'] ?? '-';

                      // Parse transaksi untuk warna (contoh screenshot: -Rp40.000 merah)
                      final trxValue = double.tryParse(
                        trx.replaceAll(RegExp(r'[^0-9.-]'), ''),
                      ) ?? 0;
                      final isPositive = trxValue >= 0;
                      final trxColor = isPositive ? const Color.fromARGB(255, 0, 0, 0) : Colors.red[600]!;

                      // Avatar lucu berdasarkan nama
                      final avatarEmoji = _getAvatarEmoji(nama);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5F6635),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Avatar
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.white,
                              child: Text(
                                avatarEmoji,
                                style: const TextStyle(fontSize: 40),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Info pelanggan
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nama,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "transaksi $no",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "transaksi terbaru: $trx",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: trxColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Ikon Edit & Delete
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () => showPelangganPopup(data: item),
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    size: 28,
                                  ),
                                  tooltip: "Edit",
                                ),
                                IconButton(
                                  onPressed: () => deletePelanggan(item['id'], nama),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 28,
                                  ),
                                  tooltip: "Hapus",
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  // Helper untuk avatar emoji lucu
  String _getAvatarEmoji(String nama) {
    final lower = nama.toLowerCase();
    if (lower.contains('wanita') || lower.contains('a')) return '👩';
    if (lower.contains('pria') || lower.contains('o')) return '👨';
    return '🧑';
  }
}