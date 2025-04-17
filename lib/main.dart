import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'splash_screen.dart';
import 'package:get/get.dart';
import 'login_screen.dart';
import 'widget/navbar_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await initializeStorage(); // Inisialisasi GetStorage
  runApp(const MyApp());
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
    );
  }
}