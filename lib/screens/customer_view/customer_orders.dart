import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class CustomerOrders extends StatefulWidget {
  const CustomerOrders({Key? key}) : super(key: key);

  @override
  State<CustomerOrders> createState() => _CustomerOrdersState();
}

class _CustomerOrdersState extends State<CustomerOrders> {
  late double rating;
  late String comment;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('cid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("You have no orders yet!"));
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, i) {
                var order = snapshot.data!.docs[i];
                return Card(
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Container(
                          constraints:
                              const BoxConstraints(maxHeight: 80, maxWidth: 80),
                          child: Image.network(order['productImageUrl']),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              children: [
                                Text(
                                  order['orderName'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                        "EGP ${order['orderPrice'].toStringAsFixed(2)}"),
                                    Text("Amount : x${order['orderQuantity']}"),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // subtitle: const Text("Delivery status:"),
                    children: [
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name: ${order['customerFirstName']} ${order['customerLastName']}",
                              ),
                              Text(
                                "Phone Number: +2${order['phoneNumber']}",
                              ),
                              Text(
                                "Address: ${order['address']}",
                              ),
                              Text(
                                "Payment Method: ${order['paymentStatus']} ",
                              ),
                              order['deliveryDate'] == ''
                                  ? const Text(
                                      "Estimated delivery date: Pending vendor")
                                  : Text(
                                      "Estimated delivery date: ${DateFormat('dd-MM-yyy').format(order['deliveryDate'].toDate()).toString()}",
                                    ),
                              Text(
                                "Order Status: ${order['deliveryStatus']}",
                              ),
                              order['deliveryStatus'] == 'shipping'
                                  ? Text(
                                      "Delivery Status: ${order['deliveryStatus']}",
                                    )
                                  : const Text(""),
                              order['deliveryStatus'] == 'delivered' &&
                                      order['orderReview'] == false
                                  ? TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Material(
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  RatingBar.builder(
                                                    allowHalfRating: true,
                                                    initialRating: 1,
                                                    minRating: 1,
                                                    maxRating: 5,
                                                    onRatingUpdate: (value) {
                                                      rating = value;
                                                    },
                                                    itemBuilder: (context, i) {
                                                      return const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      );
                                                    },
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextField(
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Leave a comment",
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      onChanged: (value) {
                                                        comment = value;
                                                      },
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          CollectionReference
                                                              collectionReference =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'products')
                                                                  .doc(order[
                                                                      'productId'])
                                                                  .collection(
                                                                      'reviews');

                                                          await collectionReference
                                                              .doc(FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid)
                                                              .set({
                                                            'customerFirstName':
                                                                order[
                                                                    'customerFirstName'],
                                                            'customerLastName':
                                                                order[
                                                                    'customerLastName'],
                                                            'rating': rating,
                                                            'comment': comment,
                                                            'profileImageUrl':
                                                                order[
                                                                    'profileImageUrl'],
                                                          })
                                                          .whenComplete(
                                                                  () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .runTransaction(
                                                                    (transaction) async {
                                                              DocumentReference
                                                                  docRef =
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'orders')
                                                                      .doc(order[
                                                                          'orderId']);

                                                              transaction
                                                                  .update(
                                                                      docRef, {
                                                                'orderReview':
                                                                    true,
                                                              });
                                                            });
                                                          });
                                                          await Future.delayed(
                                                                  const Duration(
                                                                      microseconds:
                                                                          100))
                                                              .whenComplete(() =>
                                                                  Navigator.pop(
                                                                      context));
                                                        },
                                                        child: const Text(
                                                            "Confirm"),
                                                      ),
                                                      const SizedBox(width: 30),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            "Cancel"),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child:
                                          const Text("Leave rating and review"),
                                    )
                                  : const Text(""),
                              order['deliveryStatus'] == 'delivered' &&
                                      order['orderReview'] == true
                                  ? Row(
                                      children: const [
                                        Icon(
                                          Icons.check,
                                          color: Colors.teal,
                                        ),
                                        Text("Review Added"),
                                      ],
                                    )
                                  : const Text(""),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
