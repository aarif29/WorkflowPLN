import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(
    const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Sistem Manajemen Survey PLN',
      home: SplashScreen(),
      theme: ThemeData(
        brightness: Brightness.dark, 
        primaryColor: Color.fromARGB(255, 40, 40, 40), 
        scaffoldBackgroundColor: Color.fromARGB(255, 40, 40, 40), 
        cardColor: Colors.blueGrey[800],
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white), // Warna teks utama
          bodyMedium: TextStyle(color: Colors.grey[300]), // Warna teks sekunder
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 40, 40, 40), // Warna app bar
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
