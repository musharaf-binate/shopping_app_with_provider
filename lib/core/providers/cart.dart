import 'package:flutter/material.dart';
import 'package:shopping_app/core/models/products_model.dart';

class Cart extends ChangeNotifier {
  List<ProductModel> _cartItems = [];

  List<ProductModel> get items => _cartItems;

  int get cartLength => _cartItems.length;

  double get totalPrice => _cartItems.fold(
      0, (total, accumulate) => total + accumulate.price * accumulate.quantity);

  int getItemQuantity(ProductModel item) {
    int index = _cartItems.indexOf(item);
    return index != -1 ? _cartItems[index].quantity : 0;
  }

  void addItemToCart(ProductModel item) {
    if (_cartItems.contains(item)) {
      _cartItems = _cartItems.map((cartItem) {
        if (cartItem.id == item.id) {
          cartItem.quantity = cartItem.quantity + 1;
          return cartItem;
        } else {
          return cartItem;
        }
      }).toList();
    } else {
      debugPrint("Adding new Item");
      item.quantity = 1;
      _cartItems.add(item);
    }
    notifyListeners();
  }

  void removeItemFromCart(int id) {
    bool isQuantityZero = false;

    _cartItems = _cartItems.map((cartItem) {
      if (cartItem.id == id) {
        cartItem.quantity = cartItem.quantity - 1;
        if (cartItem.quantity == 0) {
          isQuantityZero = true;
        }
        return cartItem;
      } else {
        return cartItem;
      }
    }).toList();
    if (isQuantityZero) {
      _cartItems.removeWhere((element) => element.id == id);
    }
    notifyListeners();
  }

  void removeAllItemsFromCart() {
    _cartItems = _cartItems.map((cartItem) {
      cartItem.quantity = 0;
      return cartItem;
    }).toList();
    _cartItems.clear();
    notifyListeners();
  }
}
