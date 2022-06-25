import 'package:ccr_multistore_app/models/product.dart';
import 'package:flutter/foundation.dart';

class Favorite extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getFavoriteItems {
    return _list;
  }

  int? get count {
    return _list.length;
  }

  void addFavorite({
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

  void removeFavorite(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearFavorites() {
    _list.clear();
    notifyListeners();
  }
}
