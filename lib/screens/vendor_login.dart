// ignore_for_file: use_build_context_synchronously

// Package imports
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

class VendorLoginScreen extends StatefulWidget {
  const VendorLoginScreen({Key? key}) : super(key: key);

  @override
  State<VendorLoginScreen> createState() => _VendorLoginScreenState();
}

class _VendorLoginScreenState extends State<VendorLoginScreen> {
  // Firebase Instances
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Loading boolean
  bool _isLoading = false;

  // Authentication Parameters & functions
  late String email;
  late String password;

  void login() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        _formKey.currentState!.reset();
        Navigator.pushReplacementNamed(context, '/vendor_home');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "No account is associated with the provided email",
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (e.code == 'wrong-password') {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Incorrect password",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all fields",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  // Validation Parameters
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Text Editing Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Conditions
  bool _isPasswordInvisible = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome Back!"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your email address";
                        } else if (!EmailValidator.validate(value)) {
                          return "Please enter a valid email address";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => email = value,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        labelText: "Email",
                        suffixIcon: _emailController.text.isEmpty
                            ? Container(width: 0)
                            : IconButton(
                                onPressed: () => _emailController.clear(),
                                icon: const Icon(Icons.close),
                              ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      obscureText: _isPasswordInvisible,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your password";
                        }
                      },
                      onChanged: (value) => password = value,
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: "Password",
                        suffixIcon: _passwordController.text.isEmpty
                            ? Container(width: 0)
                            : IconButton(
                                onPressed: () => setState(() {
                                  _isPasswordInvisible = !_isPasswordInvisible;
                                }),
                                icon: _isPasswordInvisible
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                              ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  _isLoading == true
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: login,
                          child: const Text("Sign In"),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Forgot your password?"),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Tap here",
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have a business account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/vendor_signup');
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
