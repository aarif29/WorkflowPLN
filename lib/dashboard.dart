import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controller/antrian_controller.dart';
import '../controller/selesai_controller.dart';
import '../widget/navbar_overlay.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller
    final antrianController = Get.put(AntrianController());
    final selesaiController = Get.put(SelesaiController());
    final berandaController = Get.find<BerandaController>();

    return Container(
      color: Colors.black87,
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Ringkasan Workflow',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            // Pie Chart dan Statistik
            Obx(() {
              // Hitung jumlah permohonan per tahap tanpa tumpang tindih
              final int surveyCount = antrianController.surveyQueue.length; // Hanya Survey
              final int prosesCount = antrianController.rabQueue.length +
                  antrianController.amsQueue.length; // RAB + AMS
              final int selesaiCount = selesaiController.selesaiList.length;

              // Total permohonan unik
              final int totalCount = surveyCount + prosesCount + selesaiCount;

              // Hitung persentase (hindari pembagian dengan nol)
              final double surveyPercentage = totalCount == 0 ? 0 : (surveyCount / totalCount) * 100;
              final double prosesPercentage = totalCount == 0 ? 0 : (prosesCount / totalCount) * 100;
              final double selesaiPercentage = totalCount == 0 ? 0 : (selesaiCount / totalCount) * 100;

              return Column(
                children: [
                  // Pie Chart
                  SizedBox(
                    height: 200.0,
                    child: totalCount == 0
                        ? const Center(
                            child: Text(
                              'Tidak ada data',
                              style: TextStyle(color: Colors.white54, fontSize: 16.0),
                            ),
                          )
                        : PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  value: surveyCount.toDouble(),
                                  color: Colors.yellowAccent,
                                  title: '${surveyPercentage.toStringAsFixed(1)}%',
                                  radius: 80.0,
                                  titleStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                PieChartSectionData(
                                  value: prosesCount.toDouble(),
                                  color: Colors.blueAccent,
                                  title: '${prosesPercentage.toStringAsFixed(1)}%',
                                  radius: 80.0,
                                  titleStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                PieChartSectionData(
                                  value: selesaiCount.toDouble(),
                                  color: Colors.greenAccent,
                                  title: '${selesaiPercentage.toStringAsFixed(1)}%',
                                  radius: 80.0,
                                  titleStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                              centerSpaceRadius: 40.0,
                              sectionsSpace: 2.0,
                            ),
                          ),
                  ),
                  const SizedBox(height: 48.0),
                  // Detail Statistik
                  _buildStatItem(
                    title: 'Antrian Survey',
                    count: surveyCount,
                    percentage: surveyPercentage,
                    color: Colors.yellowAccent,
                    icon: Icons.hourglass_empty,
                    onTap: () => berandaController.changePage(2), // Navigasi ke Antrian
                  ),
                  const SizedBox(height: 16.0),
                  _buildStatItem(
                    title: 'Proses (RAB + AMS)',
                    count: prosesCount,
                    percentage: prosesPercentage,
                    color: Colors.blueAccent,
                    icon: Icons.build,
                    onTap: () => berandaController.changePage(2), // Navigasi ke Antrian
                  ),
                  const SizedBox(height: 16.0),
                  _buildStatItem(
                    title: 'Selesai',
                    count: selesaiCount,
                    percentage: selesaiPercentage,
                    color: Colors.greenAccent,
                    icon: Icons.check_circle,
                    onTap: () => berandaController.changePage(3), // Navigasi ke Selesai
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String title,
    required int count,
    required double percentage,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: color, width: 1.0),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24.0),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '$count permohonan (${percentage.toStringAsFixed(1)}%)',
                    style: const TextStyle(color: Colors.white, fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}