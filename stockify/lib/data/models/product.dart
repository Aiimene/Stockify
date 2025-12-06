class Product {
  final int id;
  final int? userId;
  final String? sku;
  final String? barcode;
  final String name;
  final String? description;
  final String? imageUrl;
  final double? costPrice;
  final double? sellingPrice;
  final int stockQuantity;
  final int lowStockThreshold;
  final String? expiryDate;
  final bool isDeleted;
  final String? lastUpdatedAt;

  Product({
    required this.id,
    this.userId,
    this.sku,
    this.barcode,
    required this.name,
    this.description,
    this.imageUrl,
    this.costPrice,
    this.sellingPrice,
    this.stockQuantity = 0,
    this.lowStockThreshold = 5,
    this.expiryDate,
    this.isDeleted = false,
    this.lastUpdatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      userId: json['user_id'] != null 
          ? (json['user_id'] is int ? json['user_id'] as int : int.tryParse(json['user_id'].toString()))
          : null,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      costPrice: json['cost_price'] != null 
          ? (json['cost_price'] is double 
              ? json['cost_price'] as double 
              : double.tryParse(json['cost_price'].toString()))
          : null,
      sellingPrice: json['selling_price'] != null
          ? (json['selling_price'] is double
              ? json['selling_price'] as double
              : double.tryParse(json['selling_price'].toString()))
          : null,
      stockQuantity: json['stock_quantity'] != null
          ? (json['stock_quantity'] is int
              ? json['stock_quantity'] as int
              : int.tryParse(json['stock_quantity'].toString()) ?? 0)
          : 0,
      lowStockThreshold: json['low_stock_threshold'] != null
          ? (json['low_stock_threshold'] is int
              ? json['low_stock_threshold'] as int
              : int.tryParse(json['low_stock_threshold'].toString()) ?? 5)
          : 5,
      expiryDate: json['expiry_date'] as String?,
      isDeleted: json['is_deleted'] != null
          ? (json['is_deleted'] is bool
              ? json['is_deleted'] as bool
              : (json['is_deleted'] is int
                  ? (json['is_deleted'] as int) == 1
                  : json['is_deleted'].toString() == '1'))
          : false,
      lastUpdatedAt: json['last_updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'sku': sku,
      'barcode': barcode,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'cost_price': costPrice,
      'selling_price': sellingPrice,
      'stock_quantity': stockQuantity,
      'low_stock_threshold': lowStockThreshold,
      'expiry_date': expiryDate,
      'is_deleted': isDeleted ? 1 : 0,
      'last_updated_at': lastUpdatedAt,
    };
  }
}

