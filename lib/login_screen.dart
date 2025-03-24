import 'package:flutter/material.dart';
import 'widget/navbar_overlay.dart'; // Import BerandaScreen

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BerandaScreen()),
        );
      } else {
        // Login gagal -> tampilkan alert
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Login Ditolak'),
              content: const Text('User atau password salah'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'User',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'User tidak boleh kosong' : null,
                onSaved: (value) => _user = value!,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator:
                    (value) =>
                        value!.isEmpty ? 'Password tidak boleh kosong' : null,
                onSaved: (value) => _password = value!,
                onFieldSubmitted: (value) => _attemptLogin(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _attemptLogin,
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
