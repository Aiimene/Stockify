// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'StockiFy';

  @override
  String get welcome => 'Welcome';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get products => 'Products';

  @override
  String get orders => 'Orders';

  @override
  String get analytics => 'Analytics';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get addProduct => 'Add Product';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get deleteProduct => 'Delete Product';

  @override
  String get productName => 'Product Name';

  @override
  String get sku => 'SKU';

  @override
  String get barcode => 'Barcode';

  @override
  String get description => 'Description';

  @override
  String get costPrice => 'Cost Price';

  @override
  String get sellingPrice => 'Selling Price';

  @override
  String get stockQuantity => 'Stock Quantity';

  @override
  String get lowStockThreshold => 'Low Stock Threshold';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get image => 'Image';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get view => 'View';

  @override
  String get add => 'Add';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get totalRevenue => 'Total Revenue';

  @override
  String get totalOrders => 'Total Orders';

  @override
  String get totalProducts => 'Total Products';

  @override
  String get averageOrderValue => 'Avg. Order Value';

  @override
  String get lowStockCount => 'Low Stock Count';

  @override
  String get revenueTrends => 'Revenue Trends';

  @override
  String get topSellingProducts => 'Top Selling Products';

  @override
  String get lowStockAlerts => 'Low Stock Alerts';

  @override
  String get recentActivities => 'Recent Activities';

  @override
  String get newSale => 'New Sale';

  @override
  String get orderNumber => 'Order Number';

  @override
  String get orderDate => 'Order Date';

  @override
  String get orderStatus => 'Order Status';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get completed => 'Completed';

  @override
  String get refunded => 'Refunded';

  @override
  String get cash => 'Cash';

  @override
  String get card => 'Card';

  @override
  String get notifications => 'Notifications';

  @override
  String get subscription => 'Subscription';

  @override
  String get billing => 'Billing';

  @override
  String get help => 'Help';

  @override
  String get privacy => 'Privacy Policy';

  @override
  String get language => 'Language';

  @override
  String get logout => 'Logout';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get changePassword => 'Change Password';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get update => 'Update';

  @override
  String get viewAll => 'View All';

  @override
  String unitsSold(int count) {
    return '$count units sold';
  }

  @override
  String onlyLeft(int count) {
    return 'Only $count left';
  }

  @override
  String get outOfStock => 'Out of stock';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String pleaseEnter(String field) {
    return 'Please enter $field';
  }

  @override
  String get invalidEmail => 'Please enter a valid email address';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String languageChanged(String language) {
    return 'Language changed to $language';
  }
}
