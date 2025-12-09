import 'package:flutter/material.dart';
import '/widgets/bottom_nav.dart';

class StokProdukScreen extends StatefulWidget {
  const StokProdukScreen({super.key});

  @override
  State<StokProdukScreen> createState() => _StokProdukScreenState();
}

class _StokProdukScreenState extends State<StokProdukScreen> {
  // Data stok
  List<Map<String, dynamic>> stokList = [
    {"nama": "Jagung", "stok": "13 kg", "img": "jagung.png"},
    {"nama": "cabe", "stok": "5 kg", "img": "cabe.png"},
    {"nama": "apel", "stok": "20 kg", "img": "apel.png"},
    {"nama": "pisang", "stok": "15 ikat", "img": "pisang.png"},
    {"nama": "selada", "stok": "7 kg", "img": "selada.png"},
    {"nama": "terong", "stok": "15 kg", "img": "terong.png"},
    {"nama": "tomat", "stok": "7 kg", "img": "tomat.png"},
  ];

  TextEditingController editStokController = TextEditingController();

  // Show popup edit produk
  void showEditPopup(int index) {
    editStokController.text = stokList[index]["stok"];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Gambar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/images/${stokList[index]["img"]}",
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 15),

                  const Text(
                    "EDIT PRODUK",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  Text("nama produk : ${stokList[index]["nama"]}"),
                  const SizedBox(height: 5),

                  // Edit stok input
                  TextField(
                    controller: editStokController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      labelText: "stok terbaru",
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Tombol Cancel
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white),
                        ),
                      ),

                      // Tombol Simpan
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            stokList[index]["stok"] = editStokController.text;
                          });

                          Navigator.pop(context); // tutup popup edit

                          // muncul popup berhasil
                          showSuccessPopup();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Popup berhasil diperbarui
  void showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });

        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.check, color: Colors.white, size: 35),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Berhasil Diperbarui",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA3D87C),
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
          "Manajeent Stok",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.shopping_cart_outlined, color: Colors.black),
          ),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const TextField(
                decoration: InputDecoration(
                    hintText: "searching...",
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 10)),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ================= LIST ITEM =================
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFE7F5DA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: stokList.length,
                itemBuilder: (context, i) {
                  return stokItem(i);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== CARD ITEM ====================
  Widget stokItem(int i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFA3D87C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "assets/images/${stokList[i]["img"]}",
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stokList[i]["nama"],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text("stok = ${stokList[i]["stok"]}",
                  style: const TextStyle(fontSize: 13)),
              const Text("update terakhir 12-11-2023",
                  style: TextStyle(fontSize: 11)),
            ],
          ),

          const Spacer(),

          GestureDetector(
            onTap: () => showEditPopup(i),
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.edit, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
