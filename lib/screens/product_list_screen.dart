import 'package:flutter/material.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  String _searchQuery = '';
  double? _minPrice;
  double? _maxPrice;
  
  // Sample product data
  final List<Map<String, dynamic>> products = const [
    {
      'name': 'Hydrating Face Cream',
      'price': '1500 DZD',
      'stock': 1,
      'image': 'assets/images/creme.png',
      'color': Color(0xFFE8F5F0),
    },
    {
      'name': 'Matte Lipstick',
      'price': '850 DZD',
      'stock': 120,
      'image': 'assets/images/lipstick.png',
      'color': Color(0xFF8B4646),
    },
    {
      'name': 'Vitamin C Serum',
      'price': '2200 DZD',
      'stock': 30,
      'image': 'assets/images/serum.png',
      'color': Color(0xFFE6B84D),
    },
    {
      'name': 'Sunscreen SPF 50',
      'price': '1800 DZD',
      'stock': 8,
      'image': 'assets/images/sunscreen.png',
      'color': Color(0xFFD4B896),
    },
    {
      'name': 'Eyeshadow Palette',
      'price': '3500 DZD',
      'stock': 75,
      'image': 'assets/images/eyeshadow.png',
      'color': Color(0xFFE6B8B0),
    },
    {
      'name': 'Nourishing Shampoo',
      'price': '1200 DZD',
      'stock': 40,
      'image': 'assets/images/shampoo.png',
      'color': Color(0xFF6B8E6B),
    },
    {
      'name': 'Anti-Aging Serum',
      'price': '2850 DZD',
      'stock': 25,
      'image': 'assets/images/anti-age.png',
      'color': Color(0xFFD1C4E9),
    },
    {
      'name': 'Cleansing Gel',
      'price': '1250 DZD',
      'stock': 60,
      'image': 'assets/images/cleanser.png',
      'color': Color(0xFFE0F2F1),
    },
    {
      'name': 'Face Toner',
      'price': '1650 DZD',
      'stock': 45,
      'image': 'assets/images/lotion.png',
      'color': Color(0xFFE3F2FD),
    },
    {
      'name': 'Night Cream',
      'price': '1950 DZD',
      'stock': 35,
      'image': 'assets/images/night-cream.png',
      'color': Color(0xFFFFEBEE),
    },
    {
      'name': 'Mascara Volume Plus',
      'price': '1500 DZD',
      'stock': 90,
      'image': 'assets/images/mascara.png',
      'color': Color(0xFFFCE4EC),
    },
    {
      'name': 'Foundation Natural',
      'price': '1950 DZD',
      'stock': 50,
      'image': 'assets/images/foundation.png',
      'color': Color(0xFFFFEBEE),
    },
    {
      'name': 'Face Mask Hydrating',
      'price': '1550 DZD',
      'stock': 42,
      'image': 'assets/images/mask.png',
      'color': Color(0xFFFFF9C4),
    },
    {
      'name': 'Argan Oil',
      'price': '2100 DZD',
      'stock': 28,
      'image': 'assets/images/oil.png',
      'color': Color(0xFFFFE0B2),
    },
    {
      'name': 'Micellar Water',
      'price': '1350 DZD',
      'stock': 65,
      'image': 'assets/images/micellar.png',
      'color': Color(0xFFE1F5FE),
    },
    {
      'name': 'Body Lotion',
      'price': '1450 DZD',
      'stock': 55,
      'image': 'assets/images/body-lotion.png',
      'color': Color(0xFFF3E5F5),
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredProducts {
    List<Map<String, dynamic>> filtered = products;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        return product['name'].toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply price filter
    if (_minPrice != null || _maxPrice != null) {
      filtered = filtered.where((product) {
        int price = int.parse(product['price'].replaceAll(RegExp(r'[^0-9]'), ''));
        
        if (_minPrice != null && price < _minPrice!) {
          return false;
        }
        if (_maxPrice != null && price > _maxPrice!) {
          return false;
        }
        return true;
      }).toList();
    }

    return filtered;
  }

  String get priceFilterLabel {
    if (_minPrice != null && _maxPrice != null) {
      return '${_minPrice!.toInt()} - ${_maxPrice!.toInt()} DZD';
    } else if (_minPrice != null) {
      return 'From ${_minPrice!.toInt()} DZD';
    } else if (_maxPrice != null) {
      return 'Up to ${_maxPrice!.toInt()} DZD';
    }
    return '';
  }

  void _showFilterDialog() {
    // Set initial values
    _minPriceController.text = _minPrice?.toInt().toString() ?? '';
    _maxPriceController.text = _maxPrice?.toInt().toString() ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Price'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _minPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Min Price (DZD)',
                hintText: 'Enter minimum price',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _maxPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Max Price (DZD)',
                hintText: 'Enter maximum price',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _minPrice = null;
                _maxPrice = null;
                _minPriceController.clear();
                _maxPriceController.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _minPrice = _minPriceController.text.isNotEmpty
                    ? double.tryParse(_minPriceController.text)
                    : null;
                _maxPrice = _maxPriceController.text.isNotEmpty
                    ? double.tryParse(_maxPriceController.text)
                    : null;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Products',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar and Filter Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF6B7280)),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Color(0xFF6B7280)),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list, color: Color(0xFF1A1A1A)),
                    onPressed: _showFilterDialog,
                    tooltip: 'Filter',
                  ),
                ),
              ],
            ),
          ),
          // Active Filters
          if (_minPrice != null || _maxPrice != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Chip(
                    label: Text(priceFilterLabel),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      setState(() {
                        _minPrice = null;
                        _maxPrice = null;
                        _minPriceController.clear();
                        _maxPriceController.clear();
                      });
                    },
                    backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
                    labelStyle: const TextStyle(
                      color: Color(0xFF6366F1),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          // Product Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: filteredProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No products found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return _buildProductCard(context, product);
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-product');
        },
        backgroundColor: const Color(0xFF6366F1),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    // Determine stock status color
    Color stockColor;
    if (product['stock'] > 50) {
      stockColor = Colors.green;
    } else if (product['stock'] > 20) {
      stockColor = Colors.orange;
    } else {
      stockColor = Colors.red;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: product['color'] ?? Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      product['image'],
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback icon if image doesn't exist
                        return Icon(
                          Icons.shopping_bag_outlined,
                          size: 60,
                          color: Colors.grey[400],
                        );
                      },
                    ),
                  ),
                ),
              ),
              // Product Details
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product Name
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Price
                    Text(
                      product['price'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Stock
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: stockColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Stock: ${product['stock']}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: stockColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Edit button positioned at bottom right
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                // Navigate to edit product screen
                Navigator.pushNamed(context, '/product-detail');
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

