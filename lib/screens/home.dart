import 'package:flutter/material.dart';
import 'package:ourproject/widgets/bottom_nav_bar.dart';
import '../../Themes/Style_Simple/Colors.dart';
import '../../Themes/Style_Simple/typography.dart';
import '../../Themes/Style_Simple/Buttons.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedBottomNav = 0;
  NavItem _selectedItem = NavItem.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: white1Color,
          elevation: 0,
          titleSpacing: 16,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Smart Stock Market', // your market name
                style: smartStockTextTheme.headlineMedium?.copyWith(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Dashboard', // current page title
                style: smartStockTextTheme.bodyMedium?.copyWith(
                  color: text1Color,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded,
                  color: accentColor),
              tooltip: 'Notifications',
              onPressed: () {
                // handle notification tap
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: InkWell(
                onTap: () {
                  // handle profile tap
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: accentColor, width: 1.2),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: accentColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick Stats Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: const [
                  _StatCard(
                    icon: '💰',
                    title: 'Total Revenue',
                    value: '₹15,750',
                    subtitle: 'Last 30 days',
                    backgroundColor: Color(0xFFE3F2FD),
                  ),
                  _StatCard(
                    icon: '📦',
                    title: 'Total Orders',
                    value: '5 Items',
                    backgroundColor: Color(0xFFFFEBEE),
                  ),
                  _StatCard(
                    icon: '🎉',
                    title: 'Coming Soon',
                    value: '1 Item',
                    backgroundColor: Color(0xFFFFF3E0),
                  ),
                  _StatCard(
                    icon: '🥦',
                    title: 'Fresh Products',
                    value: '124 Items',
                    backgroundColor: Color(0xFFE8F5E9),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      label: '+ Add Order',
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      label: '+ Add Product',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Best-Selling Products
              Text(
                'Best-Selling Products Today',
                style: smartStockTextTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Expanded(
                    child: _ProductCard(
                      // pass an emoji or a relative asset path like 'assets/images/prod1.png'
                      image: 'assets/images/prod_placeholder.png',
                      title: 'Foundation Cream',
                      price: '₹320 - ₹500',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _ProductCard(
                      image: '💄', // emoji fallback
                      title: 'Velvet Lipstick',
                      price: '₹680',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Products Almost Sold Out
              Text(
                'Products Almost Sold Out',
                style: smartStockTextTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              const _ProductListItem(
                icon: '💧',
                title: 'Micellar Water',
                status: 'Only 2 left in stock',
                statusColor: errorColor,
              ),
              const SizedBox(height: 12),
              const _ProductListItem(
                icon: '🧴',
                title: 'Night Cream',
                status: 'Only 5 left',
                statusColor: warningColor,
              ),
              const SizedBox(height: 32),

              // Recent Activities
              Text(
                'Recent Activities',
                style: smartStockTextTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              const _ActivityItem(
                icon: Icons.shopping_bag_outlined,
                title: 'New order #1024 created for Boutique',
                subtitle: 'Darshana',
                time: '2 minutes ago',
              ),
              const SizedBox(height: 12),
              const _ActivityItem(
                icon: Icons.inventory_2_outlined,
                title: 'Stock updated for Velvet Lipstick: 50',
                subtitle: '(Quantity Updated)',
                time: '1 hour ago',
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== STAT CARD =====
class _StatCard extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final String? subtitle;
  final Color backgroundColor;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    required this.backgroundColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: smartStockTextTheme.labelSmall?.copyWith(
                  color: text1Color,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: smartStockTextTheme.headlineMedium?.copyWith(
                  fontSize: 16,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: smartStockTextTheme.labelSmall?.copyWith(
                    color: text1Color,
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ===== ACTION BUTTON =====
class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: successColor,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: smartStockTextTheme.labelLarge?.copyWith(
              color: successColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ===== PRODUCT CARD =====
class _ProductCard extends StatelessWidget {
  /// `image` can be either:
  /// - an emoji/string (e.g. '💄') => will render centered text
  /// - an asset path (e.g. 'assets/images/prod1.png') => will load Image.asset
  final String image;
  final String title;
  final String price;

  const _ProductCard({
    required this.image,
    required this.title,
    required this.price,
    Key? key,
  }) : super(key: key);

  bool _looksLikeAsset(String s) {
    return s.contains('/') ||
        s.endsWith('.png') ||
        s.endsWith('.jpg') ||
        s.endsWith('.jpeg');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area with fixed aspect ratio so images always fit
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _looksLikeAsset(image)
                  ? Image.asset(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // fallback to a grey box with centered emoji if asset missing
                        return Container(
                          color: Colors.grey[300],
                          child: Center(
                              child: Text('🖼️',
                                  style: const TextStyle(fontSize: 28))),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: Center(
                          child: Text(image,
                              style: const TextStyle(fontSize: 32))),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: smartStockTextTheme.labelSmall?.copyWith(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: smartStockTextTheme.labelSmall?.copyWith(
              color: text1Color,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ===== PRODUCT LIST ITEM =====
class _ProductListItem extends StatelessWidget {
  final String icon;
  final String title;
  final String status;
  final Color statusColor;
  final bool showDelete;

  const _ProductListItem({
    required this.icon,
    required this.title,
    required this.status,
    required this.statusColor,
    this.showDelete = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: smartStockTextTheme.labelSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: smartStockTextTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (showDelete)
            Icon(
              Icons.delete_outline,
              color: text1Color,
              size: 20,
            )
          else
            Icon(
              Icons.more_vert,
              color: text1Color,
              size: 20,
            ),
        ],
      ),
    );
  }
}

// ===== ACTIVITY ITEM =====
class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: smartStockTextTheme.labelSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: smartStockTextTheme.labelSmall?.copyWith(
                    color: text1Color,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: smartStockTextTheme.labelSmall?.copyWith(
                    color: text1Color,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
