// lib/services/transaksi_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '/providers/cart_provider.dart';
import 'package:intl/intl.dart';

class TransaksiService {
  final supabase = Supabase.instance.client;

  /// Return Map dengan key: nomorTransaksi, penjualanId
  Future<Map<String, dynamic>> simpanTransaksi({
    required List<CartItem> items,
    required double total,
    required String metodePembayaran,
    required String kasirId,
  }) async {
    try {
      // Validasi kasir ID
      if (kasirId.isEmpty) {
        throw Exception('Kasir belum login');
      }

      // 1. Validasi stok untuk semua item terlebih dahulu
      for (var item in items) {
        final stokRes = await supabase
            .from('STOK')
            .select('jumlah_stok')
            .eq('produk_id', item.produkId)
            .order('created_at', ascending: false)
            .limit(1);

        if (stokRes.isEmpty) {
          throw Exception('Produk ${item.namaProduk} belum memiliki data stok awal');
        }

        final stokTersedia = stokRes.first['jumlah_stok'] as int;
        if (stokTersedia < item.qty) {
          throw Exception(
            'Stok ${item.namaProduk} tidak cukup! Tersedia: $stokTersedia kg, Diminta: ${item.qty} kg',
          );
        }
      }

      // 2. Generate kode transaksi unik
      final dateStr = DateFormat('yyyyMMdd').format(DateTime.now());
      final countRes = await supabase
          .from('PENJUALAN')
          .select('kode_transaksi')
          .like('kode_transaksi', 'TRX-$dateStr%')
          .order('created_at', ascending: false)
          .limit(1);

      int nomorUrut = 1;
      if (countRes.isNotEmpty) {
        final lastTransaksi = countRes.first['kode_transaksi'] as String?;
        if (lastTransaksi != null) {
          final lastNumber = int.tryParse(lastTransaksi.split('-').last) ?? 0;
          nomorUrut = lastNumber + 1;
        }
      }
      final kodeTransaksi = 'TRX-$dateStr-${nomorUrut.toString().padLeft(3, '0')}';

      // 3. Dapatkan pelanggan_id (jika ada, atau bisa null)
      // Untuk sekarang kita set null, atau bisa diambil dari parameter jika ada
      final pelangganId = null;

      // 4. Simpan header transaksi ke PENJUALAN
      final penjualanRes = await supabase
          .from('PENJUALAN')
          .insert({
            'kode_transaksi': kodeTransaksi,
            'tanggal_penjualan': DateTime.now().toIso8601String(),
            'total_harga': total.toInt(),
            'pelanggan_id': pelangganId,
            'transaksi': metodePembayaran, // "cash" atau "tf"
            'kasir_id': kasirId,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select('id, kode_transaksi')
          .single();

      final penjualanId = penjualanRes['id'] as int;

      // 5. Proses setiap item
      for (var item in items) {
        // Ambil stok terakhir
        final stokRes = await supabase
            .from('STOK')
            .select('jumlah_stok')
            .eq('produk_id', item.produkId)
            .order('created_at', ascending: false)
            .limit(1);

        final stokSekarang = stokRes.first['jumlah_stok'] as int;
        final stokBaru = stokSekarang - item.qty;

        // INSERT log histori stok (dengan jumlah_perubahan negatif)
        await supabase.from('STOK').insert({
          'produk_id': item.produkId,
          'stok_terakhir': stokSekarang,
          'jumlah_perubahan': -item.qty,
          'jumlah_stok': stokBaru,
          'created_at': DateTime.now().toIso8601String(),
        });

        // Simpan detail penjualan
        await supabase.from('DETAILPENJUALAN').insert({
          'penjualan_id': penjualanId,
          'produk_id': item.produkId,
          'jumlah_produk': item.qty,
          'subtotal': (item.harga * item.qty).toInt(),
          'diskon_produk': 0,
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      // Sukses
      print('✅ Transaksi sukses: $kodeTransaksi - $metodePembayaran');
      return {
        'nomorTransaksi': kodeTransaksi,
        'penjualanId': penjualanId,
      };
    } on PostgrestException catch (e) {
      print('❌ PostgrestException: ${e.message} (code: ${e.code})');
      throw Exception(
        'Gagal menyimpan transaksi: ${e.message}',
      );
    } catch (e) {
      print('❌ Error: $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}