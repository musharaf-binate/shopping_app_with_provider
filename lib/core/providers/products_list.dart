import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/core/models/products_model.dart';

class ProductList extends ChangeNotifier {
  bool _isDateLoading = true;
  bool get isDateLoading => _isDateLoading;

  set isDateLoading(value) {
    _isDateLoading = value;
    notifyListeners();
  }

  ProductList() {
    fetchProducts();
  }

  List<ProductModel> products = [];

  Dio dio = Dio();
  void fetchProducts() async {
    isDateLoading = true;
    dio.get("https://fakestoreapi.com/products").then((value) {
      debugPrint("response: ${value.data}");
      products = productModelFromJson(value.data);
      isDateLoading = false;
    }).onError((error, stackTrace) {
      debugPrint("Failed: $error");
      debugPrint("Failed: $stackTrace");
    });
  }
}
