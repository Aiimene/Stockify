import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../presentation/themes/app_colors.dart';
import '../../presentation/widgets/custom_app_bar.dart';
import '../../logic/cubits/statistics_cubit.dart';
import '../../logic/cubits/products_cubit.dart';
import '../../logic/cubits/orders_cubit.dart';
import '../../data/models/product.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load statistics for current month
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    context.read<StatisticsCubit>().loadStatistics(
      startDate: DateFormat('yyyy-MM-dd').format(monthStart),
      endDate: DateFormat('yyyy-MM-dd').format(now),
    );
    // Load products to get low stock items
    context.read<ProductsCubit>().loadProducts();
    // Load recent orders
    context.read<OrdersCubit>().loadOrders();
  }

  List<Product> _getLowStockProducts(List<Product> products) {
    return products.where((p) => p.stockQuantity <= p.lowStockThreshold).toList();
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'StockiFy',
        subtitle: 'Dashboard',
        showBackButton: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistics Cards
              BlocBuilder<StatisticsCubit, StatisticsState>(
                builder: (context, statsState) {
                  if (statsState is StatisticsLoaded) {
                    final stats = statsState.statistics;
                    final totalRevenue = (stats['total_revenue'] as num?)?.toDouble() ?? 0.0;
                    final totalOrders = (stats['total_orders'] as num?)?.toInt() ?? 0;
                    final avgOrderValue = (stats['average_order_value'] as num?)?.toDouble() ?? 0.0;
                    final totalProducts = (stats['total_products'] as num?)?.toInt() ?? 0;

                    return GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.0,
                      children: [
                        _StatCard(
                          icon: Icons.insert_chart_outlined,
                          title: 'Total Revenue',
                          value: '${NumberFormat('#,###').format(totalRevenue)} DZD',
                        ),
                        _StatCard(
                          icon: Icons.shopping_bag_outlined,
                          title: 'Avg. Order Value',
                          value: '${NumberFormat('#,###').format(avgOrderValue)} DZD',
                        ),
                        _StatCard(
                          icon: Icons.inventory_2_outlined,
                          title: 'Total Products',
                          value: NumberFormat('#,###').format(totalProducts),
                          showViewAll: true,
                          onViewAllTap: () {
                            Navigator.pushNamed(context, '/');
                          },
                        ),
                        _StatCard(
                          icon: Icons.shopping_cart_outlined,
                          title: 'Total Orders',
                          value: NumberFormat('#,###').format(totalOrders),
                        ),
                      ],
                    );
                  } else if (statsState is StatisticsLoading) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              const SizedBox(height: 28),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: _PrimaryButton(
                      label: '+ Add Order',
                      onPressed: () {
                        Navigator.pushNamed(context, '/new-sale');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      label: '+ Add Product',
                      onPressed: () {
                        Navigator.pushNamed(context, '/add-product');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Best-Selling Products
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Best-Selling Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              BlocBuilder<StatisticsCubit, StatisticsState>(
                builder: (context, statsState) {
                  if (statsState is StatisticsLoaded) {
                    final topProducts = (statsState.statistics['top_products'] as List<dynamic>?) ?? [];
                    if (topProducts.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'No sales data available',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }

                    final displayProducts = topProducts.take(2).toList();
                    return Row(
                      children: displayProducts.asMap().entries.map((entry) {
                        final index = entry.key;
                        final product = entry.value;
                        final productName = product['product_name'] as String? ?? 'Unknown';
                        final totalRevenue = (product['total_revenue'] as num?)?.toDouble() ?? 0.0;

                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: index == 0 ? 12 : 0),
                            child: _ProductCard(
                              image: productName.isNotEmpty ? productName[0] : '📦',
                              title: productName,
                              price: '${NumberFormat('#,###').format(totalRevenue)} DZD',
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 32),

              // Low Stock Alerts
              BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, productsState) {
                  if (productsState is ProductsLoaded) {
                    final lowStockProducts = _getLowStockProducts(productsState.products);
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Low Stock Alerts',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (lowStockProducts.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.warningLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${lowStockProducts.length} ${lowStockProducts.length == 1 ? 'Item' : 'Items'}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.warning,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (lowStockProducts.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                'All products are well stocked',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                        else
                          ...lowStockProducts.take(2).map((product) {
                            final statusColor = product.stockQuantity == 0
                                ? AppColors.error
                                : AppColors.warning;
                            final statusText = product.stockQuantity == 0
                                ? 'Out of stock'
                                : 'Only ${product.stockQuantity} left';

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _ProductListItem(
                                icon: '📦',
                                title: product.name,
                                status: statusText,
                                statusColor: statusColor,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/product-detail',
                                    arguments: product,
                                  );
                                },
                              ),
                            );
                          }),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 32),

              // Recent Activities (Recent Orders)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Activities',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/orders');
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              BlocBuilder<OrdersCubit, OrdersState>(
                builder: (context, ordersState) {
                  if (ordersState is OrdersLoaded) {
                    final recentOrders = ordersState.orders.take(2).toList();
                    
                    if (recentOrders.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'No recent orders',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: recentOrders.map((order) {
                        final orderDate = order.createdAt != null
                            ? DateTime.parse(order.createdAt!)
                            : DateTime.now();
                        final timeAgo = _formatTimeAgo(orderDate);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ActivityItem(
                            icon: Icons.shopping_bag_outlined,
                            title: 'Order #${order.orderNumber} created',
                            subtitle: '${order.items.length} ${order.items.length == 1 ? 'item' : 'items'} • ${NumberFormat('#,###').format(order.totalAmount)} DZD',
                            time: timeAgo,
                            onTap: () {
                              Navigator.pushNamed(context, '/orders');
                            },
                          ),
                        );
                      }).toList(),
                    );
                  }
                  return const SizedBox.shrink();
                },
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
  final IconData icon;
  final String title;
  final String value;
  final bool showViewAll;
  final VoidCallback? onViewAllTap;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    this.showViewAll = false,
    this.onViewAllTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          if (showViewAll)
            GestureDetector(
              onTap: onViewAllTap,
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_forward,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
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

// ===== PRIMARY BUTTON =====
class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PrimaryButton({
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
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
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
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.accent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

// ===== PRODUCT CARD =====
class _ProductCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;

  const _ProductCard({
    required this.image,
    required this.title,
    required this.price,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.2,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.productImagePlaceholder,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Text(
                  image,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
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

// ===== PRODUCT LIST ITEM =====
class _ProductListItem extends StatelessWidget {
  final String icon;
  final String title;
  final String status;
  final Color statusColor;
  final VoidCallback? onTap;

  const _ProductListItem({
    required this.icon,
    required this.title,
    required this.status,
    required this.statusColor,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 14,
                        color: statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textTertiary,
              size: 16,
            ),
          ],
        ),
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
  final VoidCallback? onTap;

  const _ActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accentLight.withOpacity(0.3),
                    AppColors.accent.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.accent,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: const TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
