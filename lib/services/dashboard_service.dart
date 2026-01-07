import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart'; // untuk debugPrint

class DashboardService {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getTopSoldProducts({int limit = 5}) async {
    try {
      final response = await supabase
          .from('DETAILPENJUALAN')
          .select('''
            produk_id,
            sum(qty) as total_qty,
            PRODUK!inner (nama_produk)
          ''')
          .order('total_qty', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error ambil top produk terjual: $e');
      return [];
    }
  }
}