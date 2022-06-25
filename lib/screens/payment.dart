import 'package:ccr_multistore_app/models/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedValue = 1;
  late String orderId;
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(
      max: 100,
      msg: "Please wait ...",
      progressBgColor: Colors.white,
      progressValueColor: Colors.teal,
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    double shippingPrice = 10.0;
    return Material(
      child: FutureBuilder<DocumentSnapshot>(
          future: customers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong"));
            }
            if (snapshot.hasData && !snapshot.data!.exists) {
              return const Center(child: Text("Document doesn't exist"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Scaffold(
                appBar: AppBar(
                  title: const Text("Payment"),
                  centerTitle: true,
                ),
                body: Consumer<Cart>(
                  builder: (context, cart, child) {
                    return Center(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: MediaQuery.of(context).size.height * 0.135,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text("Total: "),
                                      Text(
                                          "EGP ${(totalPrice + shippingPrice).toStringAsFixed(2)}")
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text("Order Total: "),
                                      Text(
                                          "EGP ${totalPrice.toStringAsFixed(2)}")
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text("Shipping: "),
                                      Text(
                                          "EGP ${shippingPrice.toStringAsFixed(2)}")
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.80,
                                child: Card(
                                  child: Column(
                                    children: [
                                      RadioListTile(
                                        value: 1,
                                        groupValue: selectedValue,
                                        onChanged: (int? value) {
                                          setState(() {
                                            selectedValue = value!;
                                          });
                                        },
                                        title: const Text("Cash on delivery"),
                                        subtitle: const Text(
                                          "Pay when you receive your order!",
                                        ),
                                      ),
                                      RadioListTile(
                                        value: 2,
                                        groupValue: selectedValue,
                                        onChanged: (int? value) {
                                          setState(() {
                                            selectedValue = value!;
                                          });
                                        },
                                        title: const Text("Cash on delivery"),
                                        subtitle: const Text(
                                          "Pay using a Credit Card",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: ElevatedButton(
                                onPressed: () {
                                  if (selectedValue == 1) {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        child: Column(
                                          children: [
                                            const Center(
                                              child: Text(
                                                "Place Order?",
                                                style: TextStyle(fontSize: 24),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                  "Total: EGP ${(totalPrice + shippingPrice).toStringAsFixed(2)}"),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                showProgress();
                                                for (var item in context
                                                    .read<Cart>()
                                                    .getItems) {
                                                  CollectionReference orderRef =
                                                      FirebaseFirestore.instance
                                                          .collection('orders');
                                                  orderId = const Uuid().v4();
                                                  await orderRef
                                                      .doc(orderId)
                                                      .set({
                                                    'cid': data['cid'],
                                                    'customerFirstName':
                                                        data['firstName'],
                                                    'customerLastName':
                                                        data['lastName'],
                                                    'address': data['address'],
                                                    'phoneNumber':
                                                        data['phoneNumber'],
                                                    'profileImageUrl':
                                                        data['profileImageUrl'],
                                                    'vid': item.vid,
                                                    'productId':
                                                        item.documentId,
                                                    'orderId': orderId,
                                                    'orderPrice':
                                                        item.quantity *
                                                            item.price,
                                                    'deliveryStatus':
                                                        'Preparing',
                                                    'deliveryDate': '',
                                                    'orderDate': DateTime.now(),
                                                    'paymentStatus':
                                                        'Cash on Delivery',
                                                    'orderReview': false,
                                                    'orderName': item.title,
                                                    'productImageUrl':
                                                        item.imageUrl,
                                                    'orderQuantity':
                                                        item.quantity,
                                                  }).whenComplete(() async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .runTransaction(
                                                            (transaction) async {
                                                      DocumentReference
                                                          documentReference =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'products')
                                                              .doc(item
                                                                  .documentId);
                                                      DocumentSnapshot
                                                          prodSnapshot =
                                                          await transaction.get(
                                                              documentReference);
                                                      transaction.update(
                                                          documentReference, {
                                                        'inStock': prodSnapshot[
                                                                'inStock'] -
                                                            item.quantity,
                                                      });
                                                    });
                                                  });
                                                }
                                                context
                                                    .read<Cart>()
                                                    .clearCart();
                                                Navigator.popUntil(
                                                    context,
                                                    ModalRoute.withName(
                                                        '/customer_home'));
                                              },
                                              child: const Text("Confirm"),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                    // context.read<Cart>().clearCart();
                                    // Navigator.popUntil(context,
                                    //     ModalRoute.withName('/customer_home'));
                                  } else if (selectedValue == 2) {
                                    print("Credit Card");
                                  }
                                },
                                child: const Text("Place Order")),
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
