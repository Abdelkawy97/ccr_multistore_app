import 'package:ccr_multistore_app/models/cart.dart';
import 'package:ccr_multistore_app/models/favorite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        centerTitle: true,
        actions: [
          context.watch<Cart>().getItems.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          "Warning",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        ),
                        content: const Text(
                            "Are you sure you want to clear your favorites?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              context.read<Favorite>().clearFavorites();
                              Navigator.pop(context);
                            },
                            child: const Text("Yes"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("No"),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_forever),
                )
              : Container(width: 0),
        ],
      ),
      body: context.watch<Cart>().getItems.isNotEmpty
          ? const FavoriteItem()
          : const EmptyFavorites(),
    );
  }
}

class EmptyFavorites extends StatelessWidget {
  const EmptyFavorites({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "You have no favorites yet!",
            style: TextStyle(fontSize: 27),
          ),
          Text(
            "Visit the shop to add some items.",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class FavoriteItem extends StatelessWidget {
  const FavoriteItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Favorite>(builder: (context, favorite, child) {
      return ListView.builder(
          itemCount: favorite.count,
          itemBuilder: (context, i) {
            final product = favorite.getFavoriteItems[i];
            return SingleChildScrollView(
              child: Card(
                child: SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 120,
                        child: Image.network(
                          product.imageUrl,
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(product.title),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "EGP ${product.price.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    product.quantity.toString(),
                                    style: product.quantity == product.inStock
                                        ? const TextStyle(color: Colors.red)
                                        : const TextStyle(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    });
  }
}
