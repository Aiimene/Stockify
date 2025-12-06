import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:io';
import '../../presentation/themes/app_colors.dart';
import '../../presentation/widgets/custom_app_bar.dart';
import '../../logic/cubits/products_cubit.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
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
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _lowStockThresholdController.text = '5';
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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _expiryDateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _showImageSourceDialog() {
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
              'Add Product Image',
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
                  color: AppColors.primaryLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: AppColors.primary,
                ),
              ),
              title: const Text('Take Photo'),
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
                  color: AppColors.accentLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.photo_library,
                  color: AppColors.accent,
                ),
              ),
              title: const Text('Choose from Gallery'),
              subtitle: const Text('Select from your photos'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 10),
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
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: AppColors.error,
          ),
      );
      }
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _scanBarcode() async {
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

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();
      final sellingPrice = double.tryParse(_sellingPriceController.text.trim());
      final costPrice = double.tryParse(_costPriceController.text.trim());
      final stock = int.tryParse(_stockController.text.trim()) ?? 0;
      final lowStockThreshold = int.tryParse(_lowStockThresholdController.text.trim()) ?? 5;
      final sku = _skuController.text.trim();
      final barcode = _barcodeController.text.trim();
      final expiryDate = _expiryDateController.text.trim();

      if (sellingPrice == null || sellingPrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid selling price'),
            backgroundColor: AppColors.error,
        ),
      );
        return;
      }

      context.read<ProductsCubit>().addProduct(
        name: name,
        sku: sku.isEmpty ? null : sku,
        barcode: barcode.isEmpty ? null : barcode,
        description: description.isEmpty ? null : description,
        costPrice: costPrice,
        sellingPrice: sellingPrice,
        stockQuantity: stock,
        lowStockThreshold: lowStockThreshold,
        expiryDate: expiryDate.isEmpty ? null : expiryDate,
        imageFile: _selectedImage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsCubit, ProductsState>(
      listener: (context, state) {
        if (state is ProductAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product "${state.product.name}" added successfully!'),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.pop(context);
        } else if (state is ProductsLoaded && state.products.isNotEmpty) {
          // Product was added successfully but parsing failed - still show success
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product added successfully!'),
              backgroundColor: AppColors.success,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pop(context);
        } else if (state is ProductsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Add Product',
        showBackButton: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  // Product Image Section
                _buildImageUploadArea(),
                const SizedBox(height: 16),
                  if (_selectedImage != null) _buildImagePreview(),
                  if (_selectedImage != null) const SizedBox(height: 24),

                // Product Name
                _buildTextField(
                  label: 'Product Name',
                  icon: Icons.inventory_2_outlined,
                  controller: _nameController,
                    hint: 'Enter product name',
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description
                _buildTextField(
                  label: 'Description',
                  icon: Icons.description_outlined,
                  controller: _descriptionController,
                    hint: 'Enter product description',
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Selling Price
                _buildTextField(
                    label: 'Selling Price (DZD)',
                  icon: Icons.attach_money,
                  controller: _sellingPriceController,
                    hint: '1500',
                  keyboardType: TextInputType.number,
                  isRequired: true,
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

                  // Cost Price
                _buildTextField(
                    label: 'Cost Price (DZD)',
                  icon: Icons.local_offer_outlined,
                    controller: _costPriceController,
                    hint: '850',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // Initial Stock
                _buildTextField(
                  label: 'Initial Stock',
                  icon: Icons.warehouse_outlined,
                  controller: _stockController,
                  hint: '50',
                  keyboardType: TextInputType.number,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter initial stock';
                    }
                      if (int.tryParse(value) == null || int.parse(value) < 0) {
                        return 'Please enter a valid stock quantity';
                      }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                  // Low Stock Threshold
                  _buildTextField(
                    label: 'Low Stock Threshold',
                    icon: Icons.warning_outlined,
                    controller: _lowStockThresholdController,
                    hint: '5',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                // SKU
                _buildTextField(
                  label: 'SKU',
                  icon: Icons.tag_outlined,
                  controller: _skuController,
                  hint: 'HFC-001',
                ),
                const SizedBox(height: 16),

                // Barcode
                _buildTextField(
                  label: 'Barcode',
                  icon: Icons.qr_code_2_outlined,
                  controller: _barcodeController,
                  hint: 'Enter barcode',
                  suffixIcon: IconButton(
                      icon: const Icon(Icons.qr_code_scanner, color: AppColors.accent),
                    onPressed: _scanBarcode,
                  ),
                ),
                const SizedBox(height: 16),

                // Expiry Date
                _buildTextField(
                  label: 'Expiry Date (Optional)',
                  icon: Icons.event_outlined,
                  controller: _expiryDateController,
                    hint: 'YYYY-MM-DD',
                  readOnly: true,
                  onTap: _selectExpiryDate,
                    suffixIcon: const Icon(Icons.calendar_today, size: 20, color: AppColors.textTertiary),
                ),
                const SizedBox(height: 32),

                // Save Product Button
                  BlocBuilder<ProductsCubit, ProductsState>(
                    builder: (context, state) {
                      final isLoading = state is ProductsLoading;
                      return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                          onPressed: isLoading ? null : _saveProduct,
                    style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: AppColors.textOnPrimary,
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.textOnPrimary,
                                    ),
                                  ),
                                )
                              : const Text(
                      'Save Product',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                                  ),
                      ),
                    ),
                      );
                    },
                ),
                const SizedBox(height: 24),
              ],
              ),
            ),
          ),
        ),
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
              Icon(icon, size: 18, color: AppColors.iconPrimary),
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
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textTertiary,
              fontSize: 14,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.inputFill,
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploadArea() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accentLight.withOpacity(0.05),
            AppColors.primaryLight.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.accentLight.withOpacity(0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: _showImageSourceDialog,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.image_outlined, size: 20, color: AppColors.iconPrimary),
                const SizedBox(width: 8),
                const Text(
                  'Product Image',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.accentLight.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_upload_outlined,
                color: AppColors.accent,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Add Product Photo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.camera_alt, size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        'Take Photo',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.iconPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.photo_library, size: 16, color: AppColors.accent),
                      const SizedBox(width: 6),
                      Text(
                        'Gallery',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.iconPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Supports: JPG, PNG, WEBP (Max 5MB)',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_selectedImage == null) return const SizedBox.shrink();

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              _selectedImage!,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 20,
                color: AppColors.textOnPrimary,
              ),
            ),
            onPressed: _removeImage,
          ),
        ),
      ],
    );
  }
}

// Barcode Scanner Screen
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
        title: const Text(
          'Scan Barcode',
          style: TextStyle(color: Colors.white),
        ),
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
                    if (mounted) {
                      Navigator.pop(context);
                    }
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
                border: Border.all(
                  color: AppColors.accent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Position the barcode within the frame',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textOnPrimary,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
