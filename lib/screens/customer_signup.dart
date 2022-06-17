// ignore_for_file: avoid_print
import 'dart:io';
import 'package:ccr_multistore_app/screens/customer_login.dart';
import 'package:flutter/material.dart';

// Package imports
import 'package:image_picker/image_picker.dart';

class CustomerSignUpScreen extends StatefulWidget {
  const CustomerSignUpScreen({Key? key}) : super(key: key);

  @override
  State<CustomerSignUpScreen> createState() => _CustomerSignUpScreenState();
}

class _CustomerSignUpScreenState extends State<CustomerSignUpScreen> {
  late String fullName;
  late String email;
  late String password;

  bool _isPasswordVisible = true;
  // final _firstNameController = TextEditingController();
  // final _lastNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  dynamic _pickedImageError;

  void _pickImage() async {
    try {
      final pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 95,
      );
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      print(_pickedImageError);
    }
  }

  @override
  void initState() {
    super.initState();

    // _firstNameController.addListener(() => setState(() {}));
    // _lastNameController.addListener(() => setState(() {}));
    _fullNameController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create an account"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            reverse: true,
            child: Form(
              key: _fromKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _pickImage();
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.teal,
                      backgroundImage: _imageFile == null
                          ? null
                          : FileImage(File(_imageFile!.path)),
                      child: _imageFile == null
                          ? const Text(
                              "Pick an image",
                              style: TextStyle(color: Colors.white),
                            )
                          : Container(width: 0),
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     Flexible(
                  //       fit: FlexFit.tight,
                  //       flex: 1,
                  //       child: Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 20, vertical: 10),
                  //         child: TextFormField(
                  //           decoration: InputDecoration(
                  //             labelText: "First Name",
                  //             border: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(12),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     Flexible(
                  //       child: Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 20, vertical: 10),
                  //         child: TextFormField(
                  //           decoration: InputDecoration(
                  //             labelText: "Last Name",
                  //             border: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(12),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        } else {
                          return null;
                        }
                      },
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        labelText: "Full Name",
                        suffixIcon: _fullNameController.text.isEmpty
                            ? Container(width: 0)
                            : IconButton(
                                onPressed: () => _fullNameController.clear(),
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an email';
                        } else if (value.isValidEmail() == false) {
                          return 'Invalid email';
                        } else if (value.isValidEmail() == true) {
                          return null;
                        }
                        return null;
                      },
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        labelText: "Email",
                        hintText: "example@domain.com",
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a password';
                        } else {
                          return null;
                        }
                      },
                      controller: _passwordController,
                      obscureText: _isPasswordVisible,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Enter at least 7 characters",
                        hintStyle: const TextStyle(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: _passwordController.text.isEmpty
                            ? Container(width: 0)
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                icon: _isPasswordVisible
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                              ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 20, vertical: 10),
                  //   child: TextFormField(
                  //     decoration: InputDecoration(
                  //       labelText: "Address",
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      if (_fromKey.currentState!.validate()) {
                        if (_imageFile != null) {
                          print("Valid");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please pick an image",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        setState(() {
                          fullName = _fullNameController.text.trim();
                          email = _emailController.text.trim();
                          password = _passwordController.text;
                          _imageFile = null;
                        });
                        _fullNameController.clear();
                        _emailController.clear();
                        _passwordController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please fill all fields",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text("Sign Up"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerLogInScreen()),
                          );
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 200,
                    child: Divider(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Or Sign In using Google"),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.adobe),
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

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^[a-zA-Z0-9]+[\-\_\.]*[a-zA-Z-0-9]*[@][a-zA-Z0-9]{2,}[\.][a-zA-Z]{2,3}$')
        .hasMatch(this);
  }
}
