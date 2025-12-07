import 'package:flutter/material.dart';
import '/widgets/bottom_nav.dart';
import 'kategori_produk_screen.dart';

class ManagementProdukScreen extends StatelessWidget {
  const ManagementProdukScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFE7),
      bottomNavigationBar: const BottomNav(),
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
                const Text(
                  "Management Produk",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  kategoriItem(context, "sayur", "assets/images/sayur.png"),
                  const SizedBox(height: 20),
                  kategoriItem(context, "buah", "assets/images/buah.png"),
                  const SizedBox(height: 20),
                  kategoriItem(context, "rempah", "assets/images/rempah.png"),
                  const SizedBox(height: 20),
                  kategoriItem(context, "pelengkap", "assets/images/pelengkap.png"),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget kategoriItem(BuildContext context, String title, String image) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => KategoriProdukScreen(title: title, headerImage: image),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              image,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 6),
            color: Colors.black,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
