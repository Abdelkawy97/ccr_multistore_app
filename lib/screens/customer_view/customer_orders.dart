import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CustomerOrders extends StatelessWidget {
  const CustomerOrders({Key? key}) : super(key: key);

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
                          padding: const EdgeInsets.only(top: 20, right: 150),
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
                                      onPressed: () {},
                                      child: const Text("Leave a review"),
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
