import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'widget/navbar_overlay.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Inisialisasi format tanggal untuk lokal Indonesia
    await initializeDateFormatting('id_ID', null);

    // Inisialisasi GetStorage
    await initializeStorage();

    // Inisialisasi Supabase
    await Supabase.initialize(
      url: 'https://tlgulizpefxyrunxzatj.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRsZ3VsaXpwZWZ4eXJ1bnh6YXRqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUzOTUyOTAsImV4cCI6MjA2MDk3MTI5MH0.Xu3jKuAUdXS1RpuRPokjxx7KrR3dIgYdxBVEZuIvY_I',
    );

    runApp(const MyApp());
  } catch (e) {
    print('Gagal menginisialisasi aplikasi: $e');
    runApp(const ErrorApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Aplikasi Sistem Manajemen Survey PLN',
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/beranda', page: () => const BerandaScreen()),
      ],
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 40, 40, 40),
        scaffoldBackgroundColor: const Color.fromARGB(255, 40, 40, 40),
        cardColor: Colors.blueGrey[800],
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.grey),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 40, 40, 40),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            shadows: [
              Shadow(
                color: Colors.blue,
                offset: Offset(2.0, 2.0),
                blurRadius: 4.0,
              ),
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Fallback UI jika inisialisasi gagal
class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Gagal menginisialisasi aplikasi. Silakan coba lagi.',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}