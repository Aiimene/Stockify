import 'package:flutter/material.dart';
import '../../presentation/widgets/bottom_nav_bar.dart';
import '../../presentation/themes/app_colors.dart';
import 'dashboard.dart';
import 'analytics_screen.dart';
import 'product_list_screen.dart';
import 'orders_screen.dart';
import 'settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  NavItem _currentNavItem = NavItem.home;

  // Define the screens for each nav item
  final Map<NavItem, Widget> _screens = {
    NavItem.home: const DashboardScreen(),
    NavItem.analytics: const AnalyticsScreen(),
    NavItem.order: const OrdersScreen(),
    NavItem.product: const ProductListScreen(),
    NavItem.settings: const SettingsScreen(),
  };

  void _onNavItemTapped(NavItem item) {
    setState(() {
      _currentNavItem = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentNavItem],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavItem,
        onItemTapped: _onNavItemTapped,
      ),
    );
  }
}

// Placeholder screen for coming soon sections
class _ComingSoonScreen extends StatelessWidget {
  final String title;

  const _ComingSoonScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.construction_outlined,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              '$title Coming Soon',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This feature is under development',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

