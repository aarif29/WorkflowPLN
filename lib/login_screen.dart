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
  String _identifier = ''; // Untuk menyimpan email atau username
  String _password = '';
  final GetStorage _storage = GetStorage();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _attemptLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      String emailToLogin;
      AuthResponse authResponse; // Variabel untuk hasil autentikasi

      // Cek apakah input adalah email atau username
      // Anda bisa membuat pengecekan email lebih robust jika diperlukan
      if (_identifier.contains('@') && _identifier.contains('.')) {
        // Jika input dianggap sebagai email
        emailToLogin = _identifier.trim();
        print('Login dengan email: $emailToLogin');
      } else {
        // Jika input dianggap sebagai username, cari email dari tabel profiles
        // Menggunakan lowercase untuk pencarian case-insensitive
        // Pastikan username di database Anda juga disimpan dalam format lowercase untuk konsistensi
        final String usernameToSearch = _identifier.trim().toLowerCase();
        print('Mencari email untuk username (dicari sebagai): $usernameToSearch');

        final profileEmailData = await Supabase.instance.client
            .from('profiles')
            .select('email')
            .eq('username', usernameToSearch) // Cari dengan username lowercase
            .maybeSingle(); // Menggunakan maybeSingle() untuk menghindari error jika 0 baris

        print('Response dari database (mencari email by username): $profileEmailData');

        if (profileEmailData == null) {
          throw Exception('Username "$_identifier" tidak ditemukan.');
        }

        final emailFromProfile = profileEmailData['email'];
        if (emailFromProfile == null ||
            (emailFromProfile as String).isEmpty ||
            emailFromProfile == 'EMPTY') { // Pertahankan pengecekan 'EMPTY' jika itu kasus khusus Anda
          throw Exception('Email untuk username "$_identifier" tidak terhubung atau kosong di profil.');
        }
        emailToLogin = emailFromProfile as String;
        print('Username (input): $_identifier, Email ditemukan: $emailToLogin');
      }

      // Login menggunakan Supabase Authentication
      authResponse = await Supabase.instance.client.auth.signInWithPassword(
        email: emailToLogin,
        password: _password,
      );

      if (authResponse.user != null) {
        final userId = authResponse.user!.id;
        final userEmailFromAuth = authResponse.user!.email; // Email dari sesi auth

        // Ambil data profil dari tabel profiles
        final profileData = await Supabase.instance.client
            .from('profiles')
            .select('username, ulp, role')
            .eq('id', userId)
            .maybeSingle(); // Menggunakan maybeSingle() lebih aman

        if (profileData != null) {
          _storage.write('username', profileData['username']);
          _storage.write('ulp', profileData['ulp']);
          _storage.write('role', profileData['role']);
          _storage.write('user_id', userId);
          _storage.write('email', userEmailFromAuth); // Simpan email dari auth

          Get.snackbar(
            'Sukses', 'Login berhasil', /* ... parameter snackbar lainnya ... */
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
          // Pastikan BerandaScreen sudah benar diimpor dan merupakan Widget yang valid
          Get.off(() => const BerandaScreen());
        } else {
          // Fallback jika profil tidak ditemukan, coba ambil dari user_metadata atau buat
          print('WARNING: Profil tidak ditemukan untuk user ID $userId setelah login. Mencoba membuat/melengkapi.');
          final userMetadata = authResponse.user!.userMetadata ?? {};
          // Gunakan username input jika login via username, atau dari metadata, atau default
          // Pastikan username yang disimpan konsisten (misal, lowercase)
          final usernameForProfile = !_identifier.contains('@') && !_identifier.contains('.')
              ? _identifier.trim().toLowerCase() // Jika login pakai username, gunakan versi lowercase-nya
              : (userMetadata['username']?.toString().toLowerCase() ?? 'user-${userId.substring(0, 5)}');

          final ulpFromMetadata = userMetadata['ulp'] ?? 'Unknown';
          final roleFromMetadata = userMetadata['role'] ?? 'Surveyor';

          _storage.write('username', usernameForProfile);
          _storage.write('ulp', ulpFromMetadata);
          _storage.write('role', roleFromMetadata);
          _storage.write('user_id', userId);
          _storage.write('email', userEmailFromAuth);

          await Supabase.instance.client.from('profiles').upsert({
            'id': userId,
            'username': usernameForProfile,
            'email': userEmailFromAuth, // Simpan email dari auth, bukan emailToLogin jika berbeda
            'ulp': ulpFromMetadata,
            'role': roleFromMetadata,
          });

          Get.snackbar(
            'Sukses', 'Login berhasil, profil dibuat/dilengkapi.', /* ... parameter snackbar ... */
            backgroundColor: Colors.green, // atau Colors.orange untuk info
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 1), // Disesuaikan dari kode asli
             titleText: const Text(
              'Sukses', // Atau 'Info'
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            messageText: const Text(
              'Login berhasil, profil dibuat/dilengkapi.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          );
          Get.off(() => const BerandaScreen());
        }
      } else {
        // Ini seharusnya jarang terjadi jika signInWithPassword tidak throw error AuthException
        throw Exception('Login gagal: User tidak ditemukan setelah autentikasi berhasil.');
      }
    } catch (error) {
      print('Error login: $error');
      String errorMessage = 'Terjadi kesalahan saat login.'; // Default message

      if (error is AuthException) {
        if (error.message.toLowerCase().contains('invalid login credentials')) {
          errorMessage = 'Email/Username atau password salah.';
        } else if (error.message.toLowerCase().contains('email not confirmed')) {
          errorMessage = 'Email belum dikonfirmasi. Silakan cek email Anda.';
        } else {
          errorMessage = 'Kesalahan autentikasi: ${error.message}';
        }
      } else if (error.toString().contains('Username "$_identifier" tidak ditemukan.')) {
        errorMessage = 'Username "$_identifier" tidak ditemukan.';
      } else if (error.toString().contains('Email untuk username "$_identifier" tidak terhubung atau kosong di profil.')) {
         errorMessage = 'Email untuk username "$_identifier" tidak terhubung di profil.';
      }
      // Menangkap pesan error dari Exception yang kita throw secara manual
      else if (error is Exception) {
          errorMessage = error.toString().replaceFirst('Exception: ', '');
      }
      // Bisa tambahkan penanganan untuk PostgrestException jika perlu
      // else if (error is PostgrestException) { ... }
      else {
        // Fallback untuk error lain yang tidak terduga
        errorMessage = 'Gagal login: Terjadi kesalahan tidak dikenal.';
      }

      Get.snackbar(
        'Error', errorMessage, /* ... parameter snackbar lainnya ... */
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3), // Durasi lebih lama untuk error
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
      if (mounted) { // Pastikan widget masih mounted sebelum panggil setState
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Struktur UI Anda di sini tetap sama
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color.fromARGB(255, 40, 40, 40), // Sesuai kode asli Anda
        iconTheme: const IconThemeData(color: Colors.white), // Sesuai kode asli Anda
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20), // Tambahan untuk konsistensi
      ),
      // Menggunakan Padding dan Column seperti di kode asli Anda, bukan Center + SingleChildScrollView
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center, // Jika ingin konten di tengah vertikal
            // crossAxisAlignment: CrossAxisAlignment.stretch, // Jika ingin tombol full width
            children: [
              TextFormField(
                style: const TextStyle(color: Colors.white), // Sesuaikan jika tema gelap
                decoration: InputDecoration(
                  labelText: 'Email atau Username',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  labelStyle: const TextStyle(color: Colors.blue),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email atau Username tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) => _identifier = value!.trim(),
              ),
              const SizedBox(height: 20),
              TextFormField(
                style: const TextStyle(color: Colors.white), // Sesuaikan jika tema gelap
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  labelStyle: const TextStyle(color: Colors.blue),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (value) => value == null || value.isEmpty ? 'Password tidak boleh kosong' : null,
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
