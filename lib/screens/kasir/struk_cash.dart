import 'package:flutter/material.dart';
import 'package:kasir_vegmart/screens/kasir/home_screen.dart';

/// Warna tema agar mirip screenshot
const Color kGreenDark = Color(0xFF18492B);
const Color kGreen = Color(0xFF2E7D3A);
const Color kGreenLight = Color(0xFFd9efcf);
const Color kBeigeBg = Color(0xFFF3F2EA);

class StrukCash extends StatelessWidget {
  final List<dynamic>? items;
  final double? totalBelanja;
  final String? metodePembayaran;
  final DateTime? tanggal;
  final String? noOrder;

  const StrukCash({
    super.key,
    this.items,
    this.totalBelanja,
    this.metodePembayaran,
    this.tanggal,
    this.noOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header manual (progress dots)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: Row(
                children: [
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

                  // "Successfull!" text
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

                  // Text terima kasih + info transaksi
                  Column(
                    children: [
                      const Text(
                        'terimakasi telah berbelanja bersama kami',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (totalBelanja != null)
                        Text(
                          'Total: Rp ${totalBelanja!.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kGreenDark,
                          ),
                        ),
                      const SizedBox(height: 4),
                      if (metodePembayaran != null)
                        Text(
                          'Metode: ${metodePembayaran!.toUpperCase()}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        noOrder ?? '110',
                        style: const TextStyle(
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
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false,
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
                          color: Colors.white,
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