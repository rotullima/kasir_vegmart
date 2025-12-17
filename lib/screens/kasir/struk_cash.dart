import 'package:flutter/material.dart';
import 'package:kasir_vegmart/screens/kasir/home_screen.dart';
import '/widgets/bottom_nav.dart';

void main() {
  runApp(const StrukCash());
}

/// Warna tema agar mirip screenshot
const Color kGreenDark = Color(0xFF18492B);
const Color kGreen = Color(0xFF2E7D3A);
const Color kGreenLight = Color(0xFFd9efcf);
const Color kBeigeBg = Color(0xFFF3F2EA);

class StrukCash extends StatelessWidget {
  const StrukCash({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Confirmation UI Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: false,
        primaryColor: kGreen,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainShell(),
        '/cart': (context) => const CartPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

/// Shell dengan BottomNavigation dan konten utama (menggunakan index)
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // halaman contoh untuk setiap tab
  final List<Widget> _pages = const [
    ConfirmationPage(), // tab 0 -> contoh halaman di screenshot
    PlaceholderWidget(title: 'Orders / Receipt'),
    PlaceholderWidget(title: 'Profile'),
    PlaceholderWidget(title: 'Grid / More'),
    PlaceholderWidget(title: 'History'),
    PlaceholderWidget(title: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: const BottomNav(), // ← INI SUDAH FIX
    );
  }
}
/// Halaman konfirmasi (halaman utama yang meniru screenshot)
class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header manual (back, progress dots, cart)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Row(
              children: [
                // Back button circle
                // InkWell(
                //   onTap: () {
                //     // kembali ke route sebelumnya atau ke home
                //     if (Navigator.canPop(context)) {
                //       Navigator.pop(context);
                //     } else {
                //       Navigator.pushReplacementNamed(context, '/home');
                //     }
                //   },
                //   borderRadius: BorderRadius.circular(24),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Colors.black12,
                //       shape: BoxShape.circle,
                //     ),
                //     padding: const EdgeInsets.all(8),
                //     child: const Icon(
                //       Icons.arrow_back_ios_new,
                //       size: 16,
                //     ),
                //   ),
                // ),

                const Expanded(child: SizedBox()),

                // Progress indicator (three dots line centered)
                SizedBox(
                  width: 140,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _dot(),
                        const SizedBox(width: 12),
                        _dot(active: true),
                        const SizedBox(width: 12),
                        _dot(),
                      ],
                    ),
                  ),
                ),

                const Expanded(child: SizedBox()),

                // Cart icon
                // InkWell(
                //   onTap: () {
                //     Navigator.pushNamed(context, '/cart');
                //   },
                //   borderRadius: BorderRadius.circular(24),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Colors.black12,
                //       shape: BoxShape.circle,
                //     ),
                //     padding: const EdgeInsets.all(8),
                //     child: const Icon(
                //       Icons.shopping_cart_outlined,
                //       size: 20,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),

          // Spasi
          const SizedBox(height: 12),

          // Title Confirmation
          Center(
            child: Text(
              'Confirmation',
              style: TextStyle(
                color: kGreenDark,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: kGreenDark.withOpacity(0.35),
                    offset: const Offset(0, 6),
                    blurRadius: 6,
                  ),
                ],
                letterSpacing: 1.0,
              ),
            ),
          ),

          const SizedBox(height: 36),

          // Icon check in circle with layered shadows to mimic design
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // besar lingkaran dengan check
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: kGreenLight,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        offset: const Offset(0, 6),
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: const BoxDecoration(
                        color: kGreenDark,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // "Successfull!" text (note: original has typo with double l; we keep it as screenshot)
                Text(
                  'Successfull!',
                  style: TextStyle(
                    color: kGreenDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        color: kGreenDark.withOpacity(0.25),
                        offset: const Offset(0, 6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Text terima kasih + nomor order
                Column(
                  children: const [ 
                    Text(
                      'terimakasi telah berbelanja bersama kami',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '110',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Tombol Lanjutkan belanja
                SizedBox(
                  width: 240,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()),
                        );
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreenDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black45,
                    ),
                    child: const Text(
                      'Lanjutkan belanja',
                      style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Spasi bawah (agar bottom nav tidak overlap)
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  // dot helper untuk progress bar
  Widget _dot({bool active = false}) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? kGreenDark : Colors.green[300],
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Halaman Home contoh setelah "Lanjutkan belanja"
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home / Katalog'),
        backgroundColor: kGreenDark,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // contoh kembali ke confirmation (agar bisa dilihat lagi)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ConfirmationPage()),
            );
          },
          child: const Text('Kembali ke Confirmation (demo)'),
        ),
      ),
    );
  }
}

/// Halaman Cart contoh
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
        backgroundColor: kGreenDark,
      ),
      body: const Center(
        child: Text('Halaman Keranjang (contoh)'),
      ),
    );
  }
}

/// Placeholder widget untuk tab lain
class PlaceholderWidget extends StatelessWidget {
  final String title;
  const PlaceholderWidget({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBeigeBg,
      body: SafeArea(
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
