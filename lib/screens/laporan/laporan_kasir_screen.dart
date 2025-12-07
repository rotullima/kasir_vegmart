import 'package:flutter/material.dart';
import '/widgets/bottom_nav.dart'; // ⬅️ TAMBAHKAN INI
import 'laporan_pelanggan_screen.dart';

class LaporanKasirScreen extends StatefulWidget {
  const LaporanKasirScreen({super.key});

  @override
  State<LaporanKasirScreen> createState() => _LaporanKasirState();
}

class _LaporanKasirState extends State<LaporanKasirScreen> {
  int currentTab = 0; // 0 = kasir, 1 = pelanggan
  int period = 0; // 0 = hari, 1 = minggu, 2 = bulan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F2),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF8BC34A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      "Laporan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // SWITCH TAB
              Row(
                children: [
                  _tabButton("kasir", 0),
                  const SizedBox(width: 10),
                  _tabButton("pelanggan", 1),
                ],
              ),

              const SizedBox(height: 16),

              // PERIOD TAB
              Row(
                children: [
                  _periodButton("hari", 0),
                  const SizedBox(width: 10),
                  _periodButton("minggu", 1),
                  const SizedBox(width: 10),
                  _periodButton("bulan", 2),
                ],
              ),

              const SizedBox(height: 20),

              _pendapatanCard(),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(child: _smallCard("Pengeluaran", "28.000.000,00")),
                  const SizedBox(width: 10),
                  Expanded(child: _smallCard("Keuntungan", "8.000.000,00")),
                ],
              ),

              const SizedBox(height: 20),

              _penjualanTerbanyak(),
              const SizedBox(height: 20),

              _listKasir(),
              const SizedBox(height: 20),

              _btn("Cetak Struk Transaksi (PDF)", () {}),
              _btn("Cetak Laporan Penjualan (PDF)", () {}),
              _btn("Export Laporan (PDF)", () {}),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // ⬇️⬇️ BOTTOM NAV SUDAH DITAMBAH ⬇️⬇️
      bottomNavigationBar: const BottomNav(),
    );
  }

  // ---------------- BUTTON TABS ----------------

  Widget _tabButton(String text, int index) {
    bool active = currentTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => currentTab = index);

          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LaporanPelangganScreen()),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF8BC34A) : Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(text),
        ),
      ),
    );
  }

  Widget _periodButton(String text, int index) {
    bool active = period == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => period = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF8BC34A) : Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(text),
        ),
      ),
    );
  }

  // ---------------- BIG CARD ----------------

  Widget _pendapatanCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        children: const [
          Text("PENDAPATAN", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Text(
            "36.000.000",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text("540 transaksi", style: TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _smallCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // ---------------- LIST: PENJUALAN PALING BANYAK ----------------

  Widget _penjualanTerbanyak() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Penjualan Paling Banyak",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              backgroundColor: Color(0xFFC7E6A6),
            ),
          ),
          SizedBox(height: 10),
          Text("⭐ Bayam : 120 ikat terjual"),
          Text("⭐ Wortel : 50 kg terjual"),
          Text("⭐ Kentang : 40 kg terjual"),
        ],
      ),
    );
  }

  // ---------------- LIST KASIR ----------------

  Widget _listKasir() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "KASIR",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              backgroundColor: Color(0xFFC7E6A6),
            ),
          ),
          const SizedBox(height: 10),

          _kasirRow("Cheila Robitul", "110 item", "10.000.000"),
          _kasirRow("Cinta Laura", "98 item", "8.500.000"),
          _kasirRow("Putri Amell", "88 item", "7.485.000"),
        ],
      ),
    );
  }

  Widget _kasirRow(String nama, String item, String total) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(nama),
          Text(item),
          Text(total),
        ],
      ),
    );
  }

  // ---------------- BUTTON ----------------

  Widget _btn(String text, VoidCallback onTap) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8BC34A),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
