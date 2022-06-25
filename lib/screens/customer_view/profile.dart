// ignore_for_file: use_build_context_synchronously, must_be_immutable, avoid_print

// Package imports
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Screen imports
import 'package:ccr_multistore_app/screens/customer_view/customer_orders.dart';

class ProfileScreen extends StatefulWidget {
  String documentId;

  ProfileScreen({Key? key, required this.documentId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // widget.documentId = FirebaseAuth.instance.currentUser!.uid;
    print(widget.documentId);
    super.initState();
  }

  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: customers.doc(widget.documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Center(child: Text("Document doesn't exist"));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  data['profileImageUrl'] == ''
                      ? const CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage:
                              NetworkImage(data['profileImageUrl']),
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: data['firstName'] == '' && data['lastName'] == ''
                        ? const Text("Guest")
                        : Text(data['firstName'] + " " + data['lastName']),
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
                              data['email'] == ''
                                  ? Container(width: 0)
                                  : ClipOval(
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
                              data['email'] == ''
                                  ? Container(width: 0)
                                  : const Text("Orders"),
                            ],
                          ),
                        ]),
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
                              subtitle: data['email'] == ''
                                  ? const Text("Sign up to get full access")
                                  : Text(
                                      data['email'].toString().toLowerCase()),
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
                              subtitle: data['phoneNumber'] == ''
                                  ? const Text("Sign up to get full access")
                                  : Text("+2${data['phoneNumber']}"),
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
                              subtitle: data['address'] == ''
                                  ? const Text("Sign up to get full access")
                                  : Text(data['address']),
                              leading: const Icon(Icons.location_pin),
                            ),
                          ),
                        ],
                      ),
                    ),
                    data['email'] == ''
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                  "Made up your mind? Select what you want to do!"),
                              IconButton(
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacementNamed(
                                      context, '/welcome_screen');
                                },
                                icon: const Icon(Icons.logout),
                              ),
                            ],
                          )
                        : Padding(
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
                    data['email'] == ''
                        ? Container(width: 0)
                        : Card(
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
                                              await FirebaseAuth.instance
                                                  .signOut();
                                              Navigator.pop(context);
                                              Navigator.pushReplacementNamed(
                                                  context, '/welcome_screen');
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
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
