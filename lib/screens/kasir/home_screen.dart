// lib/screens/kasir/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/widgets/bottom_nav.dart';
import '/providers/cart_provider.dart';
import 'keranjang_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> allProducts = []; // simpan semua produk
  List<Map<String, dynamic>> displayedProducts = []; // yang ditampilkan setelah filter
  bool isLoading = true;
  String? selectedCategory; // null = semua produk

  @override
  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
    setState(() => isLoading = true);
    try {
      final res = await Supabase.instance.client
          .from('PRODUK')
          .select('id, nama_produk, harga_produk, gambar, kategori');

      setState(() {
        allProducts = List<Map<String, dynamic>>.from(res);
        // Default: tampilkan semua
        displayedProducts = List.from(allProducts);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat produk: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void filterProducts(String? category) {
    setState(() {
      selectedCategory = category;

      if (category == null) {
        displayedProducts = List.from(allProducts);
      } else {
        displayedProducts = allProducts
            .where((p) => (p['kategori'] as String?)?.toLowerCase() == category.toLowerCase())
            .toList();
      }
    });
  }

  Future<List<String>> _getUniqueCategories() async {
    final categories = allProducts
        .map((p) => p['kategori'] as String?)
        .whereType<String>()
        .where((cat) => cat.trim().isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    return categories;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

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
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const KeranjangScreen()),
                  );
                },
              ),
              if (cart.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${cart.itemCount}',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
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

              // Kategori icons (dengan indikator selected)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _categoryIcon(
                    iconPath: 'sayur1.png',
                    label: 'Semua',
                    category: null,
                  ),
                  _categoryIcon(
                    iconPath: 'sayur2.png',
                    label: 'Pelengkap',
                    category: 'pelengkap',
                  ),
                  _categoryIcon(
                    iconPath: 'sayur3.png',
                    label: 'Sayur',
                    category: 'sayur',
                  ),
                  _categoryIcon(
                    iconPath: 'sayur4.png',
                    label: 'Rempah',
                    category: 'rempah',
                  ),
                  _categoryIcon(
                    iconPath: 'sayur5.png',
                    label: 'Buah',
                    category: 'buah',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Tampilan produk
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : displayedProducts.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Text(
                              'Tidak ada produk di kategori ini',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                        )
                      : Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: displayedProducts.map((produk) {
                            return produkCard(
                              produkId: produk['id'] as int,
                              title: produk['nama_produk'] ?? 'Produk',
                              namaProduk: produk['nama_produk'] ?? 'Produk',
                              price: 'Rp ${(produk['harga_produk'] ?? 0).toStringAsFixed(0)}',
                              harga: (produk['harga_produk'] as num?)?.toDouble() ?? 0.0,
                              image: produk['gambar'] ?? '',
                              gambar: produk['gambar'] ?? '',
                              onAdd: () {
                                final cartProvider = Provider.of<CartProvider>(
                                  context,
                                  listen: false,
                                );

                                cartProvider.addItem(
                                  CartItem(
                                    produkId: produk['id'] as int,
                                    namaProduk: produk['nama_produk'] ?? 'Produk',
                                    gambar: produk['gambar'] ?? '',
                                    harga: (produk['harga_produk'] as num?)?.toDouble() ?? 0.0,
                                  ),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${produk['nama_produk'] ?? 'Produk'} ditambahkan ke keranjang'),
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: const Color.fromARGB(255, 3, 92, 16),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _categoryIcon({
    required String iconPath,
    required String label,
    required String? category,
  }) {
    final isSelected = selectedCategory == category;

    return GestureDetector(
      onTap: () => filterProducts(category),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: Colors.green, width: 3) : null,
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              child: Image.asset('assets/images/$iconPath', height: 36),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? Colors.green : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget produkCard({
    required int produkId,
    required String title,
    required String namaProduk,
    required String price,
    required double harga,
    required String image,
    required String gambar,
    required VoidCallback onAdd,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              image,
              height: 90,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Image.asset(
                'assets/images/default.png',
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            price,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.green,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.add, color: Colors.white, size: 16),
                onPressed: onAdd,
              ),
            ),
          ),
        ],
      ),
    );
  }
}