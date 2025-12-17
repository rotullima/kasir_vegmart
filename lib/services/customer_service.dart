import 'package:supabase_flutter/supabase_flutter.dart';

class PelangganService {
  final supabase = Supabase.instance.client;

  // GET ALL
  Future<List<Map<String, dynamic>>> getAllPelanggan() async {
    final res = await supabase
        .from('PELANGGAN')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }

  // ADD
  Future<void> addPelanggan({
    required String nama,
    required int nomor,
    String? transaksiTerbaru,
  }) async {
    await supabase.from('PELANGGAN').insert({
      'nama_pelanggan': nama,
      'no_pelanggan': nomor,
      'transaksi_terbaru': transaksiTerbaru,
    });
  }

  // UPDATE
  Future<void> updatePelanggan({
    required int id,
    required String nama,
    required int nomor,
    String? transaksiTerbaru,
  }) async {
    await supabase.from('PELANGGAN').update({
      'nama_pelanggan': nama,
      'no_pelanggan': nomor,
      'transaksi_terbaru': transaksiTerbaru,
    }).eq('id', id);
  }

  // DELETE
  Future<void> deletePelanggan(int id) async {
    await supabase.from('PELANGGAN').delete().eq('id', id);
  }
}
