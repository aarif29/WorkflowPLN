import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'permohonan_baru.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  _BerandaScreenState createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Ini yang ditambahkan!
        decoration: BoxDecoration(color: Colors.black87),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDashboardButton(context, 'DASHBOARD', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            }),
            _buildDashboardButton(context, 'PERMOHONAN BARU', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PermohonanBaruScreen()),
              );
            }),
            _buildDashboardButton(context, 'SURVEY', () {}),
            _buildDashboardButton(context, 'UPDATE', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton(
    BuildContext context,
    String title,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2,
        ), // Adding white border
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 80.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
