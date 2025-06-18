import 'package:flutter/material.dart';
import 'package:toko_kita/widget/success_dialog.dart';
import 'package:toko_kita/widget/warning_dialog.dart';
import 'package:toko_kita/bloc/registrasi_bloc.dart';


class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
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
                const Icon(Icons.person_add, size: 80, color: Colors.blue),
                const SizedBox(height: 16),
                const Text(
                  "Buat Akun Baru",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Silakan isi data registrasi di bawah ini",
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 32),
                _namaTextField(),
                const SizedBox(height: 16),
                _emailTextField(),
                const SizedBox(height: 16),
                _passwordTextField(),
                const SizedBox(height: 16),
                _passwordKonfirmasiTextField(),
                const SizedBox(height: 24),
                _buttonRegistrasi(),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}


  // Membuat Textbox Nama
  Widget _namaTextField() {
  return TextFormField(
    controller: _namaTextboxController,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      labelText: 'Nama',
      prefixIcon: const Icon(Icons.person),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    validator: (value) =>
        value!.length < 3 ? 'Nama harus minimal 3 karakter' : null,
  );
}

Widget _emailTextField() {
  return TextFormField(
    controller: _emailTextboxController,
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
      labelText: 'Email',
      prefixIcon: const Icon(Icons.email),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    validator: (value) {
      if (value!.isEmpty) return 'Email harus diisi';
      final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return !regex.hasMatch(value) ? 'Email tidak valid' : null;
    },
  );
}

Widget _passwordTextField() {
  return TextFormField(
    controller: _passwordTextboxController,
    obscureText: true,
    decoration: InputDecoration(
      labelText: 'Password',
      prefixIcon: const Icon(Icons.lock),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    validator: (value) =>
        value!.length < 6 ? 'Password minimal 6 karakter' : null,
  );
}

Widget _passwordKonfirmasiTextField() {
  return TextFormField(
    obscureText: true,
    decoration: InputDecoration(
      labelText: 'Konfirmasi Password',
      prefixIcon: const Icon(Icons.lock_outline),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    validator: (value) =>
        value != _passwordTextboxController.text ? 'Password tidak sama' : null,
  );
}


  // Membuat Tombol Registrasi
  Widget _buttonRegistrasi() {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: _isLoading
          ? null
          : () {
              if (_formKey.currentState!.validate()) _submit();
            },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text("REGISTER", style: TextStyle(fontSize: 16)),
    ),
  );
}

Widget _menuLogin() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Sudah punya akun? "),
      GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, '/login'),
        child: const Text(
          "Login",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    ],
  );
}


  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    

    RegistrasiBloc.registrasi(
      nama: _namaTextboxController.text,
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    ).then((value) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => SuccessDialog(
          description: "Registrasi berhasil, silahkan login",
          okClick: () {
            Navigator.pop(context); // tutup dialog
            Navigator.pushReplacementNamed(context, '/login'); // kembali ke login
          },
        ),
      );
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const WarningDialog(
          description: "Registrasi gagal, silahkan coba lagi",
        ),
      );
    });
  }

}
