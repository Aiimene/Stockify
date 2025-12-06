import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../presentation/themes/app_colors.dart';
import '../../presentation/widgets/custom_app_bar.dart';
import '../../logic/cubits/orders_cubit.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  DateTimeRange? selectedDateRange;
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().loadOrders();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.accent),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
      _applyFilters();
    }
  }

  void _showStatusFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by Status',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('All Statuses'),
                leading: Radio<String?>(
                  value: null,
                  groupValue: selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                    Navigator.pop(context);
                    _applyFilters();
                  },
                  activeColor: AppColors.accent,
                ),
                onTap: () {
                  setState(() {
                    selectedStatus = null;
                  });
                  Navigator.pop(context);
                  _applyFilters();
                },
              ),
              ListTile(
                title: const Text('Completed'),
                  leading: Radio<String?>(
                  value: 'completed',
                  groupValue: selectedStatus,
                    onChanged: (value) {
                      setState(() {
                      selectedStatus = value;
                      });
                      Navigator.pop(context);
                    _applyFilters();
                    },
                    activeColor: AppColors.accent,
                  ),
                  onTap: () {
                    setState(() {
                    selectedStatus = 'completed';
                  });
                  Navigator.pop(context);
                  _applyFilters();
                },
              ),
              ListTile(
                title: const Text('Refunded'),
                leading: Radio<String?>(
                  value: 'refunded',
                  groupValue: selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                    Navigator.pop(context);
                    _applyFilters();
                  },
                  activeColor: AppColors.accent,
                ),
                onTap: () {
                  setState(() {
                    selectedStatus = 'refunded';
                  });
                  Navigator.pop(context);
                  _applyFilters();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _applyFilters() {
    context.read<OrdersCubit>().loadOrders(
      startDate: selectedDateRange != null
          ? DateFormat('yyyy-MM-dd').format(selectedDateRange!.start)
          : null,
      endDate: selectedDateRange != null
          ? DateFormat('yyyy-MM-dd').format(selectedDateRange!.end)
          : null,
      status: selectedStatus,
      paymentMethod: null, // Removed payment method filter
    );
  }

  void _clearFilters() {
    setState(() {
      selectedDateRange = null;
      selectedStatus = null;
    });
    context.read<OrdersCubit>().loadOrders();
  }

  void _showOrderDetails(BuildContext context, order, DateTime orderDate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.orderNumber,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd MMM yyyy, HH:mm').format(orderDate),
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: order.status == 'completed'
                          ? AppColors.successLight
                          : AppColors.errorLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: order.status == 'completed'
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          order.paymentMethod == 'cash'
                              ? Icons.money
                              : Icons.credit_card,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          order.paymentMethod.toUpperCase(),
                          style: const TextStyle(
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
              const SizedBox(height: 24),
              const Text(
                'Order Items',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: order.items.length,
                  itemBuilder: (context, index) {
                    final item = order.items[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (item.productSku != null)
                                  Text(
                                    'SKU: ${item.productSku}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${NumberFormat('#,###').format(item.unitPrice)} DZD',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '${NumberFormat('#,###').format(item.subtotal)} DZD',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accentLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${NumberFormat('#,###').format(order.totalAmount)} DZD',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Orders',
        showBackButton: false,
        additionalActions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 24),
            color: AppColors.accent,
            onPressed: () {
              Navigator.pushNamed(context, '/new-sale');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDateRange(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: AppColors.iconPrimary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              selectedDateRange == null
                                  ? 'Date Range'
                                  : '${DateFormat('dd/MM').format(selectedDateRange!.start)} - ${DateFormat('dd/MM').format(selectedDateRange!.end)}',
                                  style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, color: AppColors.iconPrimary),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                        onTap: () => _showStatusFilter(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                                Icons.filter_alt_outlined,
                            size: 18,
                            color: AppColors.iconPrimary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                                  selectedStatus ?? 'Status',
                                  style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, color: AppColors.iconPrimary),
                        ],
                      ),
                    ),
                  ),
                ),
                  ],
                ),
                if (selectedDateRange != null || selectedStatus != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _clearFilters,
                            icon: const Icon(Icons.clear, size: 16),
                            label: const Text('Clear Filters'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                              foregroundColor: AppColors.textOnPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ],
                  ),
                ),
              ],
            ),
          ),

          // Orders List
          Expanded(
            child: BlocListener<OrdersCubit, OrdersState>(
              listener: (context, state) {
                if (state is OrderDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order deleted successfully and stock restored'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                } else if (state is OrderStatusUpdated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Order status updated to ${state.order.status}'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                } else if (state is OrdersError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              child: BlocBuilder<OrdersCubit, OrdersState>(
                builder: (context, state) {
                if (state is OrdersLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is OrdersError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: AppColors.error),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: const TextStyle(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _applyFilters(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is OrdersLoaded) {
                  final orders = state.orders;

                  if (orders.isEmpty) {
                    return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 64,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: 16),
                          const Text(
                          'No orders found',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final orderDate = order.createdAt != null
                          ? DateTime.parse(order.createdAt!)
                          : DateTime.now();
                      final itemCount = order.items.length;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            order.orderNumber,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 14,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                      '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                                      style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                      DateFormat('dd MMM yyyy, HH:mm').format(orderDate),
                                      style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: order.status == 'completed'
                                            ? AppColors.successLight
                                            : AppColors.errorLight,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        order.status.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: order.status == 'completed'
                                              ? AppColors.success
                                              : AppColors.error,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      order.paymentMethod == 'cash'
                                          ? Icons.money
                                          : Icons.credit_card,
                                      size: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      order.paymentMethod.toUpperCase(),
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${NumberFormat('#,###').format(order.totalAmount)} DZD',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert, size: 20),
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    _deleteOrder(context, order.id);
                                  } else if (value == 'refund') {
                                    _updateOrderStatus(context, order.id, 'refunded');
                                  } else if (value == 'cancel') {
                                    _updateOrderStatus(context, order.id, 'cancelled');
                                  }
                                },
                                itemBuilder: (context) => [
                                  if (order.status == 'completed')
                                    const PopupMenuItem(
                                      value: 'refund',
                                      child: Row(
                                        children: [
                                          Icon(Icons.undo, size: 20, color: AppColors.warning),
                                          SizedBox(width: 8),
                                          Text('Mark as Refunded'),
                                        ],
                                      ),
                                    ),
                                  if (order.status != 'cancelled')
                                    const PopupMenuItem(
                                      value: 'cancel',
                                      child: Row(
                                        children: [
                                          Icon(Icons.cancel, size: 20, color: AppColors.error),
                                          SizedBox(width: 8),
                                          Text('Cancel Order'),
                                        ],
                                      ),
                                    ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, size: 20, color: AppColors.error),
                                        SizedBox(width: 8),
                                        Text('Delete Order'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            _showOrderDetails(context, order, orderDate);
                          },
                        ),
                      );
                    },
                  );
                }

                return const Center(child: Text('No orders'));
                },
              ),
                  ),
          ),
        ],
      ),
    );
  }

  void _deleteOrder(BuildContext context, int orderId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Order'),
        content: const Text('Are you sure you want to delete this order? Stock will be restored. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<OrdersCubit>().deleteOrder(orderId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textOnPrimary,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _updateOrderStatus(BuildContext context, int orderId, String status) {
    final statusText = status == 'refunded' ? 'refunded' : 'cancelled';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mark Order as ${statusText.toUpperCase()}'),
        content: Text('Are you sure you want to mark this order as $statusText?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<OrdersCubit>().updateOrderStatus(
                orderId: orderId,
                status: status,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: status == 'refunded' ? AppColors.warning : AppColors.error,
              foregroundColor: AppColors.textOnPrimary,
            ),
            child: Text('Mark as ${statusText.toUpperCase()}'),
          ),
        ],
      ),
    );
  }
}
