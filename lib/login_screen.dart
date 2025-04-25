import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widget/navbar_overlay.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _user = '';
  String _password = '';
  final GetStorage _storage = GetStorage();
  bool _isLoading = false; // Tambahkan state untuk indikator loading

  Future<void> _attemptLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true; // Tampilkan indikator loading
      });

      try {
        // Login menggunakan Supabase Authentication
        final response = await Supabase.instance.client.auth.signInWithPassword(
          email: '$_user@example.com', // Anggap username adalah bagian dari email
          password: _password,
        );

        if (response.user != null) {
          // Ambil data profil dari tabel profiles
          final profileResponse = await Supabase.instance.client
              .from('profiles')
              .select('ulp, role')
              .eq('id', response.user!.id)
              .single();

          if (profileResponse.isNotEmpty) {
            // Simpan data ke GetStorage untuk digunakan di aplikasi
            _storage.write('username', _user);
            _storage.write('ulp', profileResponse['ulp']);
            _storage.write('role', profileResponse['role']);

            // Tampilkan snackbar sukses
            Get.snackbar(
              'Sukses',
              'Login berhasil',
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 1),
              titleText: const Text(
                'Sukses',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              messageText: const Text(
                'Login berhasil',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            );

            // Navigasi ke BerandaScreen
            Get.off(() => const BerandaScreen());
          } else {
            throw Exception('Profil user tidak ditemukan');
          }
        }
      } catch (error) {
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
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          messageText: const Text(
            'User atau password salah',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false; // Sembunyikan indikator loading
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color.fromARGB(255, 40, 40, 40),
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
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  labelStyle: const TextStyle(color: Colors.blue),
                ),
                validator: (value) => value!.isEmpty ? 'User tidak boleh kosong' : null,
                onSaved: (value) => _user = value!,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  labelStyle: const TextStyle(color: Colors.blue),
                ),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Password tidak boleh kosong' : null,
                onSaved: (value) => _password = value!,
                onFieldSubmitted: (value) => _attemptLogin(),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator() // Tampilkan indikator loading
                  : ElevatedButton(
                      onPressed: _attemptLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
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
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Get.to(() => const RegisterScreen());
                },
                child: const Text(
                  'Belum punya akun? Register di sini',
                  style: TextStyle(color: Colors.blue, fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}