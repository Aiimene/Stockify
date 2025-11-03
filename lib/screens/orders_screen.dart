import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  DateTimeRange? selectedDateRange;
  String? selectedProduct;

  final List<Map<String, dynamic>> orders = [
    {
      'id': '1',
      'orderName': 'Order #1847',
      'itemCount': 3,
      'date': DateTime(2023, 10, 15, 14, 30),
      'price': 7500,
    },
    {
      'id': '2',
      'orderName': 'Morning Sale #2156',
      'itemCount': 2,
      'date': DateTime(2023, 10, 15, 11, 15),
      'price': 4800,
    },
    {
      'id': '3',
      'orderName': 'Customer Ahmed',
      'itemCount': 5,
      'date': DateTime(2023, 10, 14, 18, 5),
      'price': 12250,
    },
    {
      'id': '4',
      'orderName': 'Order #1845',
      'itemCount': 1,
      'date': DateTime(2023, 10, 13, 9, 45),
      'price': 8900,
    },
    {
      'id': '5',
      'orderName': 'Customer Fatima',
      'itemCount': 4,
      'date': DateTime(2023, 10, 12, 16, 20),
      'price': 15200,
    },
    {
      'id': '6',
      'orderName': 'Order #1842',
      'itemCount': 2,
      'date': DateTime(2023, 10, 11, 10, 30),
      'price': 3600,
    },
    {
      'id': '7',
      'orderName': 'Bulk Order #1840',
      'itemCount': 8,
      'date': DateTime(2023, 10, 10, 14, 15),
      'price': 28500,
    },
    {
      'id': '8',
      'orderName': 'Customer Karim',
      'itemCount': 3,
      'date': DateTime(2023, 10, 9, 11, 45),
      'price': 9800,
    },
  ];

  List<Map<String, dynamic>> get filteredOrders {
    var filtered = List<Map<String, dynamic>>.from(orders);

    // Filter by date range
    if (selectedDateRange != null) {
      filtered = filtered.where((order) {
        final orderDate = order['date'] as DateTime;
        return orderDate.isAfter(
              selectedDateRange!.start.subtract(const Duration(days: 1)),
            ) &&
            orderDate.isBefore(
              selectedDateRange!.end.add(const Duration(days: 1)),
            );
      }).toList();
    }

    // Filter by product
    if (selectedProduct != null && selectedProduct!.isNotEmpty) {
      filtered = filtered.where((order) {
        return (order['orderName'] as String).toLowerCase().contains(
          selectedProduct!.toLowerCase(),
        );
      }).toList();
    }

    // Sort by most recent
    filtered.sort(
      (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
    );

    return filtered;
  }

  List<String> get productNames {
    return orders.map((order) => order['orderName'] as String).toSet().toList()
      ..sort();
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
            colorScheme: const ColorScheme.light(primary: Color(0xFF4CAF50)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
    }
  }

  void _showProductFilter(BuildContext context) {
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
                'Filter by Product',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('All Orders'),
                leading: Radio<String?>(
                  value: null,
                  groupValue: selectedProduct,
                  onChanged: (value) {
                    setState(() {
                      selectedProduct = value;
                    });
                    Navigator.pop(context);
                  },
                  activeColor: const Color(0xFF4CAF50),
                ),
                onTap: () {
                  setState(() {
                    selectedProduct = null;
                  });
                  Navigator.pop(context);
                },
              ),
              ...productNames.map((product) {
                return ListTile(
                  title: Text(product),
                  leading: Radio<String?>(
                    value: product,
                    groupValue: selectedProduct,
                    onChanged: (value) {
                      setState(() {
                        selectedProduct = value;
                      });
                      Navigator.pop(context);
                    },
                    activeColor: const Color(0xFF4CAF50),
                  ),
                  onTap: () {
                    setState(() {
                      selectedProduct = product;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredOrders;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Orders',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.black,
              size: 26,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black, size: 28),
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
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
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
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              selectedDateRange == null
                                  ? 'Date Range'
                                  : '${DateFormat('dd/MM').format(selectedDateRange!.start)} - ${DateFormat('dd/MM').format(selectedDateRange!.end)}',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => _showProductFilter(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 18,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              selectedProduct ?? 'Product',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    size: 20,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          // Orders List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No orders found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final order = filtered[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                            order['orderName'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${order['itemCount']} items',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat(
                                    'dd MMM yyyy, HH:mm',
                                  ).format(order['date']),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: Text(
                            '${NumberFormat('#,###').format(order['price'])} DZD',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          onTap: () {
                            // Navigate to order details (to be implemented later)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Order ${order['id']} details'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
