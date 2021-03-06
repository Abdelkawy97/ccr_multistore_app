// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  late String _uid;
  bool processing = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(),
        body: processing == true
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Card(
                    elevation: 5,
                    // color: Colors.transparent,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "Car Care & Repair",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32,
                              // color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(
                          // color: Colors.white,
                          thickness: 2,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "Vendor Account",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              // color: Colors.white,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/vendor_login');
                              },
                              child: const Text("Login"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/vendor_signup');
                              },
                              child: const Text("Sign Up"),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 150,
                          child: Divider(
                            // color: Colors.white,
                            thickness: 2,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "Customer Account",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              // color: Colors.white,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/customer_login');
                              },
                              child: const Text("Login"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/customer_signup');
                              },
                              child: const Text("Sign Up"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: ElevatedButton(
                  //     onPressed: () async {
                  //       setState(() {
                  //         processing = true;
                  //       });
                  //       await FirebaseAuth.instance
                  //           .signInAnonymously()
                  //           .whenComplete(() async {
                  //         _uid = FirebaseAuth.instance.currentUser!.uid;
                  //         await customers.doc(_uid).set({
                  //           'firstName': '',
                  //           'lastName': '',
                  //           'email': '',
                  //           'profileImageUrl': '',
                  //           'phoneNumber': '',
                  //           'address': '',
                  //           'cid': _uid,
                  //         });
                  //       });

                  //       Navigator.pushReplacementNamed(
                  //           context, '/customer_home');
                  //     },
                  //     child: const Text("Continue as a Guest"),
                  //   ),
                  // ),
                ],
              ),
      ),
    );
  }
}
