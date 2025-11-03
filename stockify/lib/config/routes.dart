import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/main_navigation.dart';
import '../screens/add_product_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/new_sale_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/subscription_screen.dart';
import '../screens/billing_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/help_screen.dart';
import '../screens/language_screen.dart';
import '../screens/privacy_screen.dart';

// Route names
class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String addProduct = '/add-product';
  static const String productDetail = '/product-detail';
  static const String newSale = '/new-sale';
  static const String notifications = '/notifications';
  static const String orders = '/orders';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String subscription = '/subscription';
  static const String billing = '/billing';
  static const String checkout = '/checkout';
  static const String help = '/help';
  static const String language = '/language';
  static const String privacy = '/privacy';
}

// Routes object
final Map<String, WidgetBuilder> routes = {
  AppRoutes.welcome: (context) => const WelcomeScreen(),
  AppRoutes.login: (context) => const LoginScreen(),
  AppRoutes.signup: (context) => const SignUpScreen(),
  AppRoutes.home: (context) => const MainNavigation(),
  AppRoutes.addProduct: (context) => const AddProductScreen(),
  AppRoutes.productDetail: (context) => const ProductDetailScreen(),
  AppRoutes.newSale: (context) => const NewSaleScreen(),
  AppRoutes.notifications: (context) => const NotificationsScreen(),
  AppRoutes.orders: (context) => const OrdersScreen(),
  AppRoutes.profile: (context) => const ProfileScreen(),
  AppRoutes.settings: (context) => const SettingsScreen(),
  AppRoutes.subscription: (context) => const SubscriptionScreen(),
  AppRoutes.billing: (context) => const BillingScreen(),
  AppRoutes.checkout: (context) => const CheckoutScreen(),
  AppRoutes.help: (context) => const HelpScreen(),
  AppRoutes.language: (context) => const LanguageScreen(),
  AppRoutes.privacy: (context) => const PrivacyScreen(),
};