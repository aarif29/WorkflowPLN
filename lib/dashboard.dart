import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white, // Change title color to white
            fontSize: 24.0, // Increase font size
            shadows: [
              Shadow(
                color: Colors.blue, // Add blue shadow
                offset: Offset(2.0, 2.0), // Shadow offset
                blurRadius: 4.0, // Shadow blur radius
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black87, // Make the AppBar background black
        iconTheme: IconThemeData(
          color: Colors.white,
        ), // Change back button color to white
        elevation: 0, // Remove shadow
      ),
      body: Container(
        color: Colors.black87, // Set background color to black
        width: double.infinity, // Ensure full width to eliminate white space
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Removed 'Antrian' button
            SizedBox(height: 32.0), // Increased spacing between components
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ), // White border
                borderRadius: BorderRadius.circular(8.0),
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
                  onPressed: () {},
                  child: Text(
                    'Proses',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.0), // Increased spacing between components
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ), // White border
                borderRadius: BorderRadius.circular(8.0),
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
                  onPressed: () {},
                  child: Text(
                    'Selesai',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
