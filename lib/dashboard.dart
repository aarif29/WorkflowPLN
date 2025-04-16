import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/antrian_controller.dart';
import '../controller/selesai_controller.dart';
import '../widget/navbar_overlay.dart'; // Impor BerandaController

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller
    final antrianController = Get.put(AntrianController());
    final selesaiController = Get.put(SelesaiController());
    final berandaController = Get.find<BerandaController>(); // Akses BerandaController

    return Container(
      color: Colors.black87,
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul atau header dashboard
          const Text(
            'Ringkasan Workflow',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          // GridView untuk menampilkan statistik
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, // 2 kolom
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1.2, // Rasio lebar:tinggi untuk card
              children: [
                // Card untuk Antrian
                Obx(() => _buildStatCard(
                      context: context,
                      title: 'Antrian',
                      count: antrianController.surveyQueue.length +
                          antrianController.rabQueue.length +
                          antrianController.amsQueue.length,
                      icon: Icons.hourglass_empty,
                      iconColor: Colors.yellowAccent,
                      borderColor: Colors.yellowAccent,
                      onTap: () {
                        // Navigasi ke halaman Antrian (indeks 2)
                        berandaController.changePage(2);
                      },
                    )),
                // Card untuk Proses (RAB + AMS)
                Obx(() => _buildStatCard(
                      context: context,
                      title: 'Proses',
                      count: antrianController.rabQueue.length +
                          antrianController.amsQueue.length,
                      icon: Icons.wifi_protected_setup_rounded,
                      iconColor: Colors.blueAccent,
                      borderColor: Colors.blueAccent,
                      onTap: () {
                        // Navigasi ke halaman Antrian (indeks 2)
                        berandaController.changePage(2);
                      },
                    )),
                // Card untuk Selesai
                Obx(() => _buildStatCard(
                      context: context,
                      title: 'Selesai',
                      count: selesaiController.selesaiList.length,
                      icon: Icons.check_circle,
                      iconColor: Colors.greenAccent,
                      borderColor: Colors.greenAccent,
                      onTap: () {
                        // Navigasi ke halaman Selesai (indeks 3)
                        berandaController.changePage(3);
                      },
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk membuat card statistik
  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required int count,
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.grey[850],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: borderColor, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 40.0,
              ),
              const SizedBox(height: 8.0),
              Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}