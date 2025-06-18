import 'package:flutter/material.dart';
import 'package:toko_kita/bloc/login_bloc.dart';
import 'package:toko_kita/helpers/user_info.dart';
import 'package:toko_kita/ui/produk_page.dart';
import 'package:toko_kita/ui/registrasi_page.dart';
import 'package:toko_kita/widget/warning_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.lock, size: 80, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text(
                    "Selamat Datang",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Silakan login untuk melanjutkan",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 32),
                  _emailTextField(),
                  const SizedBox(height: 16),
                  _passwordTextField(),
                  const SizedBox(height: 24),
                  _buttonLogin(),
                  const SizedBox(height: 16),
                  _menuRegistrasi(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Add the missing _emailTextField method
  Widget _emailTextField() {
    return TextFormField(
      controller: _emailTextboxController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: "Email",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email tidak boleh kosong';
        }
        // Simple email validation
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Format email tidak valid';
        }
        return null;
      },
    );
  }

  // Add the missing _passwordTextField method
  Widget _passwordTextField() {
    return TextFormField(
      controller: _passwordTextboxController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: "Password",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password tidak boleh kosong';
        }
        return null;
      },
    );
  }

  // Add the missing _buttonLogin method
  Widget _buttonLogin() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed:
            _isLoading
                ? null
                : () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                    });
                    // Simulate login logic or call your login bloc here
                    // For now, just navigate to ProdukPage after a short delay
                    await Future.delayed(const Duration(seconds: 1));
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProdukPage(),
                      ),
                    );
                  }
                },
        child:
            _isLoading
                ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                : const Text("Login"),
      ),
    );
  }

  // Add the missing _menuRegistrasi method
  Widget _menuRegistrasi() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Belum punya akun?"),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegistrasiPage()),
            );
          },
          child: const Text("Registrasi"),
        ),
      ],
    );
  }
}
