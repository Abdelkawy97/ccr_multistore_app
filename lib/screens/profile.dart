// ignore_for_file: use_build_context_synchronously

import 'package:ccr_multistore_app/customer_screens/customer_orders.dart';
import 'package:ccr_multistore_app/customer_screens/favorites_screen.dart';
import 'package:ccr_multistore_app/screens/cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String documentId;
  const ProfileScreen({Key? key, required this.documentId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: customers.doc(widget.documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document doesn't exist");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(data['profileImageUrl']),
                  ),
                  // CircleAvatar(
                  //   backgroundColor: Colors.teal,
                  //   child: Icon(
                  //     Icons.person,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(data['firstName'] + " " + data['lastName']),
                  )
                ],
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            ClipOval(
                              child: Container(
                                color: Colors.teal,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CartScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.shopping_cart,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const Text("Cart"),
                          ],
                        ),
                        Column(
                          children: [
                            ClipOval(
                              child: Container(
                                color: Colors.teal,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CustomerOrders(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.list_alt,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const Text("Orders"),
                          ],
                        ),
                        Column(
                          children: [
                            ClipOval(
                              child: Container(
                                color: Colors.teal,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const FavoritesScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const Text("Favorites"),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: Divider(),
                          ),
                          Text(
                            "Account Details",
                            style: TextStyle(fontSize: 32),
                          ),
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: Divider(),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: ListTile(
                              title: const Text("Email Address"),
                              subtitle:
                                  Text(data['email'].toString().toLowerCase()),
                              leading: const Icon(Icons.email),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: Divider(
                              thickness: 0.5,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: ListTile(
                              title: const Text("Phone Number"),
                              subtitle: Text("+2${data['phoneNumber']}"),
                              leading: const Icon(Icons.phone),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: Divider(
                              thickness: 0.5,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: ListTile(
                              title: const Text("Address"),
                              subtitle: Text(data['address']),
                              leading: const Icon(Icons.location_pin),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: Divider(),
                          ),
                          Text(
                            "Account Settings",
                            style: TextStyle(fontSize: 32),
                          ),
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: Divider(),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: const ListTile(
                              title: Text("Edit Profile"),
                              leading: Icon(Icons.edit),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: Divider(
                              thickness: 1,
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: const ListTile(
                              title: Text("Change Password"),
                              leading: Icon(Icons.lock),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: Divider(
                              thickness: 1,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text(
                                    "Warning",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content: const Text(
                                      "Are you sure you want to logout?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        await FirebaseAuth.instance.signOut();
                                        Navigator.pop(context);
                                        Navigator.pushReplacementNamed(
                                            context, '/welcome_screen');
                                        setState(() {});
                                      },
                                      child: const Text("Yes"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("No"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const ListTile(
                              title: Text("Logout"),
                              leading: Icon(Icons.logout),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const Text("Loading");
      },
    );
  }
}
