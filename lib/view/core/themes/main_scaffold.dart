import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../search/search_screen.dart';
import '../../ticket/ticket_screen.dart';
import '../../ticket/my_event_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  String _role = 'user'; // default
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _role = prefs.getString('role') ?? 'user';
      _screens = _getScreensForRole(_role);
    });
  }

  List<Widget> _getScreensForRole(String role) {
    if (role == 'organizer') {
      return const [
        DashboardScreen(),
        SearchScreen(),
        MyEventsScreen(),
      ];
    } else {
      return const [
        DashboardScreen(),
        SearchScreen(),
        TicketScreen(),
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    if (_screens == null || _screens.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: const Duration(milliseconds: 500),
        height: 70,
        items: _role == 'organizer'
            ? const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.search, size: 30, color: Colors.white),
          Icon(Icons.local_activity, size: 30, color: Colors.white),
        ]
            : const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.search, size: 30, color: Colors.white),
          Icon(Icons.confirmation_num, size: 30, color: Colors.white),
        ],
      ),
    );
  }
}
