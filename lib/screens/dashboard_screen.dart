import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '/widgets/bottom_nav.dart';
import '/services/dashboard_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isCustomerExpanded = false;
  bool isTransactionExpanded = false;
  bool isStockExpanded = false;

  final PageController chartController = PageController(); // ← hapus const di sini

  List<Map<String, dynamic>> topProducts = [];
  bool isLoadingChart = true;

  final DashboardService _dashboardService = DashboardService();

  @override
  void initState() {
    super.initState();
    _loadTopProducts();
  }

  Future<void> _loadTopProducts() async {
    final result = await _dashboardService.getTopSoldProducts(limit: 5);
    if (mounted) {
      setState(() {
        topProducts = result;
        isLoadingChart = false;
      });
    }
  }

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
                setState(() => isTransactionExpanded = !isTransactionExpanded);
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
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _buildChartCarousel() {
    return SizedBox(
      height: 200,
      child: PageView(
        controller: chartController,
        onPageChanged: (_) => setState(() {}),
        children: [
          _buildBarChart(),
          _buildLineChart(),
          _buildAreaChart(),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    if (isLoadingChart) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (topProducts.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada penjualan',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    // Akses data dengan aman (ini sering bikin null error)
    final List<String> productNames = topProducts.map((p) {
      final produkMap = p['PRODUK'] as Map<String, dynamic>?;
      return produkMap?['nama_produk'] as String? ?? 'Produk Tidak Dikenal';
    }).toList();

    final List<double> quantities = topProducts.map((p) {
      return (p['total_qty'] as num?)?.toDouble() ?? 0.0;
    }).toList();

    final maxY = quantities.isNotEmpty
        ? quantities.reduce((a, b) => a > b ? a : b) + 5
        : 10.0;

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
          maxY: maxY,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: maxY / 5,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                reservedSize: 30,
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < productNames.length) {
                    final name = productNames[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        name.length > 8 ? '${name.substring(0, 8)}..' : name,
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          barGroups: List.generate(quantities.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: quantities[i],
                  width: 22,
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white, // Ganti gradient jadi solid dulu biar simpel & fix deprecated
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // warning deprecated, tapi masih jalan
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(  // ← ini wajib! tambahkan data minimal biar nggak error
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [], // kosong dulu, nanti kamu isi data asli
        ),
      ),
    );
  }

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
        LineChartData(  // ← sama seperti atas, tambahkan ini
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [], // kosong dulu
        ),
      ),
    );
  }

  // ↓↓↓ Semua method di bawah ini PASTIKAN kode asli kamu ada di sini ↓↓↓
  // Jangan hapus atau ubah bagian ini!
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

  Widget _buildCustomerList() {
    // ← kode asli kamu untuk list customer
    // paste di sini kalau belum ada
    return const SizedBox(); // placeholder
  }

  Widget _buildTransactionList() {
    // ← kode asli kamu
    return const SizedBox(); // placeholder
  }

  Widget _buildStockList() {
    // ← kode asli kamu
    return const SizedBox(); // placeholder
  }
}