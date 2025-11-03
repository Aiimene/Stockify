import 'package:flutter/material.dart';
import 'screens/orders_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/new_sale_screen.dart';
// This line must be present

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App Name',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      initialRoute: '/orders',
      routes: {
        '/orders': (context) => const OrdersScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/new-sale': (context) => const NewSaleScreen(),
      },
    );
  }
}
