import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _password = '';
  // _confirmPassword tidak perlu disimpan di state jika hanya untuk validasi,
  // tapi bisa berguna jika ada logika lain.
  // String _confirmPassword = '';
  String? _selectedUlp;
  String? _selectedRole;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<String> ulps = [
    'All', 'BATU', 'BLIMBING', 'BULULAWANG', 'DAMPIT', 'DINOYO',
    'GONDANG LEGI', 'KEBONAGUNG', 'KEPANJEN', 'LAWANG', 'MALANG KOTA',
    'SINGOSARI', 'SUMBER PUCUNG', 'TUMPANG',
  ];

  final List<String> roles = ['MULP', 'TEKNIK', 'PP', 'SURVEYOR'];

  Future<void> _attemptRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      // Debug log sebelum registrasi
      print('Attempting registration with (data for trigger):');
      print('Username: $_username');
      print('Email (for auth): $_email'); // Email ini untuk auth.users
      print('ULP: $_selectedUlp');
      print('Role: $_selectedRole');

      // 1. Daftar menggunakan Supabase Authentication.
      // Data yang dimasukkan di 'data' akan masuk ke auth.users.raw_user_meta_data
      // dan akan digunakan oleh trigger database untuk mengisi tabel 'profiles'.
      final authResponse = await Supabase.instance.client.auth.signUp(
        email: _email,
        password: _password,
        data: {
          // Pastikan key di sini (username, ulp, role)
          // sama dengan yang diambil oleh trigger di database:
          // new.raw_user_meta_data->>'username'
          // new.raw_user_meta_data->>'ulp'
          // new.raw_user_meta_data->>'role'
          'username': _username,
          'ulp': _selectedUlp,
          'role': _selectedRole,
        },
      );

      print('Auth Response: User ID = ${authResponse.user?.id}, Session = ${authResponse.session != null ? "Created" : "Null"}');

      if (authResponse.user == null) {
        // Ini seharusnya tidak terjadi jika signUp berhasil tanpa exception,
        // tapi sebagai fallback.
        throw Exception('Registrasi gagal: User tidak dibuat oleh Supabase Auth.');
      }

      // TIDAK PERLU LAGI UPSERT MANUAL KE PROFILES JIKA MENGGUNAKAN TRIGGER DATABASE.
      // Trigger 'handle_new_user' di Supabase akan otomatis membuat entri di tabel 'profiles'
      // termasuk mengisi kolom 'email' dari 'new.email' di auth.users.

      print('User ${authResponse.user!.email} registered successfully. Profile should be created by database trigger.');

      Get.snackbar(
        'Sukses',
        'Registrasi berhasil! Silakan cek email Anda untuk konfirmasi dan coba login.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
      // Kembali ke halaman login atau halaman lain yang sesuai
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        // Jika tidak bisa pop (misalnya ini halaman pertama), arahkan ke login
        // Get.offNamed('/login'); // Ganti dengan rute login Anda jika menggunakan GetX routing
      }

    } catch (error) {
      String errorMessage = 'Terjadi kesalahan saat registrasi.';
      if (error is AuthException) {
        print('AuthException: ${error.message}, StatusCode: ${error.statusCode}, RawError: ${error.toString()}');
        // Cek spesifik untuk error "Database error saving new user"
        // atau error serupa yang mengindikasikan masalah pada sisi server/trigger.
        if (error.message.toLowerCase().contains('database error saving new user') ||
            (error.statusCode == 500 && error.message.toLowerCase().contains('unexpected_failure')) ||
            error.message.toLowerCase().contains('error executing postgres function')) { // Pesan error umum dari trigger gagal
          errorMessage = 'Gagal menyimpan data pengguna di server. Kemungkinan ada masalah dengan konfigurasi database (trigger). Hubungi administrator.';
        } else if (error.message.toLowerCase().contains('user already registered')) {
          errorMessage = 'Email sudah terdaftar. Silakan gunakan email lain atau login.';
        } else if (error.message.toLowerCase().contains('rate limit exceeded') || error.message.toLowerCase().contains('email_rate_limit_exceeded')) {
          errorMessage = 'Batas pengiriman email tercapai. Coba lagi nanti.';
        } else if (error.statusCode == 422 || error.message.toLowerCase().contains('unable to validate email address')) {
          errorMessage = 'Format email tidak valid.';
        } else {
          errorMessage = 'Kesalahan autentikasi: ${error.message}';
        }
      } else {
        print('Generic Error during registration: $error');
        errorMessage = 'Registrasi gagal: ${error.toString()}';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } finally {
      if (mounted) { // Pastikan widget masih ada di tree
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
        title: const Text('Register', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 40, 40, 40),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Membuat ElevatedButton full width
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Username tidak boleh kosong' : null,
                  onSaved: (value) => _username = value!,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
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
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value!,
                  onChanged: (value) => _password = value, // Untuk validasi konfirmasi password secara real-time jika diperlukan
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureConfirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Konfirmasi password tidak boleh kosong';
                    if (value != _password) return 'Password tidak cocok'; // _password harus sudah terisi dari onChanged di field password
                    return null;
                  },
                  // onSaved: (value) => _confirmPassword = value!, // Tidak perlu disimpan jika hanya untuk validasi
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Pilih ULP',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  value: _selectedUlp,
                  items: ulps.map((String ulp) {
                    return DropdownMenuItem<String>(
                      value: ulp,
                      child: Text(ulp),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedUlp = value;
                    });
                  },
                  validator: (value) => value == null ? 'Pilih ULP terlebih dahulu' : null,
                  onSaved: (value) => _selectedUlp = value, // Pastikan nilai tersimpan
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Pilih Role',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  value: _selectedRole,
                  items: roles.map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                  validator: (value) => value == null ? 'Pilih role terlebih dahulu' : null,
                  onSaved: (value) => _selectedRole = value, // Pastikan nilai tersimpan
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const Center(child: CircularProgressIndicator()) // Center agar lebih rapi
                    : ElevatedButton(
                        onPressed: _attemptRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Atau warna tema Anda
                          foregroundColor: Colors.white, // Warna teks tombol
                          minimumSize: const Size(double.infinity, 50), // Membuat tombol full width
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          textStyle: const TextStyle(fontSize: 17.0),
                        ),
                        child: const Text('Register'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
