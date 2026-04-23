import 'package:flutter/material.dart';
import '../../../dashboard/domain/repositories/product_repository.dart';
import '../../data/models/product_model.dart';
import '../../../dashboard/domain/repositories/product_repository_impl.dart';

enum ProductStatus { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository = ProductRepositoryImpl();

  ProductStatus _status = ProductStatus.initial;
  List<ProductModel> _products = [];
  String? _error;

  ProductStatus get status => _status;
  List<ProductModel> get products => _products;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _status = ProductStatus.loading;
    notifyListeners();

    try {
      _products = await _repository.getProducts();
      _status = ProductStatus.loaded;
    } catch (e) {
      _error = e.toString();
      _status = ProductStatus.error;
    }

    notifyListeners();
  }
}