import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../presentation/themes/app_colors.dart';
import '../../presentation/widgets/custom_app_bar.dart';
import '../../logic/cubits/statistics_cubit.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String selectedFilter = 'This Month';
  DateTimeRange? customDateRange;
  int displayedProductsCount = 5;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  void _loadStatistics() {
    final dateRange = _getDateRangeForFilter(selectedFilter);
    context.read<StatisticsCubit>().loadStatistics(
      startDate: dateRange['start'],
      endDate: dateRange['end'],
    );
  }

  Map<String, String?> _getDateRangeForFilter(String filter) {
    final now = DateTime.now();
    switch (filter) {
      case 'Today':
        final today = DateFormat('yyyy-MM-dd').format(now);
        return {'start': today, 'end': today};
      case 'This Week':
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        return {
          'start': DateFormat('yyyy-MM-dd').format(weekStart),
          'end': DateFormat('yyyy-MM-dd').format(now),
        };
      case 'This Month':
        return {
          'start': DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, 1)),
          'end': DateFormat('yyyy-MM-dd').format(now),
        };
      case 'This Year':
        return {
          'start': DateFormat('yyyy-MM-dd').format(DateTime(now.year, 1, 1)),
          'end': DateFormat('yyyy-MM-dd').format(now),
        };
      case 'Custom':
        if (customDateRange != null) {
          return {
            'start': DateFormat('yyyy-MM-dd').format(customDateRange!.start),
            'end': DateFormat('yyyy-MM-dd').format(customDateRange!.end),
          };
        }
        return {'start': null, 'end': null};
      default:
        return {'start': null, 'end': null};
    }
  }

  void _showCustomDatePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: customDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        customDateRange = picked;
        selectedFilter = 'Custom';
      });
      _loadStatistics();
    }
  }

  List<FlSpot> _buildRevenueSpots(List<dynamic> dailyRevenue) {
    if (dailyRevenue.isEmpty) {
      return List.generate(7, (index) => FlSpot(index.toDouble(), 0));
    }

    // Get last 7 days of data
    final spots = <FlSpot>[];
    for (int i = 0; i < dailyRevenue.length && i < 7; i++) {
      final revenue = (dailyRevenue[i]['revenue'] as num?)?.toDouble() ?? 0.0;
      // Convert to thousands for display
      spots.add(FlSpot(i.toDouble(), revenue / 1000));
    }

    // Fill remaining days with zeros if needed
    while (spots.length < 7) {
      spots.add(FlSpot(spots.length.toDouble(), 0));
    }

    return spots;
  }

  double _getMaxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 80;
    final maxValue = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    return maxValue > 0 ? (maxValue * 1.2).ceilToDouble() : 80;
  }

  List<String> _getWeekDayLabels(List<dynamic> dailyRevenue) {
    if (dailyRevenue.isEmpty) {
      return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    }

    final labels = <String>[];
    for (int i = 0; i < dailyRevenue.length && i < 7; i++) {
      try {
        final dateStr = dailyRevenue[i]['date'] as String?;
        if (dateStr != null) {
          final date = DateTime.parse(dateStr);
          final weekday = DateFormat('EEE').format(date);
          labels.add(weekday);
        } else {
          labels.add('');
        }
      } catch (e) {
        labels.add('');
      }
    }

    while (labels.length < 7) {
      labels.add('');
    }

    return labels;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StatisticsCubit, StatisticsState>(
      listener: (context, state) {
        if (state is StatisticsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(
          title: 'Analytics',
          showBackButton: false,
        ),
        body: BlocBuilder<StatisticsCubit, StatisticsState>(
          builder: (context, state) {
            if (state is StatisticsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is StatisticsError) {
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
                      onPressed: _loadStatistics,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is StatisticsLoaded) {
              final stats = state.statistics;
              final totalRevenue = (stats['total_revenue'] as num?)?.toDouble() ?? 0.0;
              final totalOrders = (stats['total_orders'] as num?)?.toInt() ?? 0;
              final avgOrderValue = (stats['average_order_value'] as num?)?.toDouble() ?? 0.0;
              final totalProducts = (stats['total_products'] as num?)?.toInt() ?? 0;
              final topProducts = (stats['top_products'] as List<dynamic>?) ?? [];
              final dailyRevenue = (stats['daily_revenue'] as List<dynamic>?) ?? [];

              final revenueSpots = _buildRevenueSpots(dailyRevenue);
              final maxY = _getMaxY(revenueSpots);
              final weekDayLabels = _getWeekDayLabels(dailyRevenue);

              return SingleChildScrollView(
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
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Icon(
                              Icons.tune,
                              size: 20,
                              color: Colors.grey[700],
                            ),
                          ),
                          offset: const Offset(0, 45),
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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

                            if (value == 'Custom') {
                              _showCustomDatePicker();
                            } else {
                              _loadStatistics();
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Metric Cards
                    Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            icon: Icons.insert_chart_outlined,
                            title: 'Total Revenue',
                            value: '${NumberFormat('#,###').format(totalRevenue)} DZD',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _MetricCard(
                            icon: Icons.shopping_bag_outlined,
                            title: 'Avg. Order Value',
                            value: '${NumberFormat('#,###').format(avgOrderValue)} DZD',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            icon: Icons.inventory_2_outlined,
                            title: 'Total Products',
                            value: NumberFormat('#,###').format(totalProducts),
                            showViewAll: true,
                            onViewAllTap: () {
                              Navigator.pushNamed(context, '/');
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _MetricCard(
                            icon: Icons.shopping_cart_outlined,
                            title: 'Total Orders',
                            value: NumberFormat('#,###').format(totalOrders),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Revenue Trends Chart
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
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
                                  color: AppColors.accentLight.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.trending_up,
                                  color: AppColors.accent,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Revenue Trends (Last 7 Days)',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
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
                                    horizontalInterval: maxY > 0 ? maxY / 5 : 20,
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
                                        interval: maxY > 0 ? maxY / 5 : 20,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            '${value.toInt()}K',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.textSecondary,
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
                                          final int index = value.toInt();
                                          if (index >= 0 && index < weekDayLabels.length && weekDayLabels[index].isNotEmpty) {
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 10.0),
                                              child: Text(
                                                weekDayLabels[index],
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                            );
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
                                  maxY: maxY,
                                  lineTouchData: LineTouchData(
                                    enabled: true,
                                    touchTooltipData: LineTouchTooltipData(
                                      getTooltipColor: (touchedSpot) => AppColors.accent,
                                      tooltipRoundedRadius: 8,
                                      tooltipPadding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      getTooltipItems: (touchedSpots) {
                                        return touchedSpots.map((spot) {
                                          return LineTooltipItem(
                                            '${NumberFormat('#,###').format((spot.y * 1000))} DZD',
                                            const TextStyle(
                                              color: AppColors.surface,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          );
                                        }).toList();
                                      },
                                    ),
                                    handleBuiltInTouches: true,
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: revenueSpots,
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
                                            color: AppColors.surface,
                                            strokeWidth: 2.5,
                                            strokeColor: const Color(0xFF10B981),
                                          );
                                        },
                                      ),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.accent.withOpacity(0.3),
                                            AppColors.accent.withOpacity(0.05),
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
                        color: AppColors.surface,
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
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (topProducts.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.inventory_2_outlined,
                                      size: 48,
                                      color: AppColors.textTertiary,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No sales data available',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: displayedProductsCount > topProducts.length
                                  ? topProducts.length
                                  : displayedProductsCount,
                              separatorBuilder: (context, index) => const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final product = topProducts[index];
                                final productName = product['product_name'] as String? ?? 'Unknown Product';
                                final totalQuantity = (product['total_quantity'] as num?)?.toInt() ?? 0;
                                final totalRevenue = (product['total_revenue'] as num?)?.toDouble() ?? 0.0;

                                // Generate color based on index
                                final colors = [
                                  AppColors.successLight,
                                  AppColors.warningLight,
                                  AppColors.errorLight,
                                  AppColors.infoLight,
                                  AppColors.primaryLight,
                                ];
                                final color = colors[index % colors.length];

                                return Row(
                                  children: [
                                    // Product avatar
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Text(
                                          productName.isNotEmpty ? productName[0].toUpperCase() : '?',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700],
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
                                            productName,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${NumberFormat('#,###').format(totalQuantity)} units sold',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Revenue
                                    Text(
                                      '${NumberFormat('#,###').format(totalRevenue)} DZD',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          // Load More Button
                          if (displayedProductsCount < topProducts.length && topProducts.isNotEmpty)
                            Column(
                              children: [
                                const SizedBox(height: 20),
                                Center(
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        displayedProductsCount = topProducts.length;
                                      });
                                    },
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
              );
            }

            return const Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool showViewAll;
  final VoidCallback? onViewAllTap;

  const _MetricCard({
    required this.icon,
    required this.title,
    required this.value,
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
              Icon(
                icon,
                size: 20,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
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
                  Icon(
                    Icons.arrow_forward,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
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
