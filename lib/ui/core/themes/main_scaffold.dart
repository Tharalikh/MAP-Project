import 'package:flutter/material.dart';
import '../../dashboard/widgets/dashboard_screen.dart';
import '../../search/widgets/search_screen.dart';
import '../../ticket/widgets/ticket_screen.dart';
import '../../ticket/widgets/my_event_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const SearchScreen(),
    const TicketScreen(),
    const MyEventsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,         // active item color
        unselectedItemColor: Colors.grey,        // inactive item color
        backgroundColor: Colors.white,           // bar background
        showUnselectedLabels: true,
        showSelectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_num), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.local_activity), label: ''),
        ],
      ),
    );
  }
}
