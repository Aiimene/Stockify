import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../../config/api_config.dart';

class ProductsRepository {
  static const String _tokenKey = 'auth_token';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token?.trim(); // Ensure token is trimmed
  }

  Future<Map<String, dynamic>> getProducts({
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication required',
        };
      }

      final uri = Uri.parse(ApiConfig.productsUrl).replace(
        queryParameters: {
          if (minPrice != null) 'minprice': minPrice.toString(),
          if (maxPrice != null) 'maxprice': maxPrice.toString(),
        },
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
        final productsJson = data['products'] as List;
        final products = productsJson.map((p) => Product.fromJson(p)).toList();

        return {
          'success': true,
          'products': products,
          'count': data['count'] as int? ?? products.length,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] as String? ?? 'Failed to fetch products',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> addProduct({
    required String name,
    String? sku,
    String? barcode,
    String? description,
    double? costPrice,
    double? sellingPrice,
    int stockQuantity = 0,
    int lowStockThreshold = 5,
    String? expiryDate,
    File? imageFile,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication required',
        };
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.addProductUrl),
      );

      // Ensure token is properly formatted
      final cleanToken = token.trim();
      request.headers['Authorization'] = 'Bearer $cleanToken';
      request.headers['Content-Type'] = 'multipart/form-data';

      request.fields['name'] = name;
      if (sku != null && sku.isNotEmpty) request.fields['sku'] = sku;
      if (barcode != null && barcode.isNotEmpty) request.fields['barcode'] = barcode;
      if (description != null && description.isNotEmpty) request.fields['description'] = description;
      if (costPrice != null) request.fields['cost_price'] = costPrice.toString();
      if (sellingPrice != null) request.fields['selling_price'] = sellingPrice.toString();
      request.fields['stock_quantity'] = stockQuantity.toString();
      request.fields['low_stock_threshold'] = lowStockThreshold.toString();
      if (expiryDate != null && expiryDate.isNotEmpty) request.fields['expiry_date'] = expiryDate;

      if (imageFile != null && await imageFile.exists()) {
        final fileStream = http.ByteStream(imageFile.openRead());
        final fileLength = await imageFile.length();
        final multipartFile = http.MultipartFile(
          'image',
          fileStream,
          fileLength,
          filename: imageFile.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      // Handle authentication errors (401) without redirecting
      if (response.statusCode == 401) {
        try {
          final errorData = jsonDecode(response.body) as Map<String, dynamic>;
          return {
            'success': false,
            'message': errorData['message'] as String? ?? 'Authentication failed. Please check your login.',
            'authError': true, // Flag to indicate auth error
          };
        } catch (_) {
          return {
            'success': false,
            'message': 'Authentication failed. Please login again.',
            'authError': true,
          };
        }
      }
      
      if (response.statusCode != 200 && response.statusCode != 201) {
        try {
          final errorData = jsonDecode(response.body) as Map<String, dynamic>;
          return {
            'success': false,
            'message': errorData['message'] as String? ?? 'Failed to add product',
          };
        } catch (_) {
          return {
            'success': false,
            'message': 'Failed to add product. Status: ${response.statusCode}',
          };
        }
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['success'] == true) {
        try {
          final productJson = data['product'] as Map<String, dynamic>;
          final product = Product.fromJson(productJson);
          return {
            'success': true,
            'product': product,
            'message': data['message'] as String? ?? 'Product added successfully',
          };
        } catch (e) {
          // Product was added but parsing failed - still return success
          return {
            'success': true,
            'message': data['message'] as String? ?? 'Product added successfully (parsing error: ${e.toString()})',
          };
        }
      } else {
        return {
          'success': false,
          'message': data['message'] as String? ?? 'Failed to add product',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> getProductById(int productId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication required',
        };
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.productsUrl}?product_id=$productId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['success'] == true) {
        final productsJson = data['products'] as List;
        if (productsJson.isNotEmpty) {
          final product = Product.fromJson(productsJson.first as Map<String, dynamic>);
          return {
            'success': true,
            'product': product,
          };
        } else {
          return {
            'success': false,
            'message': 'Product not found',
          };
        }
      } else {
        return {
          'success': false,
          'message': data['message'] as String? ?? 'Failed to fetch product',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> updateProduct({
    required int productId,
    required String name,
    String? sku,
    String? barcode,
    String? description,
    double? costPrice,
    double? sellingPrice,
    int? stockQuantity,
    int? lowStockThreshold,
    String? expiryDate,
    File? imageFile,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication required',
        };
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.updateProductUrl),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.fields['product_id'] = productId.toString();
      request.fields['name'] = name;
      if (sku != null && sku.isNotEmpty) request.fields['sku'] = sku;
      if (barcode != null && barcode.isNotEmpty) request.fields['barcode'] = barcode;
      if (description != null && description.isNotEmpty) request.fields['description'] = description;
      if (costPrice != null) request.fields['cost_price'] = costPrice.toString();
      if (sellingPrice != null) request.fields['selling_price'] = sellingPrice.toString();
      if (stockQuantity != null) request.fields['stock_quantity'] = stockQuantity.toString();
      if (lowStockThreshold != null) request.fields['low_stock_threshold'] = lowStockThreshold.toString();
      if (expiryDate != null && expiryDate.isNotEmpty) request.fields['expiry_date'] = expiryDate;

      if (imageFile != null && await imageFile.exists()) {
        final fileStream = http.ByteStream(imageFile.openRead());
        final fileLength = await imageFile.length();
        final multipartFile = http.MultipartFile(
          'image',
          fileStream,
          fileLength,
          filename: imageFile.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode != 200 && response.statusCode != 201) {
        try {
          final errorData = jsonDecode(response.body) as Map<String, dynamic>;
          return {
            'success': false,
            'message': errorData['message'] as String? ?? 'Failed to update product',
          };
        } catch (_) {
          return {
            'success': false,
            'message': 'Failed to update product. Status: ${response.statusCode}',
          };
        }
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['success'] == true) {
        try {
          final productJson = data['product'] as Map<String, dynamic>;
          final product = Product.fromJson(productJson);
          return {
            'success': true,
            'product': product,
            'message': data['message'] as String? ?? 'Product updated successfully',
          };
        } catch (e) {
          return {
            'success': true,
            'message': data['message'] as String? ?? 'Product updated successfully (parsing error: ${e.toString()})',
          };
        }
      } else {
        return {
          'success': false,
          'message': data['message'] as String? ?? 'Failed to update product',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> deleteProduct(int productId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication required',
        };
      }

      final response = await http.post(
        Uri.parse(ApiConfig.deleteProductUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'product_id': productId,
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['success'] == true) {
        return {
          'success': true,
          'message': data['message'] as String? ?? 'Product deleted successfully',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] as String? ?? 'Failed to delete product',
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

