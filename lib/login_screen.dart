import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/navbar_overlay.dart'; // Impor BerandaScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _user = '';
  String _password = '';

  void _attemptLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_user == 'user' && _password == 'admin') {
        // Login sukses -> navigasi ke BerandaScreen
        Get.off(() => const BerandaScreen());
      } else {
        // Login gagal -> tampilkan snackbar
        Get.snackbar(
          'Error',
          'User atau password salah',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
          titleText: const Text(
            'Error',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          messageText: const Text(
            'User atau password salah',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Color.fromARGB(255, 40, 40, 40), // Ganti AppColors.primary dengan Colors.blue
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'User',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue), // Ganti AppColors.primary
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  labelStyle: const TextStyle(color: Colors.blue), // Ganti AppColors.primary
                ),
                validator: (value) => value!.isEmpty ? 'User tidak boleh kosong' : null,
                onSaved: (value) => _user = value!,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue), // Ganti AppColors.primary
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  labelStyle: const TextStyle(color: Colors.blue), // Ganti AppColors.primary
                ),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Password tidak boleh kosong' : null,
                onSaved: (value) => _password = value!,
                onFieldSubmitted: (value) => _attemptLogin(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _attemptLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Ganti AppColors.primary
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 17.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}