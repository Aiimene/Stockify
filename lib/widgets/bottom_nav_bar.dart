import 'package:flutter/material.dart';
import '../../Themes/Style_Simple/Colors.dart';
import '../../Themes/Style_Simple/typography.dart';

enum NavItem { home, analytics, order, product, settings }

class BottomNavBar extends StatelessWidget {
  final NavItem currentIndex;
  final Function(NavItem) onItemTapped;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavBarItem(
              icon: Icons.home_outlined,
              label: 'Home',
              isActive: currentIndex == NavItem.home,
              onTap: () => onItemTapped(NavItem.home),
            ),
            _NavBarItem(
              icon: Icons.bar_chart_outlined,
              label: 'Analytics',
              isActive: currentIndex == NavItem.analytics,
              onTap: () => onItemTapped(NavItem.analytics),
            ),
            _NavBarItem(
              icon: Icons.receipt_outlined,
              label: 'Order',
              isActive: currentIndex == NavItem.order,
              onTap: () => onItemTapped(NavItem.order),
            ),
            _NavBarItem(
              icon: Icons.inventory_2_outlined,
              label: 'Product',
              isActive: currentIndex == NavItem.product,
              onTap: () => onItemTapped(NavItem.product),
            ),
            _NavBarItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              isActive: currentIndex == NavItem.settings,
              onTap: () => onItemTapped(NavItem.settings),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== NAV BAR ITEM =====
class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.accent : AppColors.textSecondary,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: smartStockTextTheme.labelSmall?.copyWith(
              color: isActive ? AppColors.accent : AppColors.textSecondary,
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
