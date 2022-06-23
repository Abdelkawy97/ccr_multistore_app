import 'package:ccr_multistore_app/screens/product_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubCategoryProductsScreen extends StatefulWidget {
  final String subCategoryName;
  const SubCategoryProductsScreen({
    Key? key,
    required this.subCategoryName,
  }) : super(key: key);

  @override
  State<SubCategoryProductsScreen> createState() =>
      _SubCategoryProductsScreenState();
}

class _SubCategoryProductsScreenState extends State<SubCategoryProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('subCategory', isEqualTo: widget.subCategoryName)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subCategoryName),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                    productId: snapshot.data!.docs[i]
                                        ['productId'],
                                    subCategoryName: widget.subCategoryName,
                                    productTitle: snapshot.data!.docs[i]
                                        ['productTitle'],
                                    productDescription: snapshot.data!.docs[i]
                                        ['productDescription'],
                                    productPrice: snapshot.data!.docs[i]
                                        ['price'],
                                    productQuantity: snapshot.data!.docs[i]
                                        ['inStock'],
                                    productImageUrl: snapshot.data!.docs[i]
                                        ['productImageUrl'],
                                  )),
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
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                snapshot.data!.docs[i]['productTitle'],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
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
    );
  }
}
