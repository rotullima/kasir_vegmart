import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://ayvgwmbbzvcetohifaex.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF5dmd3bWJienZjZXRvaGlmYWV4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE0NjgwMjMsImV4cCI6MjA3NzA0NDAyM30.DGqauPKKPdzoK-zLhKSS5itrNwh78J1vfIAyOV8dsk4',
    );
  }
}
