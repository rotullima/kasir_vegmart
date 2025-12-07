import 'package:flutter/material.dart';
import '/widgets/bottom_nav.dart'; // IMPORT BOTTOM NAV

class PelangganScreen extends StatefulWidget {
  const PelangganScreen({Key? key}) : super(key: key);

  @override
  _DaftarPelangganState createState() => _DaftarPelangganState();
}

class _DaftarPelangganState extends State<PelangganScreen> {
  List<Map<String, String>> customers = [
    {'name': 'ananda riski', 'id': '110', 'trx': 'transaksi terbaru : 80.000 ( cash )'},
    {'name': 'chella robiatul', 'id': '111', 'trx': 'transaksi terbaru : 40.000 ( transfer )'},
    {'name': 'anata agni', 'id': '112', 'trx': 'transaksi terbaru : 35.500 ( cash )'},
    {'name': 'aris indra', 'id': '113', 'trx': 'transaksi terbaru : 5.000 ( cash )'},
    {'name': 'hafiza yudistia', 'id': '114', 'trx': 'transaksi terbaru : 100.000 ( transfer )'},
  ];

  final Color bgHeader = const Color(0xFFEAF3E6);
  final Color cardBg = const Color(0xFFDDEEC5);
  final Color cardAccent = const Color(0xFF97AE70);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: bgHeader,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 4),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Daftar Pelanggan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      shadows: [
                        Shadow(color: Colors.black12, offset: Offset(2, 2), blurRadius: 2),
                      ],
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),

            // LIST CUSTOMERS
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: ListView.builder(
                  itemCount: customers.length + 1,
                  itemBuilder: (context, index) {
                    if (index == customers.length) return const SizedBox(height: 90);
                    final item = customers[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, offset: Offset(0, 1), blurRadius: 2),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.transparent,
                                child: _avatarForIndex(index),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['name']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                                const SizedBox(height: 4),
                                Text(item['id']!, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                const SizedBox(height: 6),
                                Text(item['trx']!, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              const Icon(Icons.more_horiz),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () => _showEditDialog(context, item, index),
                                    icon: const Icon(Icons.edit, size: 18),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () => _showDeleteConfirmDialog(context, item, index),
                                    child: Container(
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.red.shade400),
                                      ),
                                      child: const Icon(Icons.delete, color: Colors.red, size: 16),
                                    ),
                                  ),
                                ],
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
      ),

      // FLOATING BUTTON
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 28),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        decoration: BoxDecoration(
          color: cardAccent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 4),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.add, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'tambah pelanggan baru',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),

      // PAKAI WIDGET BOTTOM NAV
      bottomNavigationBar: const BottomNav(),
    );
  }

  // AVATAR ICON
  Widget _avatarForIndex(int index) {
    switch (index) {
      case 0:
        return const Icon(Icons.person, size: 22, color: Colors.black87);
      case 1:
      case 2:
      case 4:
        return const Icon(Icons.face, size: 22, color: Colors.brown);
      case 3:
        return const Icon(Icons.person, size: 22, color: Colors.black87);
      default:
        return const Icon(Icons.person, size: 22);
    }
  }

  // EDIT DIALOG
  void _showEditDialog(BuildContext context, Map<String, String> item, int index) {
    final TextEditingController nameController = TextEditingController(text: item['name']);
    final TextEditingController idController = TextEditingController(text: item['id']);
    final TextEditingController trxController = TextEditingController(text: item['trx']);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 380,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "EDIT PELANGGAN",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    fontFamily: "Times New Roman",
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _editLabelCompact("nama pelanggan :", nameController),
                      const SizedBox(height: 10),
                      _editLabelCompact("nomor pelanggan :", idController),
                      const SizedBox(height: 10),
                      _editLabelCompact("transaksi terbaru:", trxController),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red, width: 5),
                        ),
                        child: const Center(
                          child: Icon(Icons.close, color: Colors.red, size: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          customers[index] = {
                            'name': nameController.text,
                            'id': idController.text,
                            'trx': trxController.text,
                          };
                        });
                        Navigator.pop(context);
                        Future.delayed(const Duration(milliseconds: 200), () {
                          _showSuccessDialog(context);
                        });
                      },
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF0C395E),
                        ),
                        child: const Center(
                          child: Icon(Icons.check, color: Colors.white, size: 28),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _editLabelCompact(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: "Times New Roman",
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 14),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
      ],
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 360,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF2F4D19),
                  ),
                  child: const Center(
                    child: Icon(Icons.check, color: Colors.white, size: 58),
                  ),
                ),
                const SizedBox(height: 26),
                const Text(
                  "Berhasil Diperbarui",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    fontFamily: "Times New Roman",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, Map<String, String> item, int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Anda yakin akan menghapus pelanggan\n"${item['name']}"?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: const Size(110, 50),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'tidak',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        minimumSize: const Size(110, 50),
                      ),
                      onPressed: () {
                        setState(() {
                          customers.removeAt(index);
                        });
                        Navigator.pop(context);
                        Future.delayed(const Duration(milliseconds: 200), () {
                          _showSuccessDialog(context);
                        });
                      },
                      child: const Text(
                        'iya',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}