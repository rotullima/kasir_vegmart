import 'package:flutter/material.dart';
import '/widgets/bottom_nav.dart';
import 'keranjang_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          'Produk',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Keranjang()),
                );
              },
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search box
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "search...",
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Header banner
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/header.png',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 16),

              // Circle icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var icon in [
                    'sayur1.png',
                    'sayur2.png',
                    'sayur3.png',
                    'sayur4.png',
                    'sayur5.png',
                  ])
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Image.asset('assets/images/$icon', height: 32),
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // Produk grid
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  produkCard('Pisang', '9.000/kg', 'pisang.png', highlight: true),
                  produkCard('Apel', '9.000/kg', 'apel.png'),
                  produkCard('Selada', '12.000/kg', 'selada.png'),
                  produkCard('Pakchoy', '6.000/kg', 'pakcoy.png'),
                  produkCard('Jagung', '7.000/kg', 'jagung.png', highlight: true),
                  produkCard('Tomat', '7.000/kg', 'tomat.png', highlight: true),
                  produkCard('Timun', '6.000/kg', 'timun.png'),
                  produkCard('Terong', '6.000/kg', 'terong.png'),
                ],
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget produkCard(
    String title,
    String price,
    String image, {
    bool highlight = false,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (highlight)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Promo',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          const SizedBox(height: 8),
          Image.asset('assets/images/$image', height: 90),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(price, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.green,
              child: const Icon(Icons.add, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
