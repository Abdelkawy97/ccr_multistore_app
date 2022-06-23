import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;
  final String mainCategoryName;
  final String subCategoryName;
  final String productTitle;
  final String productDescription;
  final String productImageUrl;
  final double productPrice;
  final int productQuantity;

  const ProductDetailsScreen({
    Key? key,
    required this.mainCategoryName,
    required this.subCategoryName,
    required this.productTitle,
    required this.productDescription,
    required this.productPrice,
    required this.productQuantity,
    required this.productImageUrl,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('subCategory', isEqualTo: subCategoryName)
        .where('productId', isNotEqualTo: productId)
        .snapshots();

    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(productTitle),
            centerTitle: true,
          ),
          bottomSheet: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.store),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: Image.network(productImageUrl),
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "EGP ${productPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border),
                      color: Colors.purple,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Items left in stock: ${productQuantity.toString()}"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    SizedBox(
                      width: 40,
                      height: 60,
                      child: Divider(),
                    ),
                    Text(
                      "Product Description",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      width: 40,
                      height: 60,
                      child: Divider(),
                    ),
                  ],
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(productDescription),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    SizedBox(
                      width: 40,
                      height: 60,
                      child: Divider(),
                    ),
                    Text(
                      "Recommended Products",
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(
                      width: 40,
                      height: 60,
                      child: Divider(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 440,
                  child: Card(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: productsStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Something went wrong'));
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: Text("No Recommendations to display"));
                        }

                        if (snapshot.hasData) {
                          return GridView.builder(
                              padding: const EdgeInsets.all(10),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.5,
                              ),
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (context, i) {
                                return Material(
                                  child: Container(
                                    margin: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.teal.withOpacity(0.2),
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailsScreen(
                                              mainCategoryName: snapshot.data!
                                                  .docs[i]['mainCategory'],
                                              productId: snapshot.data?.docs[i]
                                                  ['productId'],
                                              subCategoryName: subCategoryName,
                                              productTitle: snapshot.data
                                                  ?.docs[i]['productTitle'],
                                              productDescription:
                                                  snapshot.data!.docs[i]
                                                      ['productDescription'],
                                              productPrice: snapshot
                                                  .data?.docs[i]['price'],
                                              productQuantity: snapshot
                                                  .data?.docs[i]['inStock'],
                                              productImageUrl: snapshot.data
                                                  ?.docs[i]['productImageUrl'],
                                            ),
                                          ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Ink(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                      Icons.favorite_border),
                                                  color: Colors.purple,
                                                )
                                              ],
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Image.network(
                                                  snapshot.data?.docs[i]
                                                      ['productImageUrl'],
                                                  fit: BoxFit.scaleDown,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Text(
                                                snapshot.data?.docs[i]
                                                    ['productTitle'],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Text(
                                                "EGP ${snapshot.data?.docs[i]['price'].toStringAsFixed(2)}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }

                        // if (!snapshot.hasData) {
                        //   return Center(
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: const [
                        //         CircularProgressIndicator(),
                        //         Text("Loading Data..."),
                        //       ],
                        //     ),
                        //   );
                        // }
                        return const Center(
                            child: Text("No recommendations avaiable"));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
