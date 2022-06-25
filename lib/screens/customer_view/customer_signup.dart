// ignore_for_file: use_build_context_synchronously, avoid_print

// Package imports
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:email_validator/email_validator.dart';

class CustomerSignUpScreen extends StatefulWidget {
  const CustomerSignUpScreen({Key? key}) : super(key: key);

  @override
  State<CustomerSignUpScreen> createState() => _CustomerSignUpScreenState();
}

class _CustomerSignUpScreenState extends State<CustomerSignUpScreen> {
  // Firebase Instances
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // Loading boolean
  bool _isLoading = false;

  // Authentication Parameters & functions
  late String firstName;
  late String lastName;
  late String email;
  late String password;
  late String phoneNumber;
  late String address;
  late String profileImageUrl;
  late String _uid;

  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  void signUp() async {
    {
      setState(() {
        _isLoading = true;
      });
      if (_formKey.currentState!.validate()) {
        if (_imageFile != null) {
          try {
            await _firebaseAuth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            );

            Reference ref = _firebaseStorage.ref('customer-images/$email.jpg');
            await ref.putFile(File(_imageFile!.path));
            _uid = _firebaseAuth.currentUser!.uid;

            profileImageUrl = await ref.getDownloadURL();
            await customers.doc(_firebaseAuth.currentUser!.uid).set({
              'firstName': firstName,
              'lastName': lastName,
              'email': email,
              'profileImageUrl': profileImageUrl,
              'phoneNumber': phoneNumber,
              'address': address,
              'cid': _uid,
            });

            _formKey.currentState!.reset();
            setState(() {
              _imageFile = null;
            });
            Navigator.pushReplacementNamed(context, '/customer_home');
          } on FirebaseAuthException catch (e) {
            if (e.code == 'email-already-in-use') {
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "An account already exists for this email!",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else if (e.code == 'weak-password') {
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Password is too weak",
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
                "Please pick an image",
                textAlign: TextAlign.center,
              ),
            ),
          );
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
  }

  // Image Picker Parameters & Functions
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _imageFile;
  dynamic _pickedImageError;

  void _pickImage() async {
    try {
      final pickedImage = await _imagePicker.pickImage(
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

  // Validation Parameters
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Text Editing Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Conditions
  bool _isPasswordInvisible = true;

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(() => setState(() {}));
    _lastNameController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    _phoneNumberController.addListener(() => setState(() {}));
    _addressController.addListener(() => setState(() {}));
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.teal,
                      backgroundImage: _imageFile == null
                          ? null
                          : FileImage(
                              File(_imageFile!.path),
                            ),
                      child: _imageFile == null
                          ? const Text(
                              "Pick an image",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            )
                          : Container(
                              width: 0,
                            ),
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: TextFormField(
                            autofocus: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter first name";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              firstName = value;
                            },
                            controller: _firstNameController,
                            keyboardType: TextInputType.name,
                            maxLength: 15,
                            decoration: InputDecoration(
                              labelText: "First Name",
                              suffixIcon: _firstNameController.text.isEmpty
                                  ? Container(width: 0)
                                  : IconButton(
                                      onPressed: () =>
                                          _firstNameController.clear(),
                                      icon: const Icon(Icons.close),
                                    ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your last name";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              lastName = value;
                            },
                            controller: _lastNameController,
                            keyboardType: TextInputType.name,
                            maxLength: 15,
                            decoration: InputDecoration(
                              labelText: "Last Name",
                              suffixIcon: _lastNameController.text.isEmpty
                                  ? Container(width: 0)
                                  : IconButton(
                                      onPressed: () =>
                                          _lastNameController.clear(),
                                      icon: const Icon(Icons.close),
                                    ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter an email address";
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
                      obscureText: _isPasswordInvisible,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a password";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => password = value,
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: "Password",
                        hintText: "Enter 6 characters at least",
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your phone number";
                        } else if (value.length < 11) {
                          return "Please enter a valid phone number";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        phoneNumber = value;
                      },
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      maxLength: 11,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone),
                        labelText: "Phone Number",
                        suffixIcon: _phoneNumberController.text.isEmpty
                            ? Container(width: 0)
                            : IconButton(
                                onPressed: () => _phoneNumberController.clear(),
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
                          return "Please enter your address";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        address = value;
                      },
                      controller: _addressController,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.location_pin),
                        labelText: "Address",
                        suffixIcon: _addressController.text.isEmpty
                            ? Container(width: 0)
                            : IconButton(
                                onPressed: () => _addressController.clear(),
                                icon: const Icon(Icons.close),
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
                          onPressed: signUp,
                          child: const Text("Sign Up"),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/customer_login');
                        },
                        child: const Text(
                          "Sign In",
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
