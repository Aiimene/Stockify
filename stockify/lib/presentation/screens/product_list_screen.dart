import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/themes/app_colors.dart';
import '../../presentation/widgets/custom_app_bar.dart';
import '../../logic/cubits/products_cubit.dart';
import '../../data/models/product.dart';
import '../../config/api_config.dart';

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
  
  @override
  void initState() {
    super.initState();
    context.read<ProductsCubit>().loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  List<Product> _filterProducts(List<Product> products) {
    if (_searchQuery.isEmpty && _minPrice == null && _maxPrice == null) {
      return products;
    }

    return products.where((product) {
      // Search filter
    if (_searchQuery.isNotEmpty) {
        final nameMatch = product.name.toLowerCase().contains(_searchQuery.toLowerCase());
        final skuMatch = product.sku?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false;
        final barcodeMatch = product.barcode?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false;
        if (!nameMatch && !skuMatch && !barcodeMatch) return false;
      }

      // Price filter
      if (product.sellingPrice != null) {
        if (_minPrice != null && product.sellingPrice! < _minPrice!) return false;
        if (_maxPrice != null && product.sellingPrice! > _maxPrice!) return false;
        }

        return true;
      }).toList();
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
              context.read<ProductsCubit>().loadProducts();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
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
              context.read<ProductsCubit>().loadProducts(
                minPrice: _minPrice,
                maxPrice: _maxPrice,
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
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
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Products',
        showBackButton: false,
      ),
      body: Column(
        children: [
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
                      prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.inputBorder),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list, color: AppColors.iconPrimary),
                    onPressed: _showFilterDialog,
                  ),
                ),
              ],
            ),
          ),
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
                      context.read<ProductsCubit>().loadProducts();
                    },
                    backgroundColor: AppColors.primaryLight.withOpacity(0.1),
                    labelStyle: const TextStyle(color: AppColors.primary, fontSize: 12),
                  ),
                ],
              ),
            ),
          Expanded(
            child: BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                if (state is ProductsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ProductsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: AppColors.error),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: const TextStyle(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<ProductsCubit>().loadProducts(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ProductsLoaded) {
                  final filteredProducts = _filterProducts(state.products);

                  if (filteredProducts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: AppColors.textTertiary),
                          const SizedBox(height: 16),
                          const Text(
                            'No products found',
                            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
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
                  );
                }

                return const Center(child: Text('No products'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-product'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.textOnPrimary),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    Color stockColor;
    if (product.stockQuantity > 50) {
      stockColor = AppColors.success;
    } else if (product.stockQuantity > 20) {
      stockColor = AppColors.warning;
    } else {
      stockColor = AppColors.error;
    }

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/product-detail',
          arguments: product,
        );
      },
      child: Container(
      decoration: BoxDecoration(
          color: AppColors.surface,
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
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.productImagePlaceholder,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                    child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.network(
                              ApiConfig.getImageUrl(product.imageUrl),
                              fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.shopping_bag_outlined,
                          size: 60,
                          color: AppColors.textTertiary,
                        );
                      },
                            ),
                          )
                        : Icon(
                            Icons.shopping_bag_outlined,
                            size: 60,
                            color: AppColors.textTertiary,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        product.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                        product.sellingPrice != null
                            ? '${product.sellingPrice!.toStringAsFixed(0)} DZD'
                            : 'N/A',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: stockColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                          'Stock: ${product.stockQuantity}',
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
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/product-detail',
                    arguments: product,
                  );
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: AppColors.surface,
                  borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                ),
                  child: const Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: AppColors.iconPrimary,
                ),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}
