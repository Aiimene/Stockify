import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../presentation/themes/app_colors.dart';
import '../../presentation/widgets/custom_app_bar.dart';
import '../../logic/cubits/products_cubit.dart';
import '../../logic/cubits/orders_cubit.dart';
import '../../data/models/product.dart';
import '../../config/api_config.dart';

class NewSaleScreen extends StatefulWidget {
  const NewSaleScreen({Key? key}) : super(key: key);

  @override
  State<NewSaleScreen> createState() => _NewSaleScreenState();
}

class _NewSaleScreenState extends State<NewSaleScreen> {
  final TextEditingController _manualEntryController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(text: '1');
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _orderNameController = TextEditingController();
  bool showManualEntry = false;
  Product? selectedProduct;
  String orderName = '';

  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    orderName = _generateRandomOrderName();
    _orderNameController.text = orderName;
    context.read<ProductsCubit>().loadProducts();
  }

  @override
  void dispose() {
    _manualEntryController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _orderNameController.dispose();
    super.dispose();
  }

  String _generateRandomOrderName() {
    final random = Random();
    final adjectives = ['Swift', 'Bright', 'Happy', 'Quick', 'Smart', 'Fresh', 'Golden', 'Silver', 'Royal', 'Prime'];
    final nouns = ['Order', 'Deal', 'Sale', 'Purchase', 'Transaction'];
    final number = random.nextInt(9999) + 1;
    final adjective = adjectives[random.nextInt(adjectives.length)];
    final noun = nouns[random.nextInt(nouns.length)];
    return '$adjective $noun #$number';
  }

  void _showEditOrderNameDialog() {
    final tempController = TextEditingController(text: _orderNameController.text);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Order Name'),
        content: TextField(
          controller: tempController,
          decoration: const InputDecoration(
            hintText: 'Enter order name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                orderName = tempController.text.isEmpty ? _generateRandomOrderName() : tempController.text;
                _orderNameController.text = orderName;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _findProductByBarcode(String searchQuery) {
    final state = context.read<ProductsCubit>().state;
    if (state is ProductsLoaded) {
      // Search by barcode or name
      final product = state.products.firstWhere(
        (p) => (p.barcode != null && p.barcode!.toLowerCase() == searchQuery.toLowerCase()) ||
               p.name.toLowerCase().contains(searchQuery.toLowerCase()),
        orElse: () => Product(id: -1, name: ''),
    );
      
      if (product.id != -1) {
      setState(() {
        selectedProduct = product;
          _priceController.text = product.sellingPrice?.toStringAsFixed(0) ?? '';
        showManualEntry = false;
        _manualEntryController.clear();
      });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product found: ${product.name}'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product "$searchQuery" not found'),
          backgroundColor: AppColors.error,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Products are loading, please wait...'),
          backgroundColor: AppColors.warning,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showProductSelector() {
    final state = context.read<ProductsCubit>().state;
    if (state is! ProductsLoaded || state.products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No products available. Please add products first.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const Text(
                    'Select Product',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return ListTile(
                    leading: product.imageUrl != null && product.imageUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              ApiConfig.getImageUrl(product.imageUrl),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceVariant,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.shopping_bag_outlined),
    );
                              },
                            ),
                          )
                        : Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.shopping_bag_outlined),
                          ),
                    title: Text(product.name),
                    subtitle: Text(
                      'Stock: ${product.stockQuantity} | ${product.sellingPrice?.toStringAsFixed(0) ?? 'N/A'} DZD',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
      setState(() {
        selectedProduct = product;
                        _priceController.text = product.sellingPrice?.toStringAsFixed(0) ?? '';
      });
                      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
                          content: Text('Selected: ${product.name}'),
          backgroundColor: AppColors.success,
                          duration: const Duration(seconds: 1),
        ),
      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        ),
      );
  }

  void _openBarcodeScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _BarcodeScannerScreen(
          onBarcodeDetected: (barcode) {
            _findProductByBarcode(barcode);
          },
        ),
      ),
    );
  }

  void _addToCart() {
    if (selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a product first'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final product = selectedProduct!; // Store reference before clearing
    
    // Parse quantity - default to 1 if empty or invalid
    final quantityText = _quantityController.text.trim();
    int quantity = 1;
    if (quantityText.isNotEmpty) {
      final parsedQty = int.tryParse(quantityText);
      if (parsedQty != null && parsedQty > 0) {
        quantity = parsedQty;
      }
    }
    
    // Parse price - use product's selling price if empty or invalid
    final priceText = _priceController.text.trim();
    double price = product.sellingPrice ?? 0.0;
    if (priceText.isNotEmpty) {
      final parsedPrice = double.tryParse(priceText);
      if (parsedPrice != null && parsedPrice > 0) {
        price = parsedPrice;
      }
    }
    
    // Validate quantity
    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quantity must be greater than 0'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Validate stock availability
    if (quantity > product.stockQuantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Only ${product.stockQuantity} units available'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Validate price
    if (price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Price must be greater than 0'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Add item to cart
      final existingIndex = cartItems.indexWhere(
      (item) => item['id'] == product.id,
      );
    
      if (existingIndex >= 0) {
      // Update existing item - combine quantities
      final existingQuantity = cartItems[existingIndex]['quantity'];
      final existingUnitPrice = cartItems[existingIndex]['unit_price'];
      
      final currentQty = existingQuantity is int 
          ? existingQuantity 
          : (int.tryParse(existingQuantity.toString()) ?? 0);
      final currentPrice = existingUnitPrice is num 
          ? existingUnitPrice.toDouble() 
          : (double.tryParse(existingUnitPrice.toString()) ?? 0.0);
      
      final newQuantity = currentQty + quantity;
      setState(() {
        cartItems[existingIndex]['quantity'] = newQuantity;
        cartItems[existingIndex]['unit_price'] = currentPrice; // Keep original price
        cartItems[existingIndex]['total'] = currentPrice * newQuantity;
        
        // Clear selection for next product
        selectedProduct = null;
        _quantityController.text = '1';
        _priceController.clear();
      });
      } else {
      // Add new item to cart
      setState(() {
        cartItems.add({
          'id': product.id,
          'product_id': product.id,
          'name': product.name,
          'quantity': quantity,
          'unit_price': price,
          'total': price * quantity,
        });

        // Clear selection for next product
      selectedProduct = null;
      _quantityController.text = '1';
      _priceController.clear();
    });
    }

    // Show success message
    final cartLength = cartItems.length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart ($cartLength ${cartLength == 1 ? 'item' : 'items'})'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Add More',
          textColor: AppColors.textOnPrimary,
          onPressed: () {
            // UI is already ready for next product
          },
        ),
      ),
    );
  }

  void _removeFromCart(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  void _confirmSale() {
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cart is empty'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final totalAmount = cartItems.fold<double>(0, (sum, item) => sum + (item['total'] as num).toDouble());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Sale'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order: $orderName'),
            const SizedBox(height: 8),
            Text('Items: ${cartItems.length}'),
            const SizedBox(height: 8),
            Text(
              'Total: ${NumberFormat('#,###').format(totalAmount)} DZD',
              style: const TextStyle(
                              fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processSale();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.textOnPrimary,
            ),
            child: const Text('Confirm Order'),
          ),
        ],
      ),
    );
  }

  void _processSale() {
    // Validate cart items before processing
    for (var item in cartItems) {
      final productId = item['product_id'];
      final quantity = item['quantity'];
      final unitPrice = item['unit_price'];
      
      if (productId == null || (productId is int && productId <= 0) || (productId is! int && int.tryParse(productId.toString()) == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid product in cart'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
      
      if (quantity == null || (quantity is int && quantity <= 0) || (quantity is! int && (int.tryParse(quantity.toString()) ?? 0) <= 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid quantity in cart'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
      
      if (unitPrice == null || (unitPrice is num && unitPrice <= 0) || (unitPrice is! num && (double.tryParse(unitPrice.toString()) ?? 0) <= 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid price in cart'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }

    // Convert cart items to order items format
    final orderItems = cartItems.map((item) {
      final productId = item['product_id'];
      final quantity = item['quantity'];
      final unitPrice = item['unit_price'];
      
      return {
        'product_id': productId is int ? productId : int.parse(productId.toString()),
        'quantity': quantity is int ? quantity : int.parse(quantity.toString()),
        'unit_price': unitPrice is double ? unitPrice : (unitPrice is int ? unitPrice.toDouble() : double.parse(unitPrice.toString())),
      };
    }).toList();

    // Use 'cash' as default payment method for direct purchase
    const paymentMethod = 'cash';

    // Create order using OrdersCubit
    context.read<OrdersCubit>().createOrder(
      paymentMethod: paymentMethod,
      items: orderItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersCubit, OrdersState>(
      listener: (context, state) {
        if (state is OrderCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order "${state.order.orderNumber}" created successfully!'),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 3),
            ),
          );
          setState(() {
            cartItems.clear();
            orderName = _generateRandomOrderName();
            _orderNameController.text = orderName;
            selectedProduct = null;
            _quantityController.text = '1';
            _priceController.clear();
          });
          // Navigate back or to orders screen
          Navigator.pop(context);
        } else if (state is OrdersError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'New Sale',
        showBackButton: true,
        additionalActions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, size: 24),
            color: AppColors.textSecondary,
            onPressed: () {},
                    ),
                  ],
                ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Name Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                  Icon(Icons.receipt_long, color: AppColors.iconPrimary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        const Text(
                        'Order Name',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                      ),
                        GestureDetector(
                          onTap: _showEditOrderNameDialog,
                          child: Text(
                        orderName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.edit, size: 18, color: AppColors.accent),
                  onPressed: _showEditOrderNameDialog,
                ),
              ],
            ),
          ),
            const SizedBox(height: 16),

            // Product Selection Section
          Container(
              padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.successLight, width: 2),
            ),
            child: Column(
              children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.shopping_bag, color: AppColors.accent, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Select Product',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Browse, scan, or search for products',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _showProductSelector,
                          icon: const Icon(Icons.list),
                          label: const Text('Browse Products'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _openBarcodeScanner,
                          icon: const Icon(Icons.qr_code_scanner),
                          label: const Text('Scan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: AppColors.textOnPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                setState(() {
                  showManualEntry = !showManualEntry;
                });
              },
                    icon: Icon(showManualEntry ? Icons.close : Icons.search),
                    label: Text(showManualEntry ? 'Close Search' : 'Search by Name/Barcode'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Manual Entry Section
          if (showManualEntry)
              Container(
              padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Manual Entry',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () {
                            setState(() {
                              showManualEntry = false;
                              _manualEntryController.clear();
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _manualEntryController,
                      decoration: InputDecoration(
                        hintText: 'Enter product name or barcode',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          _findProductByBarcode(value);
                        }
                      },
                  ),
                ],
              ),
            ),

            // Selected Product Info
            if (selectedProduct != null) ...[
              const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.successLight, width: 2),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                          child: Icon(Icons.inventory_2, color: AppColors.accent, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                selectedProduct!.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                                'Stock: ${selectedProduct!.stockQuantity}',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Quantity',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                        ),
                              TextField(
                            controller: _quantityController,
                            keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '1',
                                  prefixIcon: const Icon(Icons.shopping_cart_outlined, size: 20),
                                  fillColor: AppColors.inputFill,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                              const Text(
                                'Price',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '0',
                                  prefixIcon: const Icon(Icons.payments_outlined, size: 20),
                                  fillColor: AppColors.inputFill,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                      ],
                    ),
                  const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                    onPressed: _addToCart,
                    style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.textOnPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                        child: const Text('Add to Cart'),
                    ),
                  ),
                ],
              ),
            ),
            ],

            // Cart Section
          if (cartItems.isNotEmpty) ...[
              const SizedBox(height: 24),
                  Container(
                padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                  color: AppColors.accentLight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                    ),
                child: Row(
                  children: [
                    Icon(Icons.shopping_cart, color: AppColors.accent, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${cartItems.length} ${cartItems.length == 1 ? 'item' : 'items'} in cart',
                            style: const TextStyle(
                              fontSize: 16,
                        fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                      ),
                          const SizedBox(height: 4),
                          Text(
                            'You can add more products before confirming',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          selectedProduct = null;
                          _quantityController.text = '1';
                          _priceController.clear();
                        });
                        // Scroll to top to show product selection
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add More'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.accent,
                        side: const BorderSide(color: AppColors.accent),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Cart Items',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...cartItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                  return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                              item['name'] as String,
                                style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                              'Qty: ${item['quantity']} × ${NumberFormat('#,###').format(item['unit_price'])} DZD',
                                style: TextStyle(
                                fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${NumberFormat('#,###').format(item['total'])} DZD',
                          style: const TextStyle(
                          fontSize: 16,
                            fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                          ),
                        ),
                        IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.error),
                          onPressed: () => _removeFromCart(index),
                        ),
                      ],
                    ),
                  );
              }),
              const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                  color: AppColors.accentLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                      'Total',
                          style: TextStyle(
                            fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                      '${NumberFormat('#,###').format(cartItems.fold<double>(0, (sum, item) => sum + (item['total'] as num).toDouble()))} DZD',
                          style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmSale,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.textOnPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Confirm Sale',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
              ],
            ),
          ),
      ),
    );
  }
}

class _BarcodeScannerScreen extends StatefulWidget {
  final Function(String) onBarcodeDetected;

  const _BarcodeScannerScreen({required this.onBarcodeDetected});

  @override
  State<_BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<_BarcodeScannerScreen> {
  bool _isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Scan Barcode', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (!_isScanned) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                  setState(() {
                    _isScanned = true;
                  });
                  final String code = barcodes.first.rawValue!;
                  widget.onBarcodeDetected(code);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Barcode detected: $code'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (mounted) Navigator.pop(context);
                  });
                }
              }
            },
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.accent, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
