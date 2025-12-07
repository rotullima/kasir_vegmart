import 'package:flutter/material.dart';
import '/services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool _loading = false;

void _handleSignup() async {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();
  final confirm = confirmController.text.trim();

  // VALIDASI KOSONG
  if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Semua field wajib diisi")),
    );
    return;
  }

  // VALIDASI EMAIL HARUS @gmail.com
  if (!email.endsWith("@gmail.com")) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Format email salah")),
    );
    return;
  }

  // VALIDASI FORMAT EMAIL (umum)
  final emailValid = RegExp(
    r"^[a-zA-Z0-9._%+-]+@gmail\.com$"
  ).hasMatch(email);

  if (!emailValid) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Format email gmail tidak valid")),
    );
    return;
  }

  // PASSWORD CONFIRM
  if (password != confirm) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password tidak sama")),
    );
    return;
  }

  // MINIMAL PASSWORD
  if (password.length < 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password minimal 6 karakter")),
    );
    return;
  }

  setState(() => _loading = true);

  // CALL AUTH SERVICE
  final res = await AuthService.signup(email, password);

  setState(() => _loading = false);

  if (res != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res)),
    );
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Akun berhasil dibuat! Silakan login.")),
  );

  Navigator.pushNamed(context, "/login");
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 199, 230, 179),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              const SizedBox(height: 20),

              Transform.translate(
                offset: const Offset(61, 38),
                child: Image.asset(
                  "assets/images/logo_daun.png",
                  height: 80,
                ),
              ),

              const Text(
                "VegMart.ID",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 80),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Create your Account",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // EMAIL
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "email",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "email..",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // PASSWORD
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "password",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "password..",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // CONFIRM PASSWORD
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "confirm password",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: confirmController,
                obscureText: _obscureConfirm,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "confirm password..",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirm = !_obscureConfirm;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // BUTTON SIGNUP
              SizedBox(
                width: 300,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 28, 78, 19),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: _loading ? null : _handleSignup,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "sign-up",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account ? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: const Text(
                      "Login here",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
