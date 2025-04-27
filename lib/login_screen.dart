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
  String _email = ''; // Ubah dari _user menjadi _email
  String _password = '';
  final GetStorage _storage = GetStorage();
  bool _isLoading = false;

  Future<void> _attemptLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        // Login menggunakan Supabase Authentication
        final response = await Supabase.instance.client.auth.signInWithPassword(
          email: _email, // Gunakan email langsung dari input
          password: _password,
        );

        if (response.user != null) {
          // Ambil data profil dari tabel profiles
          final profileResponse = await Supabase.instance.client
              .from('profiles')
              .select('username, ulp, role')
              .eq('id', response.user!.id)
              .single();

          if (profileResponse.isNotEmpty) {
            // Simpan data ke GetStorage untuk digunakan di aplikasi
            _storage.write('username', profileResponse['username']);
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
            // Jika profil tidak ditemukan, coba ambil dari raw_user_meta_data
            final userMetadata = response.user!.userMetadata ?? {};
            final username = userMetadata['username'] ?? 'Unknown';
            final ulp = userMetadata['ulp'] ?? 'Unknown';
            final role = userMetadata['role'] ?? 'Surveyor';

            // Simpan data ke GetStorage
            _storage.write('username', username);
            _storage.write('ulp', ulp);
            _storage.write('role', role);

            // Insert data ke tabel profiles jika belum ada
            await Supabase.instance.client.from('profiles').insert({
              'id': response.user!.id,
              'username': username,
              'ulp': ulp,
              'role': role,
            });

            Get.snackbar(
              'Sukses',
              'Login berhasil, profil dibuat',
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
                'Login berhasil, profil dibuat',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            );

            Get.off(() => const BerandaScreen());
          }
        }
      } catch (error) {
        // Login gagal -> tampilkan snackbar dengan pesan error yang lebih spesifik
        String errorMessage = 'User atau password salah';
        if (error.toString().contains('invalid login credentials')) {
          errorMessage = 'Email atau password salah';
        } else if (error.toString().contains('email not confirmed')) {
          errorMessage = 'Email belum dikonfirmasi';
        } else {
          errorMessage = 'Gagal login: $error';
        }

        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          titleText: const Text(
            'Error',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          messageText: Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
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
                  labelText: 'Email', // Ubah label menjadi Email
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  labelStyle: const TextStyle(color: Colors.blue),
                ),
                keyboardType: TextInputType.emailAddress, // Tambahkan tipe keyboard email
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Masukkan email yang valid';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
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
                  ? const CircularProgressIndicator()
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