class ApiConfig {
  static const String baseUrl = 'https://darkcyan-armadillo-747887.hostingersite.com';
  static const String loginEndpoint = '/app/api/login.php';
  static const String registerEndpoint = '/app/api/register.php';
  static const String logoutEndpoint = '/app/api/logout.php';
  static const String validateEndpoint = '/app/api/validate.php';
  static const String productsEndpoint = '/app/api/products.php';
  static const String addProductEndpoint = '/app/api/add_product.php';
  static const String updateProductEndpoint = '/app/api/update_product.php';
  static const String deleteProductEndpoint = '/app/api/delete_product.php';
  static const String ordersEndpoint = '/app/api/order.php';
  static const String deleteOrderEndpoint = '/app/api/delete_order.php';
  static const String updateOrderStatusEndpoint = '/app/api/update_order_status.php';
  static const String statisticsEndpoint = '/app/api/statistics.php';
  static const String userEndpoint = '/app/api/user.php';

  static String get loginUrl => '$baseUrl$loginEndpoint';
  static String get registerUrl => '$baseUrl$registerEndpoint';
  static String get logoutUrl => '$baseUrl$logoutEndpoint';
  static String get validateUrl => '$baseUrl$validateEndpoint';
  static String get productsUrl => '$baseUrl$productsEndpoint';
  static String get addProductUrl => '$baseUrl$addProductEndpoint';
  static String get updateProductUrl => '$baseUrl$updateProductEndpoint';
  static String get deleteProductUrl => '$baseUrl$deleteProductEndpoint';
  static String get ordersUrl => '$baseUrl$ordersEndpoint';
  static String get deleteOrderUrl => '$baseUrl$deleteOrderEndpoint';
  static String get updateOrderStatusUrl => '$baseUrl$updateOrderStatusEndpoint';
  static String get statisticsUrl => '$baseUrl$statisticsEndpoint';
  static String get userUrl => '$baseUrl$userEndpoint';
  
  static String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    if (imagePath.startsWith('http')) return imagePath;
    return '$baseUrl$imagePath';
  }
}

