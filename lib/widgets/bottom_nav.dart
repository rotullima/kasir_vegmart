import 'package:flutter/material.dart';
import 'package:kasir_vegmart/screens/pelanggan/pelanggan_screen.dart';
import 'package:kasir_vegmart/screens/laporan/laporan_kasir_screen.dart';
// import 'package:kasir_app/screens/laporan/laporan_kasir.dart';
// import 'package:kasir_app/screens/pelanggan/daftar_pelanggan.dart';
// import 'package:kasir_app/screens/produk/managemen_produk.dart';
import '/screens/setting_screen.dart';
import '/screens/kasir/home_screen.dart';
import '/screens/dashboard_screen.dart';
import '/screens/produk/produk_screen.dart';
import '/screens/produk/stok_produk_screen.dart';
import '/screens/kasir/struk_cash.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home
            IconButton(
              icon: const Icon(Icons.home_outlined, size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),

            // Book / ProdukPerKategori
            IconButton(
              icon: const Icon(Icons.menu_book_outlined, size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManagementProdukScreen(),
                  ),
                );
              },
            ),

            // Profile
            IconButton(
              icon: const Icon(Icons.person_outline, size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PelangganScreen()),
                );
              },
            ),

            // Dashboard
            IconButton(
              icon: const Icon(Icons.dashboard_outlined, size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardScreen()),
                );
              },
            ),

            // History / Time
            IconButton(
              icon: const Icon(Icons.access_time, size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LaporanKasirScreen()),
                );
              },
            ),

            // Settings
            IconButton(
              icon: const Icon(Icons.settings_outlined, size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}