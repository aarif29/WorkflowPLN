import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../dashboard.dart';
import '../permohonan_baru.dart';
import '../antrian.dart';
import '../selesai.dart';
import '../controller/antrian_controller.dart';
import '../login_screen.dart';

// Inisialisasi GetStorage di aplikasi
Future<void> initializeStorage() async {
  await GetStorage.init();
}

// Buat controller untuk mengelola navigasi
class BerandaController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  PageController pageController = PageController();

  void changePage(int index) {
    selectedIndex.value = index;
    pageController.jumpToPage(index);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

// Halaman Profil
class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GetStorage storage = GetStorage();
    String username = storage.read('username') ?? 'User';
    String group = storage.read('group') ?? 'Tidak ada grup';
    String role = storage.read('role') ?? 'Pengguna'; // Ambil peran dari GetStorage

    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Foto Profil (Placeholder)
            const CircleAvatar(
              radius: 50.0,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 60.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16.0),
            // Nama Pengguna dari GetStorage
            Text(
              username,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            // Grup
            Text(
              'Grup: $group',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            // Peran (Admin/Surveyor)
            Text(
              role,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 32.0),
            // Tombol Logout
            ElevatedButton(
              onPressed: () {
                print('Tombol Logout ditekan');
                storage.remove('username');
                storage.remove('group');
                storage.remove('role'); // Hapus informasi peran saat logout
                Get.offAll(() => const LoginScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final antrianController = Get.put(AntrianController());
    final berandaController = Get.put(BerandaController());

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
        icon: Icon(Icons.person),
        label: 'Profil',
        backgroundColor: Colors.black87,
      ),
    ];

    return Scaffold(
      body: PageView(
        controller: berandaController.pageController,
        onPageChanged: (index) => berandaController.selectedIndex.value = index,
        children: [
          const DashboardScreen(),
          PermohonanBaruScreen(
            onPermohonanAdded: (newPermohonan) {
              antrianController.addPermohonan(newPermohonan);
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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                messageText: const Text(
                  'Permohonan berhasil ditambahkan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              );
            },
            onNavigateToAntrian: () => berandaController.changePage(2),
          ),
          const AntrianScreen(),
          SelesaiScreen(),
          const ProfilScreen(),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: berandaController.selectedIndex.value,
          onTap: (index) {
            berandaController.changePage(index);
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