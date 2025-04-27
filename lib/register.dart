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
  String _confirmPassword = '';
  String? _selectedUlp;
  String? _selectedRole;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Daftar ULP dan role
  final List<String> ulps = [
    'All', // Ditambahkan untuk SuperAdmin
    'BATU',
    'BLIMBING',
    'BULULAWANG',
    'DAMPIT',
    'DINOYO',
    'GONDANG LEGI',
    'KEBONAGUNG',
    'KEPANJEN',
    'LAWANG',
    'MALANG KOTA',
    'SINGOSARI',
    'SUMBER PUCUNG',
    'TUMPANG',
  ];

  final List<String> roles = [
    'SuperAdmin', // Ditambahkan untuk SuperAdmin
    'MULP',
    'TEKNIK',
    'PP',
    'SURVEYOR',
  ];

  Future<void> _attemptRegister() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        // Daftar menggunakan Supabase Authentication
        final response = await Supabase.instance.client.auth.signUp(
          email: _email,
          password: _password,
          data: {
            'username': _username,
            'ulp': _selectedUlp,
            'role': _selectedRole,
          },
        );

        if (response.user != null) {
          // Tampilkan snackbar sukses
          Get.snackbar(
            'Sukses',
            'Register berhasil, silahkan konfirmasi email anda dan coba login ulang!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
            titleText: const Text(
              'Sukses',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            messageText: const Text(
              'Register berhasil, silahkan konfirmasi email anda dan coba login ulang!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          );

          // Kembali ke LoginScreen
          Get.back();
        }
      } catch (error) {
        // Registrasi gagal -> tampilkan snackbar
        String errorMessage = 'Registrasi gagal: $error';
        if (error.toString().contains('Email already registered')) {
          errorMessage = 'Email sudah terdaftar, gunakan email lain';
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
        title: const Text('Register'),
        backgroundColor: const Color.fromARGB(255, 40, 40, 40),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    labelStyle: const TextStyle(color: Colors.blue),
                  ),
                  validator: (value) => value!.isEmpty ? 'Username tidak boleh kosong' : null,
                  onSaved: (value) => _username = value!,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    labelStyle: const TextStyle(color: Colors.blue),
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
                  validator: (value) => value!.isEmpty ? 'Password tidak boleh kosong' : null,
                  onSaved: (value) => _password = value!,
                  onChanged: (value) => _password = value,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    labelStyle: const TextStyle(color: Colors.blue),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.blue,
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
                    if (value!.isEmpty) return 'Konfirmasi password tidak boleh kosong';
                    if (value != _password) return 'Password tidak cocok';
                    return null;
                  },
                  onSaved: (value) => _confirmPassword = value!,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Pilih ULP',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    labelStyle: const TextStyle(color: Colors.blue),
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
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Pilih Role',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    labelStyle: const TextStyle(color: Colors.blue),
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
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _attemptRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.white, fontSize: 17.0),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}