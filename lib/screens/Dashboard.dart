import 'package:flutter/material.dart';
import 'package:ourproject/widgets/bottom_nav_bar.dart';
import 'home.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  NavItem _selectedItem = NavItem.home;

  final Map<NavItem, Widget> _pages = {
    NavItem.home: const Home(),
    //NavItem.analytics: const Analytic(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedItem],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedItem,
        onItemTapped: (item) {
          setState(() {
            _selectedItem = item; // Switch the page
          });
        },
      ),
    );
  }
}
