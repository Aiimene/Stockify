class OrderItem {
  final int id;
  final int? orderId;
  final int? productId;
  final String productName;
  final String? productSku;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  OrderItem({
    required this.id,
    this.orderId,
    this.productId,
    required this.productName,
    this.productSku,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      orderId: json['order_id'] != null
          ? (json['order_id'] is int 
              ? json['order_id'] as int 
              : int.tryParse(json['order_id'].toString()))
          : null,
      productId: json['product_id'] != null
          ? (json['product_id'] is int 
              ? json['product_id'] as int 
              : int.tryParse(json['product_id'].toString()))
          : null,
      productName: json['product_name'] as String,
      productSku: json['product_sku'] as String?,
      quantity: json['quantity'] is int 
          ? json['quantity'] as int 
          : int.parse(json['quantity'].toString()),
      unitPrice: json['unit_price'] is double
          ? json['unit_price'] as double
          : double.parse(json['unit_price'].toString()),
      subtotal: json['subtotal'] is double
          ? json['subtotal'] as double
          : double.parse(json['subtotal'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'product_sku': productSku,
      'quantity': quantity,
      'unit_price': unitPrice,
      'subtotal': subtotal,
    };
  }
}

class Order {
  final int id;
  final int? userId;
  final String orderNumber;
  final double totalAmount;
  final String status;
  final String paymentMethod;
  final String? createdAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    this.userId,
    required this.orderNumber,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    this.createdAt,
    this.items = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      userId: json['user_id'] != null
          ? (json['user_id'] is int 
              ? json['user_id'] as int 
              : int.tryParse(json['user_id'].toString()))
          : null,
      orderNumber: json['order_number'] as String,
      totalAmount: json['total_amount'] is double
          ? json['total_amount'] as double
          : double.parse(json['total_amount'].toString()),
      status: json['status'] as String,
      paymentMethod: json['payment_method'] as String,
      createdAt: json['created_at'] as String?,
      items: json['items'] != null
          ? (json['items'] as List).map((item) => OrderItem.fromJson(item)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'order_number': orderNumber,
      'total_amount': totalAmount,
      'status': status,
      'payment_method': paymentMethod,
      'created_at': createdAt,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

