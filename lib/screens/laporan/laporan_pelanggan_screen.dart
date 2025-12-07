import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '/widgets/bottom_nav.dart'; // IMPORT BOTTOM NAV
import 'laporan_kasir_screen.dart';

class LaporanPelangganScreen extends StatefulWidget {
  const LaporanPelangganScreen({super.key});

  @override
  State<LaporanPelangganScreen> createState() => _LaporanPelangganState();
}

class _LaporanPelangganState extends State<LaporanPelangganScreen> {
  int currentTab = 1; // pelanggan
  int period = 0;

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

              _pelangganCard(),

              const SizedBox(height: 20),

              _grafikTransaksi(),

              const SizedBox(height: 20),

              _riwayatPelanggan(),

              const SizedBox(height: 20),

              _btn("Cetak Struk Transaksi (PDF)", () {}),
              _btn("Cetak Laporan Penjualan (PDF)", () {}),
              _btn("Export Laporan (PDF)", () {}),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // PAKAI WIDGET BOTTOM NAV
      bottomNavigationBar: const BottomNav(),
    );
  }

  // ---------------- TAB BUTTON ----------------

  Widget _tabButton(String text, int index) {
    bool active = currentTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => currentTab = index);

          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LaporanKasirScreen()),
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

  Widget _pelangganCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        children: const [
          Text("Transaksi", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Text(
            "540 transaksi",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text(
            "36.000.000",
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // ---------------- GRAFIK ----------------

  Widget _grafikTransaksi() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black, width: 2),
      ),
      height: 220,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 100,
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),

          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  const months = ["JUL", "AGUST", "SEPT", "OKT"];
                  if (value.toInt() >= 0 && value.toInt() < months.length) {
                    return Text(months[value.toInt()]);
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),

          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Colors.black,
              barWidth: 2.5,
              spots: const [
                FlSpot(0, 40),
                FlSpot(1, 70),
                FlSpot(2, 55),
                FlSpot(3, 80),
              ],
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF8BC34A).withOpacity(0.5),
                    const Color(0xFF8BC34A).withOpacity(0.15),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- RIWAYAT ----------------

  Widget _riwayatPelanggan() {
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
            "RIWAYAT PENJUALAN",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              backgroundColor: Color(0xFFC7E6A6),
            ),
          ),
          const SizedBox(height: 12),

          _row("Vino G", "28.000"),
          _row("Putri Cantika", "35.000"),
          _row("Sinta Sari", "92.000"),
          _row("Amelia Sari", "110.000"),
          _row("Mawar Melati", "90.000"),
        ],
      ),
    );
  }

  Widget _row(String nama, String total) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(nama),
          Text("Rp $total"),
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