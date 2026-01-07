import 'package:supabase_flutter/supabase_flutter.dart';

class StokService {
  final supabase = Supabase.instance.client;

  /// ambil semua stok + nama produk + gambar (FRESH dari database)
  Future<List<Map<String, dynamic>>> getAllStok() async {
    final res = await supabase
        .from('STOK')
        .select('''
          id,
          produk_id,
          jumlah_stok,
          created_at,
          PRODUK (
            nama_produk,
            gambar
          )
        ''')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }

  /// update stok (dengan timestamp baru untuk realtime tracking)
  Future<void> updateStok({
    required int stokId,
    required int stokBaru,
  }) async {
    await supabase
        .from('STOK')
        .update({
          'jumlah_stok': stokBaru,
          'created_at': DateTime.now().toIso8601String(),
        })
        .eq('id', stokId);
  }
}