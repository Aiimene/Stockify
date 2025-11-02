import 'package:flutter/material.dart';
import '../screens/product_list_screen.dart';
import '../screens/add_product_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/analytics_screen.dart';

// Route names
class AppRoutes {
  static const String productList = '/';
  static const String addProduct = '/add-product';
  static const String productDetail = '/product-detail';
  static const String analytics = '/analytics';
}

// Routes object
final Map<String, WidgetBuilder> routes = {
  AppRoutes.productList: (context) => const ProductListScreen(),
  AppRoutes.addProduct: (context) => const AddProductScreen(),
  AppRoutes.productDetail: (context) => const ProductDetailScreen(),
  AppRoutes.analytics: (context) => const AnalyticsScreen(),
};
