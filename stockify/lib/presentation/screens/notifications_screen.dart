import 'package:flutter/material.dart';
import '../../presentation/themes/app_colors.dart';
import '../../presentation/widgets/custom_app_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notifications = [
    {
      'id': '1',
      'type': 'low_stock',
      'title': 'Low Stock Alert',
      'description': 'Stock: 3 units left',
      'product': 'Velvet Kiss Lipstick',
      'time': '2h ago',
      'isRead': false,
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': '2',
      'type': 'expiring',
      'title': 'Expiring Soon',
      'description': 'Expires: 28/12/2024',
      'product': 'Hydra Glow Foundation',
      'time': 'Yesterday',
      'isRead': false,
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': '3',
      'type': 'low_stock',
      'title': 'Low Stock Alert',
      'description': 'Stock: 5 units left',
      'product': 'Silk Finish Powder',
      'time': '3 days ago',
      'isRead': false,
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      'id': '4',
      'type': 'expiring',
      'title': 'Expiring Soon',
      'description': 'Expires: 15/01/2025',
      'product': 'Sun Defence Cream SPF50',
      'time': '1 week ago',
      'isRead': false,
      'timestamp': DateTime.now().subtract(const Duration(days: 7)),
    },
    {
      'id': '5',
      'type': 'out_of_stock',
      'title': 'Out of Stock',
      'description': 'Stock: 0 units left',
      'product': 'Vitamin C Serum',
      'time': '2 weeks ago',
      'isRead': false,
      'timestamp': DateTime.now().subtract(const Duration(days: 14)),
    },
    {
      'id': '6',
      'type': 'new_order',
      'title': 'New Order Received',
      'description': 'Order #1234',
      'product': 'Multiple Items',
      'time': '3 weeks ago',
      'isRead': false,
      'timestamp': DateTime.now().subtract(const Duration(days: 21)),
    },
    {
      'id': '7',
      'type': 'price_change',
      'title': 'Price Updated',
      'description': 'New price: 4,500 DZD',
      'product': 'Retinol Night Cream',
      'time': '1 month ago',
      'isRead': false,
      'timestamp': DateTime.now().subtract(const Duration(days: 30)),
    },
  ];

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteNotification(String id) {
    setState(() {
      notifications.removeWhere((notification) => notification['id'] == id);
    });
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'low_stock':
      case 'out_of_stock':
        return Icons.inventory_2_outlined;
      case 'expiring':
        return Icons.event_outlined;
      case 'new_order':
        return Icons.shopping_bag_outlined;
      case 'price_change':
        return Icons.attach_money;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'low_stock':
        return AppColors.notificationLowStockBg;
      case 'out_of_stock':
        return AppColors.notificationOutOfStockBg;
      case 'expiring':
        return AppColors.notificationExpiringBg;
      case 'new_order':
        return AppColors.notificationNewOrderBg;
      case 'price_change':
        return AppColors.notificationPriceChangeBg;
      default:
        return AppColors.surfaceVariant;
    }
  }

  Color _getIconColorForType(String type) {
    switch (type) {
      case 'low_stock':
        return AppColors.notificationLowStock;
      case 'out_of_stock':
        return AppColors.notificationOutOfStock;
      case 'expiring':
        return AppColors.notificationExpiring;
      case 'new_order':
        return AppColors.notificationNewOrder;
      case 'price_change':
        return AppColors.notificationPriceChange;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications.where((n) => !n['isRead']).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Notifications',
        showBackButton: true,
        showNotifications: false,
        additionalActions: unreadCount > 0 ? [
          IconButton(
            icon: const Icon(Icons.done_all_rounded, size: 24),
            color: AppColors.accent,
            onPressed: _markAllAsRead,
          ),
        ] : null,
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 64,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications',
                    style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final isRead = notification['isRead'] as bool;

                return Dismissible(
                  key: Key(notification['id']),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _deleteNotification(notification['id']);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Notification deleted'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            setState(() {
                              notifications.insert(index, notification);
                            });
                          },
                        ),
                      ),
                    );
                  },
                  background: Container(
                    color: AppColors.error,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: AppColors.textOnPrimary,
                      size: 28,
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isRead ? AppColors.surfaceVariant : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isRead ? Colors.transparent : AppColors.infoLight,
                        width: isRead ? 0 : 2,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _getColorForType(notification['type']),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getIconForType(notification['type']),
                          color: _getIconColorForType(notification['type']),
                          size: 24,
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isRead
                                    ? FontWeight.normal
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            notification['time'],
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            notification['description'],
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            notification['product'],
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: AppColors.textTertiary,
                          size: 20,
                        ),
                        onPressed: () {
                          _deleteNotification(notification['id']);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

