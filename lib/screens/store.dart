import 'package:ccr_multistore_app/screens/product_details.dart';
import 'package:ccr_multistore_app/screens/vendor_view/dashboard_components/edit_business_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StoreScreen extends StatefulWidget {
  final String storeName;
  final String vendorId;
  const StoreScreen({
    Key? key,
    required this.vendorId,
    required this.storeName,
  }) : super(
          key: key,
        );

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  CollectionReference vendors =
      FirebaseFirestore.instance.collection('vendors');

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('vid', isEqualTo: widget.vendorId)
        .snapshots();
    return FutureBuilder<DocumentSnapshot>(
      future: vendors.doc(widget.vendorId).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
              body: Center(child: Text("Something went wrong")));
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Scaffold(
              body: Center(child: Text("Document doesn't exist")));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                data['storeName'],
              ),
              centerTitle: true,
              actions: [
                data['vid'] == FirebaseAuth.instance.currentUser!.uid
                    ? IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditBusinessProfile(data: data),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                      )
                    : Container(width: 0),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          "Store Details",
                          textAlign: TextAlign.center,
                        ),
                        // content: const Center(child: Text("Store Details")),
                        actions: [
                          Column(
                            children: [
                              Text("Store Name: ${data['storeName']}"),
                              Text("Phone Number: +2${data['phoneNumber']}"),
                              Text("Address: ${data['address']}"),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Confirm"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.info_outline),
                )
              ],
            ),
            body: StreamBuilder<QuerySnapshot>(
                stream: productsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("This store has no items yet!"),
                    );
                  }
                  return GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  color: Colors.teal.withOpacity(0.2),
                                  width: 3),
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
                                      subCategoryName: snapshot.data!.docs[i]
                                          ['subCategory'],
                                      productTitle: snapshot.data!.docs[i]
                                          ['productTitle'],
                                      productDescription: snapshot.data!.docs[i]
                                          ['productDescription'],
                                      productPrice: snapshot.data!.docs[i]
                                          ['price'],
                                      productStock: snapshot.data!.docs[i]
                                          ['inStock'],
                                      productImageUrl: snapshot.data!.docs[i]
                                          ['productImageUrl'],
                                      vid: snapshot.data?.docs[i]['vid'],
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
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Image.network(
                                          snapshot.data!.docs[i]
                                              ['productImageUrl'],
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Text(
                                        snapshot.data!.docs[i]['productTitle'],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
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
                }),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
