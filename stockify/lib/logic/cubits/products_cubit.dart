import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/product.dart';
import '../../data/repositories/products_repository.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepository _repository;

  ProductsCubit(this._repository) : super(ProductsInitial());

  Future<void> loadProducts({double? minPrice, double? maxPrice}) async {
    emit(ProductsLoading());
    
    final result = await _repository.getProducts(
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
    
    if (result['success'] == true) {
      emit(ProductsLoaded(
        products: result['products'] as List<Product>,
        count: result['count'] as int,
      ));
    } else {
      emit(ProductsError(message: result['message'] as String));
    }
  }

  Future<void> addProduct({
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
    emit(ProductsLoading());
    
    final result = await _repository.addProduct(
      name: name,
      sku: sku,
      barcode: barcode,
      description: description,
      costPrice: costPrice,
      sellingPrice: sellingPrice,
      stockQuantity: stockQuantity,
      lowStockThreshold: lowStockThreshold,
      expiryDate: expiryDate,
      imageFile: imageFile,
    );
    
    if (result['success'] == true) {
      // If product object exists, emit success with it and keep it in state
      if (result['product'] != null && result['product'] is Product) {
        final product = result['product'] as Product;
        emit(ProductAdded(product: product));
        // Reload products list to update the list
        await loadProducts();
      } else {
        // Product was added but parsing failed - reload products list
        await loadProducts();
      }
    } else {
      emit(ProductsError(message: result['message'] as String));
    }
  }

  Future<void> loadProduct(int productId) async {
    emit(ProductsLoading());
    
    final result = await _repository.getProductById(productId);
    
    if (result['success'] == true) {
      emit(ProductLoaded(product: result['product'] as Product));
    } else {
      emit(ProductsError(message: result['message'] as String));
    }
  }

  Future<void> updateProduct({
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
    emit(ProductsLoading());
    
    final result = await _repository.updateProduct(
      productId: productId,
      name: name,
      sku: sku,
      barcode: barcode,
      description: description,
      costPrice: costPrice,
      sellingPrice: sellingPrice,
      stockQuantity: stockQuantity,
      lowStockThreshold: lowStockThreshold,
      expiryDate: expiryDate,
      imageFile: imageFile,
    );
    
    if (result['success'] == true) {
      // Product updated successfully - reload products list
      await loadProducts();
      
      // If product object exists, emit success with it
      if (result['product'] != null && result['product'] is Product) {
        emit(ProductUpdated(product: result['product'] as Product));
      }
    } else {
      emit(ProductsError(message: result['message'] as String));
    }
  }

  Future<void> deleteProduct(int productId) async {
    emit(ProductsLoading());
    
    final result = await _repository.deleteProduct(productId);
    
    if (result['success'] == true) {
      // Product deleted successfully - reload products list
      await loadProducts();
      emit(ProductDeleted(productId: productId));
    } else {
      emit(ProductsError(message: result['message'] as String));
    }
  }
}

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final int count;

  ProductsLoaded({required this.products, required this.count});
}

class ProductAdded extends ProductsState {
  final Product product;

  ProductAdded({required this.product});
}

class ProductLoaded extends ProductsState {
  final Product product;

  ProductLoaded({required this.product});
}

class ProductUpdated extends ProductsState {
  final Product product;

  ProductUpdated({required this.product});
}

class ProductDeleted extends ProductsState {
  final int productId;

  ProductDeleted({required this.productId});
}

class ProductsError extends ProductsState {
  final String message;

  ProductsError({required this.message});
}

