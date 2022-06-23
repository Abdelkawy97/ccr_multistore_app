// Package imports
import 'package:ccr_multistore_app/helpers/categories.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Screen imports
import 'package:ccr_multistore_app/screens/product_details.dart';
import 'package:ccr_multistore_app/screens/search.dart';
import 'package:ccr_multistore_app/screens/settings.dart';

class ProductsHomeScreen extends StatefulWidget {
  const ProductsHomeScreen({Key? key}) : super(key: key);

  @override
  State<ProductsHomeScreen> createState() => _ProductsHomeScreenState();
}

class _ProductsHomeScreenState extends State<ProductsHomeScreen> {
  final Stream<QuerySnapshot> _productsStream =
      FirebaseFirestore.instance.collection('products').snapshots();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Settings"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                  // currentTheme.toggleTheme();
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text("Home"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _productsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.5,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, i) {
                  return Material(
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.teal.withOpacity(0.2), width: 3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                mainCategoryName: snapshot.data!.docs[i]
                                    ['mainCategory'],
                                productId: snapshot.data!.docs[i]['productId'],
                                subCategoryName: snapshot.data!.docs[i]
                                    ['subCategory'],
                                productTitle: snapshot.data!.docs[i]
                                    ['productTitle'],
                                productDescription: snapshot.data!.docs[i]
                                    ['productDescription'],
                                productPrice: snapshot.data!.docs[i]['price'],
                                productQuantity: snapshot.data!.docs[i]
                                    ['inStock'],
                                productImageUrl: snapshot.data!.docs[i]
                                    ['productImageUrl'],
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Ink(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.favorite_border),
                                    color: Colors.purple,
                                  )
                                ],
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Image.network(
                                    snapshot.data!.docs[i]['productImageUrl'],
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  snapshot.data!.docs[i]['productTitle'],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  "EGP ${snapshot.data!.docs[i]['price'].toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
