import 'package:flutter/material.dart';

class SelesaiScreen extends StatelessWidget {
  // Contoh data permohonan selesai (bisa diganti dengan data dinamis)
  final List<Map<String, String>> selesaiList = [
    {
      'id': '001',
      'nama': 'Permohonan A',
      'tanggal': '2025-03-20',
      'status': 'Selesai',
    },
    {
      'id': '002',
      'nama': 'Permohonan B',
      'tanggal': '2025-03-22',
      'status': 'Selesai',
    },
    {
      'id': '003',
      'nama': 'Permohonan C',
      'tanggal': '2025-03-23',
      'status': 'Selesai',
    },
  ];

  SelesaiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Permohonan Selesai',
          style: TextStyle(
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
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: Colors.black87, // Warna latar belakang scaffold gelap
      body: ListView.builder(
        itemCount: selesaiList.length,
        itemBuilder: (context, index) {
          final permohonan = selesaiList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Colors.grey[850], // Warna Card gelap
            child: ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: Text(
                permohonan['nama']!,
                style: const TextStyle(color: Colors.white), // Warna teks putih
              ),
              subtitle: Text(
                'ID: ${permohonan['id']} - ${permohonan['tanggal']}',
                style: TextStyle(
                  color: Colors.grey[300],
                ), // Warna teks abu-abu muda
              ),
              trailing: Text(
                permohonan['status']!,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
