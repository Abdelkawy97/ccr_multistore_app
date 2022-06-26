import 'package:badges/badges.dart';
import 'package:ccr_multistore_app/models/cart.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;
  final String mainCategoryName;
  final String subCategoryName;
  final String productTitle;
  final String productDescription;
  final String productImageUrl;
  final double productPrice;
  final int productStock;
  final String vid;

  const ProductDetailsScreen(
      {Key? key,
      required this.mainCategoryName,
      required this.subCategoryName,
      required this.productTitle,
      required this.productDescription,
      required this.productPrice,
      required this.productStock,
      required this.productImageUrl,
      required this.productId,
      required this.vid})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final Stream<QuerySnapshot> reviewsStream = FirebaseFirestore.instance
      .collection('products')
      .doc(widget.productId)
      .collection('reviews')
      .snapshots();
  late final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance
      .collection('products')
      .where('subCategory', isEqualTo: widget.subCategoryName)
      .where('productId', isNotEqualTo: widget.productId)
      .snapshots();
  int cartCount = 0;
  int favCount = 0;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.productTitle),
            centerTitle: true,
          ),
          bottomSheet: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              cartCount < 1
                  ? widget.productStock == 0
                      ? const SizedBox(width: 0)
                      : IconButton(
                          onPressed: () {
                            context.read<Cart>().addItem(
                                  title: widget.productTitle,
                                  price: widget.productPrice,
                                  quantity: 1,
                                  inStock: widget.productStock,
                                  imageUrl: widget.productImageUrl,
                                  documentId: widget.productId,
                                  vid: widget.vid,
                                );
                            setState(() {
                              cartCount++;
                            });
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(
                            //     content: Text(
                            //       "Item added to cart!",
                            //       textAlign: TextAlign.center,
                            //     ),
                            //   ),
                            // );
                          },
                          icon: context.watch<Cart>().getItems.isEmpty
                              ? const Icon(Icons.shopping_cart)
                              : Badge(
                                  badgeContent: Text(
                                    context
                                        .watch<Cart>()
                                        .getItems
                                        .length
                                        .toString(),
                                  ),
                                  badgeColor: Colors.teal,
                                  child: const Icon(Icons.add_shopping_cart),
                                ),
                        )
                  : IconButton(
                      onPressed: () {},
                      icon: Badge(
                        badgeContent: Text(
                          context.watch<Cart>().getItems.length.toString(),
                        ),
                        badgeColor: Colors.teal,
                        child: const Icon(Icons.add_shopping_cart),
                      ),
                    )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: Image.network(widget.productImageUrl),
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "EGP ${widget.productPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                widget.productStock == 0
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "This item is currently of stock",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "Items left in stock: ${widget.productStock.toString()}"),
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
                    child: Text(widget.productDescription),
                  ),
                ),
                Reviews(reviewsStream),
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
                                              subCategoryName:
                                                  widget.subCategoryName,
                                              productTitle: snapshot.data
                                                  ?.docs[i]['productTitle'],
                                              productDescription:
                                                  snapshot.data!.docs[i]
                                                      ['productDescription'],
                                              productPrice: snapshot
                                                  .data?.docs[i]['price'],
                                              productStock: snapshot
                                                  .data?.docs[i]['inStock'],
                                              productImageUrl: snapshot.data
                                                  ?.docs[i]['productImageUrl'],
                                              vid: snapshot.data?.docs[i]
                                                  ['vid'],
                                            ),
                                          ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Ink(
                                        child: Column(
                                          children: [
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
                        if (!snapshot.hasData) {
                          return const Center(
                              child: Text("No recommendations avaiable"));
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
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

Widget Reviews(var reviewsStream) {
  return ExpandablePanel(
      header: const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          "Reviews",
          style: TextStyle(fontSize: 24),
        ),
      ),
      collapsed: const Text(""),
      expanded: ReviewsAll(reviewsStream));
}

Widget ReviewsAll(var reviewsStream) {
  return StreamBuilder<QuerySnapshot>(
      stream: reviewsStream,
      builder: (context, snapshot2) {
        if (snapshot2.hasError) {
          return const Center(child: Text("Something went wrong"));
        }
        if (snapshot2.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot2.data!.docs.isEmpty) {
          return const Center(child: Text("This product has no reviews yet"));
        }
        return ListView.builder(
            itemCount: snapshot2.data!.docs.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: ((context, i) {
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        snapshot2.data!.docs[i]['profileImageUrl']),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(snapshot2.data!.docs[i]['customerFirstName'] +
                          " " +
                          snapshot2.data!.docs[i]['customerLastName']),
                      Row(
                        children: [
                          Text(
                            snapshot2.data!.docs[i]['rating'].toString(),
                          ),
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ],
                      )
                    ],
                  ),
                  subtitle: Text(snapshot2.data!.docs[i]['comment']),
                ),
              );
            }));
      });
}
