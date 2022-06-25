import 'package:ccr_multistore_app/models/product.dart';
import 'package:flutter/foundation.dart';

class Cart extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getItems {
    return _list;
  }

  int? get count {
    return _list.length;
  }

  void addItem({
    required String title,
    required double price,
    required int quantity,
    required int inStock,
    required String imageUrl,
    required String documentId,
    required String vid,
  }) {
    final product = Product(
      title: title,
      price: price,
      quantity: quantity,
      inStock: inStock,
      imageUrl: imageUrl,
      documentId: documentId,
      vid: vid,
    );
    _list.add(product);
    notifyListeners();
  }

  void increment(Product product) {
    product.incrementQuantity();
    notifyListeners();
  }

  void decrement(Product product) {
    product.decrementQuantity();
    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _list.clear();
    notifyListeners();
  }

  double get totalPrice {
    double total = 0.0;
    for (var item in _list) {
      total += item.price * item.quantity;
    }
    return total;
  }
}
