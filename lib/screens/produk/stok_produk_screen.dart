import 'package:flutter/material.dart';
import '/widgets/bottom_nav.dart';

class StokProdukScreen extends StatelessWidget {
  const StokProdukScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA3D87C), // Hijau header sesuai gambar
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
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
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
                  contentPadding: EdgeInsets.only(top: 10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // LIST ITEM
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFE7F5DA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  stokItem("Jagung", "13 kg", "jagung.png"),
                  stokItem("cabe", "5 kg", "cabe.png"),
                  stokItem("apel", "20 kg", "apel.png"),
                  stokItem("pisang", "15 ikat", "pisang.png"),
                  stokItem("selada", "7 kg", "selada.png"),
                  stokItem("terong", "15 kg", "terong.png"),
                  stokItem("tomat", "7 kg", "tomat.png"),
                ],
              ),
            ),
          ),
        ],
      ) 
          );
  }

  // 🔹 UI Card Item
  Widget stokItem(String nama, String stok, String imageName) {
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
              "assets/images/$imageName",
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          // Text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nama,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Text(
                "stok = $stok",
                style: const TextStyle(fontSize: 13),
              ),
              const Text(
                "update terakhir 12-11-2023",
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),

          const Spacer(),

          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.edit, size: 18),
          ),
        ],
      ),
    );
  }
}
