import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';
import '../../config/api_config.dart';

class OrdersRepository {
  static const String _tokenKey = 'auth_token';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<Map<String, dynamic>> getOrders({
    String? startDate,
    String? endDate,
    String? status,
    String? paymentMethod,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication required',
        };
      }

      final queryParams = <String, String>{};
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;
      if (status != null) queryParams['status'] = status;
      if (paymentMethod != null) queryParams['payment_method'] = paymentMethod;

      final uri = Uri.parse(ApiConfig.ordersUrl).replace(
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['success'] == true) {
          final ordersJson = data['orders'] as List;
          final orders = ordersJson.map((o) => Order.fromJson(o)).toList();

          return {
            'success': true,
            'orders': orders,
            'count': data['count'] as int? ?? orders.length,
          };
        } else {
          return {
            'success': false,
            'message': data['message'] as String? ?? data['error'] as String? ?? 'Failed to fetch orders',
          };
        }
      } else {
        // Handle non-200 status codes
        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          return {
            'success': false,
            'message': data['message'] as String? ?? data['error'] as String? ?? 'Failed to fetch orders',
          };
        } catch (e) {
          print('OrdersRepository.getOrders: Failed to parse error response: $e');
          return {
            'success': false,
            'message': 'Failed to fetch orders. Status code: ${response.statusCode}',
          };
        }
      }
    } catch (e) {
      print('OrdersRepository.getOrders error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> createOrder({
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication required',
        };
      }

      final response = await http.post(
        Uri.parse(ApiConfig.ordersUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'payment_method': paymentMethod,
          'items': items,
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['success'] == true) {
        final order = Order.fromJson(data['order'] as Map<String, dynamic>);
        return {
          'success': true,
          'order': order,
          'message': data['message'] as String? ?? 'Order created successfully',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] as String? ?? 'Failed to create order',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> deleteOrder(int orderId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication required',
        };
      }

      final response = await http.post(
        Uri.parse(ApiConfig.deleteOrderUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'order_id': orderId,
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['success'] == true) {
        return {
          'success': true,
          'message': data['message'] as String? ?? 'Order deleted successfully',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] as String? ?? 'Failed to delete order',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> updateOrderStatus({
    required int orderId,
    required String status,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication required',
        };
      }

      final response = await http.post(
        Uri.parse(ApiConfig.updateOrderStatusUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'order_id': orderId,
          'status': status,
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['success'] == true) {
        final order = Order.fromJson(data['order'] as Map<String, dynamic>);
        return {
          'success': true,
          'order': order,
          'message': data['message'] as String? ?? 'Order status updated successfully',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] as String? ?? 'Failed to update order status',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> getStatistics({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication required',
        };
      }

      final queryParams = <String, String>{};
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;

      final uri = Uri.parse(ApiConfig.statisticsUrl).replace(
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['success'] == true) {
        return {
          'success': true,
          'statistics': data['statistics'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] as String? ?? 'Failed to fetch statistics',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}

