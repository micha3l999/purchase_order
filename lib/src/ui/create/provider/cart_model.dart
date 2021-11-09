import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:purchase_order/src/models/product_selected.dart';
import 'package:purchase_order/src/ui/client/models/client.dart';

class CartModel extends ChangeNotifier {
  // Internal, private state of the cart
  final List<ProductSelected> _products = [];
  double _totalPrice = 0;
  Client? _client;

  // An unmodified view of the items in the cart
  UnmodifiableListView<ProductSelected> get products =>
      UnmodifiableListView(_products);

  // Get total price of the order
  double get totalPrice => _totalPrice;

  // Get the client code
  Client? get client => _client;

  bool add(ProductSelected product, String selectedPrice) {
    // check if the product exists in the current list
    bool isAdded = false;
    for (var e in _products) {
      if (e.code == product.code) {
        isAdded = true;
        return true;
      }
    }

    // add the product to the cart list
    _products.add(product);
    _totalPrice += double.parse(selectedPrice);
    // this calls tells the widgets that are listening to this model to rebuild
    notifyListeners();
    return false;
  }

  void removeAll() {
    _products.clear();
    _totalPrice = 0;

    notifyListeners();
  }

  void clearClient() {
    _client = null;
    notifyListeners();
  }

  void removeItem(String productCode, double productPrice) {
    _products.removeWhere((product) => product.code == productCode);
    _totalPrice = _totalPrice - productPrice;
    notifyListeners();
  }

  set client(Client? newClient) {
    _client = newClient;
  }
}
