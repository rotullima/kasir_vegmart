import 'supabase_service.dart';

class AuthService {
  static final supabase = SupabaseService.client;

  /// LOGIN 
  /// return null kalau sukses
  /// return string kalau error
  static Future<String?> login(String email, String password) async {
    try {
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user == null) {
        return "Email atau password salah";
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// SIGNUP
  static Future<String?> signup(String email, String password) async {
    try {
      final res = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (res.user == null) {
        return "Gagal membuat akun.";
      }

      // OPTIONAL: insert ke table profiles
      await supabase.from('profiles').insert({
        'user_id': res.user!.id,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// LOGOUT
  static Future<void> logout() async {
    await supabase.auth.signOut();
  }
}
