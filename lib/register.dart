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
  String _password = '';
  String _confirmPassword = '';
  String? _selectedUlp;
  String? _selectedRole;
  bool _isLoading = false; // Tambahkan state untuk indikator loading

  // Daftar ULP dan role
  final List<String> ulps = [
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
    'MULP',
    'TEKNIK',
    'PP',
    'SURVEYOR',
  ];

  Future<void> _attemptRegister() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true; // Tampilkan indikator loading
      });

      try {
        // Daftar menggunakan Supabase Authentication
        final response = await Supabase.instance.client.auth.signUp(
          email: '$_username@example.com', // Anggap username adalah bagian dari email
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
            'Registrasi berhasil, silakan login',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 1),
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
              'Registrasi berhasil, silakan login',
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
        Get.snackbar(
          'Error',
          'Registrasi gagal: ${error.toString()}',
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
          messageText: Text(
            'Registrasi gagal: ${error.toString()}',
            textAlign: TextAlign.center,
            style: const TextStyle(
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
                  ),
                  obscureText: true,
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
                    ? const CircularProgressIndicator() // Tampilkan indikator loading
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