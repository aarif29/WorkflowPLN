import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'permohonan_baru.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  _BerandaScreenState createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          DashboardScreen(),
          PermohonanBaruScreen(),
          Container(color: Colors.blue), // Placeholder for Survey screen
          Container(color: Colors.green), // Placeholder for Update screen
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Permohonan Baru',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rounded),
            label: 'Survey',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.update), label: 'Update'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 0, 106, 255),
        unselectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(
          color: Color.fromARGB(255, 0, 106, 255),
        ), // Set selected label color to blue
        unselectedLabelStyle: const TextStyle(
          color: Colors.black,
        ), // Set unselected label color to black
        showUnselectedLabels:
            true, // Ensure unselected labels are always visible
        onTap: _onItemTapped,
      ),
    );
  }
}
