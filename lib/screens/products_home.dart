import 'package:ccr_multistore_app/screens/cart.dart';
import 'package:flutter/material.dart';

class ProductsHomeScreen extends StatelessWidget {
  const ProductsHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}
