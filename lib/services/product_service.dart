import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProductService {
  final supabase = Supabase.instance.client;
  final bucket = 'produk';

  /// Ambil semua produk
  /// Ambil semua produk
Future<List<Map<String, dynamic>>> getAllProducts() async {
  final res = await supabase
      .from('PRODUK')
      .select(''', *, "STOK"(jumlah_stok) ''');

  return List<Map<String, dynamic>>.from(res);
}

/// Ambil produk berdasarkan kategori ← YANG PALING PENTING!
Future<List<Map<String, dynamic>>> getProductsByCategory(String kategori) async {
  final res = await supabase
      .from('PRODUK')
      .select(''', *, "STOK"(jumlah_stok) ''')
      .ilike('kategori', '%${kategori.trim()}%');

  print("Kategori '$kategori' → hasil: $res");
  return List<Map<String, dynamic>>.from(res);
}



  /// Upload image ke Supabase Storage
  Future<String?> uploadImage(File file) async {
    final fileName =
        'produk_${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
    await supabase.storage.from(bucket).upload(fileName, file);
    return supabase.storage.from(bucket).getPublicUrl(fileName);
  }

  /// Pick image dari gallery
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return null;
    return File(picked.path);
  }

  /// Tambah produk baru
  Future<void> addProduct({
    required String name,
    required num harga,
    required String kategori,
    File? image,
    int stok = 0,
  }) async {
    String? url;
    if (image != null) url = await uploadImage(image);

    // Insert produk
    final res = await supabase.from('PRODUK').insert({
      'nama_produk': name,
      'harga_produk': harga,
      'kategori': kategori,
      'gambar': url,
    }).select(); // ambil id produk yang baru

    final produkId = res[0]['id'];

    // Insert stok awal
    await supabase.from('STOK').insert({'produk_id': produkId, 'jumlah_stok': stok});
  }

  /// Update produk
  Future<void> updateProduct({
    required int id,
    String? name,
    num? harga,
    String? kategori,
    File? image,
    int? stok,
  }) async {
    String? url;
    if (image != null) url = await uploadImage(image);

    // Update produk
    await supabase.from('PRODUK').update({
      if (name != null) 'nama_produk': name,
      if (harga != null) 'harga_produk': harga,
      if (kategori != null) 'kategori': kategori,
      if (url != null) 'gambar': url,
    }).eq('id', id);

    // Update stok kalau ada
    if (stok != null) {
      final existing = await supabase.from('STOK').select().eq('produk_id', id);
      if (existing.isEmpty) {
        // kalau stok belum ada, insert
        await supabase.from('STOK').insert({'produk_id': id, 'jumlah_stok': stok});
      } else {
        // kalau sudah ada, update
        await supabase
            .from('STOK')
            .update({'jumlah_stok': stok})
            .eq('produk_id', id);
      }
    }
  }

  /// Hapus produk
  Future<void> deleteProduct(int id) async {
    // Hapus dulu detail penjualan
    await supabase.from('DETAILPENJUALAN').delete().eq('produk_id', id);
    // Hapus stok
    await supabase.from('STOK').delete().eq('produk_id', id);
    // Hapus produk
    await supabase.from('PRODUK').delete().eq('id', id);
  }
}
