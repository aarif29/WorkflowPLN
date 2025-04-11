import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../dashboard.dart';
import '../permohonan_baru.dart';
import '../antrian.dart';
import '../selesai.dart';
import '../antrian_provider.dart';

class BerandaScreen extends ConsumerStatefulWidget {
  const BerandaScreen({super.key});

  @override
  BerandaScreenState createState() => BerandaScreenState();
}

class BerandaScreenState extends ConsumerState<BerandaScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _selectedIndex = index),
              children: [
                DashboardScreen(),
                PermohonanBaruScreen(
                  onPermohonanAdded: (newPermohonan) {
                    // Tambahkan data ke antrianProvider
                    ref.read(antrianProvider.notifier).addToSurveyQueue(newPermohonan);
                  },
                  onNavigateToAntrian: () => _pageController.jumpToPage(2),
                ),
                AntrianScreen(),
                SelesaiScreen(),
                Container(color: Colors.green),
              ],
            ),
          ),
          _buildBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: const Color.fromARGB(255, 0, 106, 255),
      unselectedItemColor: Colors.white,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_rounded),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box_rounded),
          label: 'Permohonan Baru',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.checklist_rounded),
          label: 'Antrian',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_circle_rounded),
          label: 'Selesai',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.update),
          label: 'Update',
        ),
      ],
    );
  }
}
