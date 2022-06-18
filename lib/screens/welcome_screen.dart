import 'package:ccr_multistore_app/screens/customer_signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool processing = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/welcome_screen/0.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          constraints: const BoxConstraints.expand(),
          child: processing == true
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Card(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "Car Care & Repair",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "Vendor Specific Functions",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/vendor_home');
                                },
                                child: const Text("Login"),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text("Sign Up"),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 150,
                            child: Divider(
                              color: Colors.white,
                              thickness: 2,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "Customer Specific Functions",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/customer_home');
                                },
                                child: const Text("Login"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CustomerSignUpScreen(),
                                    ),
                                  );
                                },
                                child: const Text("Sign Up"),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          processing = true;
                        });
                        await FirebaseAuth.instance.signInAnonymously();
                        Navigator.pushReplacementNamed(
                            context, '/customer_home');
                      },
                      child: const Text("Continue as a Guest"),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
