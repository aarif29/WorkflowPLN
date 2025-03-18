import 'package:flutter/material.dart';
import '../dashboard.dart';
import '../permohonan_baru.dart';
import '../antrian.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  BerandaScreenState createState() => BerandaScreenState();
}

class BerandaScreenState extends State<BerandaScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final List<Map<String, String?>> _permohonanList = [];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.jumpToPage(index);
  }

  void _addPermohonan(Map<String, String?> newPermohonan) {
    setState(() => _permohonanList.add(newPermohonan));
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
                  onPermohonanAdded: _addPermohonan,
                  onNavigateToAntrian: () => _pageController.jumpToPage(2),
                  // permohonanListNotifier: ValueNotifier<List<Map<String, String?>>>(_permohonanList),
                ),
                AntrianScreen(permohonanList: _permohonanList),
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
      unselectedItemColor: Colors.black,
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
        BottomNavigationBarItem(icon: Icon(Icons.update), label: 'Update'),
      ],
    );
  }
}
