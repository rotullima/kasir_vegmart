import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '/widgets/bottom_nav.dart'; // IMPORT BOTTOM NAV

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isCustomerExpanded = false;
  bool isTransactionExpanded = false;
  bool isStockExpanded = false;

  PageController chartController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9E8C5),

      appBar: AppBar(
        backgroundColor: const Color(0xFFD9E8C5),
        elevation: 0,
        toolbarHeight: 150,
        leadingWidth: 260,

        leading: Padding(
          padding: const EdgeInsets.only(left: 30, top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: const Offset(40, 25),
                child: Image.asset("assets/images/logo_daun.png", height: 50),
              ),
              const SizedBox(height: 2),
              const Text(
                "VegMart.ID",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A6C38),
                ),
              ),
              const Text(
                "Your Dashboard",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                chartController.hasClients
                    ? (chartController.page?.round() == 0
                          ? "Grafik Harian"
                          : chartController.page?.round() == 1
                          ? "Grafik Mingguan"
                          : "Grafik Bulanan")
                    : "Grafik Harian",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 40),
            child: Icon(
              Icons.notifications_outlined,
              color: Colors.black,
              size: 40,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _buildChartCarousel(),
            const SizedBox(height: 20),
            _buildCardHeader(
              icon: Icons.person_outline,
              title: "Customer Aktif",
              value: "6",
              expanded: isCustomerExpanded,
              onTap: () {
                setState(() => isCustomerExpanded = !isCustomerExpanded);
              },
            ),
            if (isCustomerExpanded) _buildCustomerList(),
            const SizedBox(height: 40),
            _buildCardHeader(
              icon: Icons.shopping_cart_outlined,
              title: "Transaksi Hari Ini",
              value: "4",
              expanded: isTransactionExpanded,
              onTap: () {
                setState(
                  () => isTransactionExpanded = !isTransactionExpanded,
                );
              },
            ),
            if (isTransactionExpanded) _buildTransactionList(),
            const SizedBox(height: 40),
            _buildCardHeader(
              icon: Icons.inventory_2_outlined,
              title: "Stok Barang",
              value: "6",
              expanded: isStockExpanded,
              onTap: () {
                setState(() => isStockExpanded = !isStockExpanded);
              },
            ),
            if (isStockExpanded) _buildStockList(),
            const SizedBox(height: 80),
          ],
        ),
      ),

      // PAKAI WIDGET BOTTOM NAV
      bottomNavigationBar: const BottomNav(),
    );
  }

  // ------------------------------------------------------------
  // ⭐ CHART CAROUSEL
  // ------------------------------------------------------------
  Widget _buildChartCarousel() {
    return SizedBox(
      height: 200,
      child: PageView(
        controller: chartController,
        onPageChanged: (_) => setState(() {}),
        children: [_buildBarChart(), _buildLineChart(), _buildAreaChart()],
      ),
    );
  }

  // ------------------------------------------------------------
  // BAR CHART
  // ------------------------------------------------------------
  Widget _buildBarChart() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2F4A2F),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(12),
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: 6,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),

          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                reservedSize: 20,
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),

            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  const labels = [
                    "cabe",
                    "gula",
                    "wortel",
                    "penyedap",
                    "kunir",
                  ];
                  if (value.toInt() < labels.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        labels[value.toInt()],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),

          barGroups: List.generate(5, (i) {
            final tinggi = [4, 5, 6, 4, 3][i].toDouble();

            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: tinggi,
                  width: 22,
                  borderRadius: BorderRadius.circular(20),

                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.white.withOpacity(0.25),
                      Colors.white.withOpacity(0.65),
                    ],
                  ),

                  rodStackItems: [
                    BarChartRodStackItem(tinggi - 0.1, tinggi, Colors.white),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // LINE CHART
  // ------------------------------------------------------------
  Widget _buildLineChart() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 100,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                reservedSize: 30,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      (value.toInt() + 1).toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 40),
                FlSpot(1, 65),
                FlSpot(2, 70),
                FlSpot(3, 50),
                FlSpot(4, 68),
                FlSpot(5, 60),
                FlSpot(6, 80),
                FlSpot(7, 78),
                FlSpot(8, 95),
                FlSpot(9, 60),
                FlSpot(10, 88),
                FlSpot(11, 85),
              ],
              isCurved: true,
              color: Colors.black,
              barWidth: 2.5,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.black,
                    strokeWidth: 0,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade900.withOpacity(0.6),
                    Colors.green.shade900.withOpacity(0.2),
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

  // ------------------------------------------------------------
  // AREA CHART
  // ------------------------------------------------------------
  Widget _buildAreaChart() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 100,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                reservedSize: 30,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  const days = [
                    "senin",
                    "selasa",
                    "rabu",
                    "kamis",
                    "jumat",
                    "sabtu",
                    "minggu",
                  ];
                  if (value.toInt() >= 0 && value.toInt() < days.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        days[value.toInt()],
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 60),
                FlSpot(1, 50),
                FlSpot(2, 55),
                FlSpot(3, 75),
                FlSpot(4, 80),
                FlSpot(5, 82),
                FlSpot(6, 95),
              ],
              isCurved: true,
              color: Colors.black,
              barWidth: 2.5,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.black,
                    strokeWidth: 0,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade700.withOpacity(0.4),
                    Colors.green.shade700.withOpacity(0.1),
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

  // ------------------------------------------------------------
  // CARD HEADER
  // ------------------------------------------------------------
  Widget _buildCardHeader({
    required IconData icon,
    required String title,
    required String value,
    required bool expanded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 110,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, size: 28, color: Colors.black),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            Icon(
              expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 26,
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // LIST CUSTOMER
  // ------------------------------------------------------------
  Widget _buildCustomerList() {
    final customers = [
      "Chella",
      "Rotul",
      "Zahra",
      "Nadya",
      "Melati",
      "Clarissa",
    ];

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: customers.map((name) {
          return ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(name),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFCDE59B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Aktif",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ------------------------------------------------------------
  // LIST TRANSAKSI
  // ------------------------------------------------------------
  Widget _buildTransactionList() {
    final items = ["Chella", "Rotul", "Zahra", "Melati"];

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: items.map((name) {
          return ListTile(
            leading: const Icon(Icons.shopping_cart_outlined),
            title: Text(name),
            subtitle: const Text("Total : Rp 21.000"),
            trailing: const Text("2025"),
          );
        }).toList(),
      ),
    );
  }

  // ------------------------------------------------------------
  // LIST STOK
  // ------------------------------------------------------------
  Widget _buildStockList() {
    final stock = {
      "Bawang Putih": "13kg",
      "Bawang Merah": "10kg",
      "Cabai": "8kg",
      "Wortel": "3kg",
      "Gobal": "6kg",
      "Kentang": "10kg",
    };

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: stock.entries.map((item) {
          return ListTile(
            title: Text(item.key),
            trailing: Text(
              "Stok : ${item.value}",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          );
        }).toList(),
      ),
    );
  }
}