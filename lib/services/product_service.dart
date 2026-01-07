import 'dart:typed_data'; // untuk Uint8List
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProductService {
  final supabase = Supabase.instance.client;
  final bucket = 'produk';

  /// Ambil semua produk
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final res = await supabase
        .from('PRODUK')
        .select(''', *, "STOK"(jumlah_stok) ''');

    return List<Map<String, dynamic>>.from(res);
  }

  /// Ambil produk berdasarkan kategori
  Future<List<Map<String, dynamic>>> getProductsByCategory(String kategori) async {
    final res = await supabase
        .from('PRODUK')
        .select('''
          id,
          nama_produk,
          harga_produk,
          kategori,
          gambar,
          STOK (
            jumlah_stok
          )
        ''')
        .eq('kategori', kategori.trim());

    return List<Map<String, dynamic>>.from(res);
  }

  /// Pick image → mengembalikan bytes + nama file (support web & mobile)
  Future<(Uint8List?, String?)?> pickImageBytes() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return null;

    final bytes = await picked.readAsBytes();
    final fileName = picked.name; // nama file asli

    return (bytes, fileName);
  }

  /// Upload gambar menggunakan bytes (support web & mobile)
  Future<String?> uploadImageBytes(Uint8List bytes, String fileName) async {
    final uniqueName = 'produk_${DateTime.now().millisecondsSinceEpoch}_$fileName';

    await supabase.storage.from(bucket).uploadBinary(
      uniqueName,
      bytes,
      fileOptions: const FileOptions(          // ← perbaikan di sini: FileOptions
        contentType: 'image/jpeg',            // sesuaikan jika perlu (misal 'image/png')
        cacheControl: '3600',
        upsert: false,
      ),
    );

    return supabase.storage.from(bucket).getPublicUrl(uniqueName);
  }

  /// Tambah produk baru
  Future<void> addProduct({
    required String name,
    required num harga,
    required String kategori,
    (Uint8List?, String?)? imageData,
    int stok = 0,
  }) async {
    String? url;

    if (imageData != null && imageData.$1 != null) {
      url = await uploadImageBytes(
        imageData.$1!,
        imageData.$2 ?? 'unknown.jpg',
      );
    }

    final res = await supabase.from('PRODUK').insert({
      'nama_produk': name,
      'harga_produk': harga,
      'kategori': kategori,
      'gambar': url,
    }).select();

    final produkId = res.first['id'] as int;

    await supabase.from('STOK').insert({
      'produk_id': produkId,
      'jumlah_stok': stok,
    });
  }

  /// Update produk
  Future<void> updateProduct({
    required int id,
    String? name,
    num? harga,
    String? kategori,
    (Uint8List?, String?)? imageData,
    int? stok,
  }) async {
    String? url;

    if (imageData != null && imageData.$1 != null) {
      url = await uploadImageBytes(
        imageData.$1!,
        imageData.$2 ?? 'unknown.jpg',
      );
    }

    await supabase.from('PRODUK').update({
      if (name != null) 'nama_produk': name,
      if (harga != null) 'harga_produk': harga,
      if (kategori != null) 'kategori': kategori,
      if (url != null) 'gambar': url,
    }).eq('id', id);

    if (stok != null) {
      final existing = await supabase
          .from('STOK')
          .select('id')
          .eq('produk_id', id);

      if (existing.isEmpty) {
        await supabase.from('STOK').insert({
          'produk_id': id,
          'jumlah_stok': stok,
        });
      } else {
        await supabase
            .from('STOK')
            .update({'jumlah_stok': stok})
            .eq('produk_id', id);
      }
    }
  }

  /// Hapus produk (tetap sama, warning print bisa diabaikan atau ganti ke debugPrint)
  Future<void> deleteProduct(int id) async {
    try {
      await supabase
          .from('DETAILPENJUALAN')
          .delete()
          .eq('produk_id', id);

      await supabase
          .from('STOK')
          .delete()
          .eq('produk_id', id);

      await supabase
          .from('PRODUK')
          .delete()
          .eq('id', id);
    } catch (e) {
      // print('DELETE ERROR: $e'); // ← hapus atau ganti ke logging lain
      rethrow;
    }
  }
}