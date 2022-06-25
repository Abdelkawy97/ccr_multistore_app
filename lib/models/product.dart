class Product {
  final String title;
  final double price;
  int quantity = 1;
  final int inStock;
  final String imageUrl;
  final String documentId;
  final String vid;
  Product({
    required this.title,
    required this.price,
    required this.quantity,
    required this.inStock,
    required this.imageUrl,
    required this.documentId,
    required this.vid,
  });

  void incrementQuantity() {
    quantity++;
  }

  void decrementQuantity() {
    quantity--;
  }
}
