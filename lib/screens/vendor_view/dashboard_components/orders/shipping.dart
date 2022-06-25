import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Shipping extends StatelessWidget {
  const Shipping({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('vid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('deliveryStatus', isEqualTo: 'shipping')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No orders shipping right now!"));
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
                            Text(
                                "Order date: ${DateFormat('dd/MM/yyyy').format(order['orderDate'].toDate()).toString()}"),
                            order['deliveryStatus'] == 'shipping'
                                ? Text(
                                    "Order Status: ${order['deliveryStatus']}",
                                  )
                                : const Text(""),
                            order['deliveryStatus'] == 'shipping'
                                ? Row(
                                    children: [
                                      const Text("Change delivery status to: "),
                                      TextButton(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(order['orderId'])
                                              .update({
                                            'deliveryStatus': 'delivered'
                                          });
                                        },
                                        child: const Text("Delivered"),
                                      ),
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
    );
  }
}
