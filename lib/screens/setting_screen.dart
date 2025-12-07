import 'package:flutter/material.dart';
import '/services/auth_service.dart';
import '/widgets/bottom_nav.dart'; // IMPORT BOTTOM NAV
import '/screens/auth/login_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color headerBg = const Color(0xFFA7D676);
    final Color cardBg = const Color(0xFFEDEDED);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: headerBg,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Pengaturan",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Profile Card
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  padding: const EdgeInsets.only(top: 55, bottom: 25),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 55,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        "Chella robiatul A",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "081216776982",
                        style: TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "chellarobiatul@gmail.com",
                        style: TextStyle(color: Colors.black87, fontSize: 13),
                      ),

                      const SizedBox(height: 25),

                      // Menu Items
                      _settingItem(
                        icon: Icons.access_time,
                        label: "Jam Kerja",
                        trailing: "5 Jam",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const JamKerjaPage(),
                            ),
                          );
                        },
                      ),

                      _settingItem(
                        icon: Icons.email,
                        label: "E-mail",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EmailPage(),
                            ),
                          );
                        },
                      ),

                      _settingItem(
                        icon: Icons.lock_outline,
                        label: "Password..",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PasswordPage(),
                            ),
                          );
                        },
                      ),

                      _settingItem(
                        icon: Icons.phone,
                        label: "No tlpn",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PhonePage(),
                            ),
                          );
                        },
                      ),

                      _settingItem(
                        icon: Icons.language,
                        label: "Bahasa",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LanguagePage(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 18),

                      // Logout
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Logout"),
                              content: const Text("Yakin ingin keluar?"),
                              actions: [
                                TextButton(
                                  child: const Text("Batal"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: const Text(
                                    "Logout",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).pop(); // tutup dialog

                                    await AuthService.logout();

                                    WidgetsBinding.instance.addPostFrameCallback((
                                      _,
                                    ) {
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
                                        ), // ← ganti ke nama class kamu
                                        (route) =>
                                            false, // hapus semua route sebelumnya
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 35,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // PAKAI WIDGET BOTTOM NAV
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget _settingItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    String? trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 14),
            Text(label, style: const TextStyle(fontSize: 14)),
            const Spacer(),
            if (trailing != null)
              Text(
                trailing,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            const SizedBox(width: 6),
            const Icon(Icons.edit, size: 18),
          ],
        ),
      ),
    );
  }
}

// -------------------------------
// Dummy Pages
// -------------------------------

class JamKerjaPage extends StatelessWidget {
  const JamKerjaPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Jam Kerja')),
    body: const Center(child: Text("Halaman Jam Kerja")),
  );
}

class EmailPage extends StatelessWidget {
  const EmailPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('E-mail')),
    body: const Center(child: Text("Halaman Email")),
  );
}

class PasswordPage extends StatelessWidget {
  const PasswordPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Password')),
    body: const Center(child: Text("Halaman Password")),
  );
}

class PhonePage extends StatelessWidget {
  const PhonePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('No tlpn')),
    body: const Center(child: Text("Halaman Nomor Telepon")),
  );
}

class LanguagePage extends StatelessWidget {
  const LanguagePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Bahasa')),
    body: const Center(child: Text("Halaman Bahasa")),
  );
}
