import 'package:flutter/material.dart';
import 'package:kasir_vegmart/screens/kasir/home_screen.dart';
import '/screens/auth/welcome_screen.dart';
import 'services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService.init();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Supabase.instance.client.auth.currentUser != null
          ? const HomeScreen()
          : const WelcomeScreen(),
    );
  }
}
