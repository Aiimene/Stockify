import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String selectedFilter = 'This Week';
  int displayedProductsCount = 5;
  bool isLoadingMore = false;

  // Dummy data for weekly revenue
  final List<FlSpot> revenueData = [
    const FlSpot(0, 35), // Mon
    const FlSpot(1, 60), // Tue
    const FlSpot(2, 30), // Wed
    const FlSpot(3, 55), // Thu
    const FlSpot(4, 45), // Fri
    const FlSpot(5, 25), // Sat
    const FlSpot(6, 15), // Sun
  ];

  final List<String> weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  // Dummy data for top selling products (10 products total)
  final List<Map<String, dynamic>> topSellingProducts = [
    {
      'name': 'Serum Éclat',
      'unitsSold': '1,230 units sold',
      'price': 'DA 245K',
      'color': Color(0xFFE8F5E9),
      'image': 'assets/images/serum.png',
    },
    {
      'name': 'Crème Hydratante',
      'unitsSold': '980 units sold',
      'price': 'DA 182K',
      'color': Color(0xFFFFF3E0),
      'image': 'assets/images/creme.png',
    },
    {
      'name': 'Mascara Volume',
      'unitsSold': '850 units sold',
      'price': 'DA 150K',
      'color': Color(0xFFFCE4EC),
      'image': 'assets/images/mascara.png',
    },
    {
      'name': 'Foundation Parfait',
      'unitsSold': '720 units sold',
      'price': 'DA 195K',
      'color': Color(0xFFFFEBEE),
      'image': 'assets/images/foundation.png',
    },
    {
      'name': 'Rouge à Lèvres',
      'unitsSold': '690 units sold',
      'price': 'DA 135K',
      'color': Color(0xFFF3E5F5),
      'image': 'assets/images/lipstick.png',
    },
    {
      'name': 'Lotion Tonique',
      'unitsSold': '580 units sold',
      'price': 'DA 165K',
      'color': Color(0xFFE3F2FD),
      'image': 'assets/images/lotion.png',
    },
    {
      'name': 'Gel Nettoyant',
      'unitsSold': '540 units sold',
      'price': 'DA 125K',
      'color': Color(0xFFE0F2F1),
      'image': 'assets/images/cleanser.png',
    },
    {
      'name': 'Masque Visage',
      'unitsSold': '480 units sold',
      'price': 'DA 155K',
      'color': Color(0xFFFFF9C4),
      'image': 'assets/images/mask.png',
    },
    {
      'name': 'Huile Argan',
      'unitsSold': '420 units sold',
      'price': 'DA 210K',
      'color': Color(0xFFFFE0B2),
      'image': 'assets/images/oil.png',
    },
    {
      'name': 'Crème Anti-Âge',
      'unitsSold': '380 units sold',
      'price': 'DA 285K',
      'color': Color(0xFFD1C4E9),
      'image': 'assets/images/anti-age.png',
    },
  ];

  Future<void> _loadMoreProducts() async {
    if (isLoadingMore || displayedProductsCount >= topSellingProducts.length) {
      return;
    }

    setState(() {
      isLoadingMore = true;
    });

    // Simulate async API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      displayedProductsCount = topSellingProducts.length;
      isLoadingMore = false;
    });
  }

  void _showCustomDatePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF3B82F6)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Handle the custom date range
      // You can add logic here to filter analytics by the selected date range
      print('Selected date range: ${picked.start} to ${picked.end}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filter Section
            Row(
              children: [
                Text(
                  'Filter by:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Icon(Icons.tune, size: 20, color: Colors.grey[700]),
                  ),
                  offset: const Offset(0, 45),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'Today',
                          child: Text('Today'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'This Week',
                          child: Text('This Week'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'This Month',
                          child: Text('This Month'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'This Year',
                          child: Text('This Year'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Custom',
                          child: Text('Custom'),
                        ),
                      ],
                  onSelected: (String value) {
                    setState(() {
                      selectedFilter = value;
                    });

                    // If Custom is selected, show date picker
                    if (value == 'Custom') {
                      _showCustomDatePicker();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons
                        .insert_chart_outlined, // Placeholder - replace with SVG
                    title: 'Total Revenue',
                    value: 'DA 1.25M',
                    percentageChange: '+15.2%',
                    isPositive: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _MetricCard(
                    icon: Icons
                        .shopping_bag_outlined, // Placeholder - replace with SVG
                    title: 'Avg. Order Value',
                    value: 'DA 3,450',
                    percentageChange: '-1.8%',
                    isPositive: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons
                        .inventory_2_outlined, // Placeholder - replace with SVG
                    title: 'Total Products',
                    value: '8,230',
                    showViewAll: true,
                    onViewAllTap: () {
                      Navigator.pushNamed(context, '/');
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _MetricCard(
                    icon: Icons
                        .shopping_cart_outlined, // Placeholder - replace with SVG
                    title: 'Total Orders',
                    value: '3,120',
                    percentageChange: '+5.7%',
                    isPositive: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Revenue Trends Chart
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.trending_up,
                          color: Color(0xFF10B981),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Revenue Trends',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    height: 220,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 20,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey[200]!,
                                strokeWidth: 1,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 42,
                                interval: 20,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toInt()}K',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600],
                                    ),
                                  );
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                reservedSize: 32,
                                getTitlesWidget: (value, meta) {
                                  // Show only 5 labels: Mon, Tue, Thu, Sat, Sun
                                  final int index = value.toInt();
                                  if (index == 0 ||
                                      index == 1 ||
                                      index == 3 ||
                                      index == 5 ||
                                      index == 6) {
                                    if (index >= 0 && index < weekDays.length) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10.0,
                                        ),
                                        child: Text(
                                          weekDays[index],
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border(
                              left: BorderSide(
                                color: Colors.grey[200]!,
                                width: 1,
                              ),
                              bottom: BorderSide(
                                color: Colors.grey[200]!,
                                width: 1,
                              ),
                            ),
                          ),
                          minX: 0,
                          maxX: 6,
                          minY: 0,
                          maxY: 80,
                          lineTouchData: LineTouchData(
                            enabled: true,
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipColor: (touchedSpot) =>
                                  const Color(0xFF10B981),
                              tooltipRoundedRadius: 8,
                              tooltipPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((spot) {
                                  return LineTooltipItem(
                                    'DA ${(spot.y * 1000).toStringAsFixed(0)}',
                                    const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                            handleBuiltInTouches: true,
                            getTouchedSpotIndicator: (barData, spotIndexes) {
                              return spotIndexes.map((spotIndex) {
                                return TouchedSpotIndicatorData(
                                  FlLine(
                                    color: const Color(
                                      0xFF10B981,
                                    ).withOpacity(0.5),
                                    strokeWidth: 2,
                                    dashArray: [5, 5],
                                  ),
                                  FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, barData, index) {
                                          return FlDotCirclePainter(
                                            radius: 6,
                                            color: Colors.white,
                                            strokeWidth: 3,
                                            strokeColor: const Color(
                                              0xFF10B981,
                                            ),
                                          );
                                        },
                                  ),
                                );
                              }).toList();
                            },
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: revenueData,
                              isCurved: true,
                              curveSmoothness: 0.4,
                              preventCurveOverShooting: true,
                              color: const Color(0xFF10B981),
                              barWidth: 3.5,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                    strokeColor: const Color(0xFF10B981),
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF10B981).withOpacity(0.3),
                                    const Color(0xFF10B981).withOpacity(0.05),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Top Selling Products
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Top Selling Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayedProductsCount,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final product = topSellingProducts[index];
                      return Row(
                        children: [
                          // Product image/avatar
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: product['color'],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: product['image'] != null
                                  ? Image.asset(
                                      product['image'],
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        // Fallback to letter if image fails to load
                                        return Center(
                                          child: Text(
                                            product['name'][0],
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Center(
                                      child: Text(
                                        product['name'][0],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Product info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product['unitsSold'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Price
                          Text(
                            product['price'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  // Load More Button
                  if (displayedProductsCount < topSellingProducts.length)
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: isLoadingMore
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF3B82F6),
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : IconButton(
                                  onPressed: _loadMoreProducts,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 28,
                                    color: Colors.grey[700],
                                  ),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.grey[100],
                                    padding: const EdgeInsets.all(8),
                                  ),
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

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? percentageChange;
  final bool? isPositive;
  final bool showViewAll;
  final VoidCallback? onViewAllTap;

  const _MetricCard({
    required this.icon,
    required this.title,
    required this.value,
    this.percentageChange,
    this.isPositive,
    this.showViewAll = false,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
              Icon(icon, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
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
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          if (percentageChange != null)
            Row(
              children: [
                Icon(
                  isPositive == true
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  size: 14,
                  color: isPositive == true
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                ),
                const SizedBox(width: 4),
                Text(
                  percentageChange!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isPositive == true
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          if (showViewAll)
            GestureDetector(
              onTap: onViewAllTap,
              child: Row(
                children: [
                  Icon(Icons.arrow_forward, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
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
