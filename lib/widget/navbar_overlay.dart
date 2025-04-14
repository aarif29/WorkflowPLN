import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../dashboard.dart';
import '../permohonan_baru.dart';
import '../antrian.dart';
import '../selesai.dart';
import '../controller/antrian_controller.dart';

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AntrianController());
    final pageController = PageController();
    final RxInt selectedIndex = 0.obs;

    const navItems = [
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard_rounded),
        label: 'Dashboard',
        backgroundColor: Colors.black87,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_box_rounded),
        label: 'Permohonan Baru',
        backgroundColor: Colors.black87,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.checklist_rounded),
        label: 'Antrian',
        backgroundColor: Colors.black87,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.check_circle_rounded),
        label: 'Selesai',
        backgroundColor: Colors.black87,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.update),
        label: 'Update',
        backgroundColor: Colors.black87,
      ),
    ];

    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) => selectedIndex.value = index,
        children: [
          const DashboardScreen(),
          PermohonanBaruScreen(
            onPermohonanAdded: (newPermohonan) {
              controller.addPermohonan(newPermohonan);
              Get.snackbar(
                'Sukses',
                'Permohonan berhasil ditambahkan',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 1),
                titleText: const Text(
                  'Sukses',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                messageText: const Text(
                  'Permohonan berhasil ditambahkan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              );
            },
            onNavigateToAntrian: () => pageController.jumpToPage(2),
          ),
          const AntrianScreen(),
          SelesaiScreen(),
          Container(color: Colors.green),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: selectedIndex.value,
          onTap: (index) {
            selectedIndex.value = index;
            pageController.jumpToPage(index);
          },
          selectedItemColor: const Color.fromARGB(255, 0, 106, 255),
          unselectedItemColor: Colors.white,
          showUnselectedLabels: true,
          items: navItems,
        ),
      ),
    );
  }
}