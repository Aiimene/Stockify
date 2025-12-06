import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:io';
import '../../presentation/themes/app_colors.dart';
import '../../presentation/widgets/custom_app_bar.dart';
import '../../logic/cubits/products_cubit.dart';
import '../../data/models/product.dart';
import '../../config/api_config.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product? product;
  final int? productId;

  const ProductDetailScreen({super.key, this.product, this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _lowStockThresholdController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  bool _isEditing = false;
  Product? _product;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _product = widget.product;
    _loadProductData();
      _isLoading = false;
    } else if (widget.productId != null) {
      _loadProductFromApi();
    } else {
      _isLoading = false;
    }
  }

  void _loadProductFromApi() {
    context.read<ProductsCubit>().loadProduct(widget.productId!);
  }

  void _loadProductData() {
    if (_product == null) return;
    
    _nameController.text = _product!.name;
    _descriptionController.text = _product!.description ?? '';
    _sellingPriceController.text = _product!.sellingPrice?.toStringAsFixed(0) ?? '';
    _costPriceController.text = _product!.costPrice?.toStringAsFixed(0) ?? '';
    _stockController.text = _product!.stockQuantity.toString();
    _lowStockThresholdController.text = _product!.lowStockThreshold.toString();
    _skuController.text = _product!.sku ?? '';
    _barcodeController.text = _product!.barcode ?? '';
    if (_product!.expiryDate != null) {
      _expiryDateController.text = _product!.expiryDate!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _sellingPriceController.dispose();
    _costPriceController.dispose();
    _stockController.dispose();
    _lowStockThresholdController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  Future<void> _selectExpiryDate() async {
    if (!_isEditing) return;
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _expiryDateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _showImageSourceDialog() {
    if (!_isEditing) return;
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Update Product Image',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.camera_alt, color: AppColors.primary),
              ),
              title: const Text('Take Photo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: const Text('Use camera to take a photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.photo_library, color: AppColors.accent),
              ),
              title: const Text('Choose from Gallery', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: const Text('Select from your photos'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _scanBarcode() async {
    if (!_isEditing) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _BarcodeScannerScreen(
          onBarcodeDetected: (String barcode) {
            setState(() {
              _barcodeController.text = barcode;
            });
          },
        ),
      ),
    );
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _selectedImage = null;
        _loadProductData(); // Reset to original values
      }
    });
  }

  void _updateProduct() {
    if (_formKey.currentState!.validate() && _product != null) {
      final sellingPrice = double.tryParse(_sellingPriceController.text.trim());
      final costPrice = double.tryParse(_costPriceController.text.trim());
      final stock = int.tryParse(_stockController.text.trim());
      final lowStockThreshold = int.tryParse(_lowStockThresholdController.text.trim());

      if (sellingPrice == null || sellingPrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid selling price'),
            backgroundColor: AppColors.error,
        ),
      );
        return;
      }

      context.read<ProductsCubit>().updateProduct(
        productId: _product!.id,
        name: _nameController.text.trim(),
        sku: _skuController.text.trim().isEmpty ? null : _skuController.text.trim(),
        barcode: _barcodeController.text.trim().isEmpty ? null : _barcodeController.text.trim(),
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        costPrice: costPrice,
        sellingPrice: sellingPrice,
        stockQuantity: stock,
        lowStockThreshold: lowStockThreshold,
        expiryDate: _expiryDateController.text.trim().isEmpty ? null : _expiryDateController.text.trim(),
        imageFile: _selectedImage != null ? File(_selectedImage!.path) : null,
      );
    }
  }

  void _deleteProduct() {
    if (_product == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${_product!.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProductsCubit>().deleteProduct(_product!.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textOnPrimary,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsCubit, ProductsState>(
      listener: (context, state) {
        if (state is ProductLoaded) {
          setState(() {
            _product = state.product;
            _loadProductData();
            _isLoading = false;
          });
        } else if (state is ProductUpdated) {
          setState(() {
            _product = state.product;
            _loadProductData();
            _isEditing = false;
            _selectedImage = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product updated successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (state is ProductDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product deleted successfully'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context); // Go back to product list
        } else if (state is ProductsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Product Details',
        showBackButton: true,
          additionalActions: !_isEditing && _product != null ? [
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 24),
            color: AppColors.primary,
            onPressed: _toggleEditMode,
            tooltip: 'Edit Product',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, size: 24),
            color: AppColors.error,
            onPressed: _deleteProduct,
            tooltip: 'Delete Product',
          ),
        ] : null,
      ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _product == null
                ? const Center(child: Text('Product not found'))
                : Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isEditing)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      ),
                                child: const Row(
                      children: [
                                    Icon(Icons.edit, color: AppColors.primary, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                          'Editing Mode',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                            _buildImageSection(),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Product Name',
                  icon: Icons.inventory_2_outlined,
                  controller: _nameController,
                              hint: 'Product name',
                  isRequired: true,
                  readOnly: !_isEditing,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Description',
                  icon: Icons.description_outlined,
                  controller: _descriptionController,
                              hint: 'Product description',
                  maxLines: 3,
                  readOnly: !_isEditing,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Selling Price',
                  icon: Icons.attach_money,
                  controller: _sellingPriceController,
                              hint: '0',
                  keyboardType: TextInputType.number,
                  isRequired: true,
                  readOnly: !_isEditing,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter selling price';
                    }
                                if (double.tryParse(value) == null || double.parse(value) <= 0) {
                                  return 'Please enter a valid price';
                                }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                              label: 'Cost Price (Optional)',
                  icon: Icons.local_offer_outlined,
                              controller: _costPriceController,
                              hint: '0',
                  keyboardType: TextInputType.number,
                  readOnly: !_isEditing,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Current Stock',
                  icon: Icons.warehouse_outlined,
                  controller: _stockController,
                              hint: '0',
                  keyboardType: TextInputType.number,
                  isRequired: true,
                  readOnly: !_isEditing,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter stock quantity';
                    }
                                if (int.tryParse(value) == null || int.parse(value) < 0) {
                                  return 'Please enter a valid stock quantity';
                                }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                              label: 'Low Stock Threshold',
                              icon: Icons.notification_important_outlined,
                              controller: _lowStockThresholdController,
                              hint: '5',
                              keyboardType: TextInputType.number,
                              readOnly: !_isEditing,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              label: 'SKU (Optional)',
                  icon: Icons.tag_outlined,
                  controller: _skuController,
                              hint: 'SKU',
                  readOnly: !_isEditing,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                              label: 'Barcode (Optional)',
                  icon: Icons.qr_code_2_outlined,
                  controller: _barcodeController,
                              hint: 'Barcode',
                  readOnly: !_isEditing,
                  suffixIcon: _isEditing
                      ? IconButton(
                                      icon: const Icon(Icons.qr_code_scanner, color: AppColors.accent),
                          onPressed: _scanBarcode,
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Expiry Date (Optional)',
                  icon: Icons.event_outlined,
                  controller: _expiryDateController,
                              hint: 'YYYY-MM-DD',
                  readOnly: true,
                  onTap: _selectExpiryDate,
                  suffixIcon: _isEditing
                                  ? const Icon(Icons.calendar_today, size: 20, color: AppColors.textSecondary)
                      : null,
                ),
                const SizedBox(height: 32),
                if (_isEditing)
                  Column(
                    children: [
                                  BlocBuilder<ProductsCubit, ProductsState>(
                                    builder: (context, state) {
                                      final isLoading = state is ProductsLoading;
                                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                                          onPressed: isLoading ? null : _updateProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                                          child: isLoading
                                              ? const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
                                                  ),
                                                )
                                              : const Text(
                            'Update Product',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textOnPrimary,
                            ),
                          ),
                        ),
                                      );
                                    },
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: _toggleEditMode,
                          style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: AppColors.textSecondary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                                          color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
                        ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withOpacity(0.05),
            AppColors.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          if (_product!.imageUrl != null && _product!.imageUrl!.isNotEmpty && _selectedImage == null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                ApiConfig.getImageUrl(_product!.imageUrl),
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, size: 100, color: AppColors.textTertiary);
                },
              ),
            )
          else if (_selectedImage != null)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_selectedImage!.path),
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: -5,
                  right: -5,
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 16, color: AppColors.textOnPrimary),
                    ),
                    onPressed: _removeImage,
                  ),
                ),
              ],
            )
          else
            const Icon(Icons.image_not_supported, size: 100, color: AppColors.textTertiary),
          if (_isEditing) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _showImageSourceDialog,
              icon: const Icon(Icons.image),
              label: const Text('Change Image'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.textOnPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    IconData? icon,
    required TextEditingController controller,
    required String hint,
    bool isRequired = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 8),
            ],
            RichText(
              text: TextSpan(
                text: label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                children: [
                  if (isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: AppColors.error),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          readOnly: readOnly,
          onTap: onTap,
          style: TextStyle(
            color: readOnly ? AppColors.textSecondary : AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 14),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: readOnly ? AppColors.surfaceVariant : AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
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
                      duration: const Duration(seconds: 1),
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
