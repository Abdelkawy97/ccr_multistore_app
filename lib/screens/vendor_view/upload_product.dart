// ignore_for_file: avoid_print

// Package imports
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

// Helper imports
import 'package:ccr_multistore_app/helpers/categories.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({Key? key}) : super(key: key);

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  // Main categories (Accessories, Body Components, etc)
  String? mainCategoryValue;
  List<String> mainCategoryList = [];

  // Sub categories (Category specific subcategory (Air Freshener, Phone Holder, Sun Shield))
  String? subCategoryValue;
  List<String> subCategoryList = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  // Loading boolean
  bool _isLoading = false;

  // Product Parameters & Functions
  late String productTitle;
  late String productDescription;
  late double price;
  late int quantity;
  late double discount;
  late String productImageUrl;
  late String productId;

  void uploadProduct() async {
    if (mainCategoryValue != null && subCategoryValue != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (_imageFile != null) {
          try {
            setState(() {
              _isLoading = true;
            });
            productId = const Uuid().v4();
            CollectionReference productRef =
                FirebaseFirestore.instance.collection('products');

            Reference ref =
                _firebaseStorage.ref('product-images/$productId.jpg');

            await ref.putFile(File(_imageFile!.path));
            productImageUrl = await ref.getDownloadURL();

            await productRef.doc(productId).set({
              'mainCategory': mainCategoryValue,
              'subCategory': subCategoryValue,
              'price': price,
              'inStock': quantity,
              'productTitle': productTitle,
              'productDescription': productDescription,
              'productId': productId,
              'vid': FirebaseAuth.instance.currentUser!.uid,
              'productImageUrl': productImageUrl,
              'discount': 0,
            });
          } catch (e) {
            print(e);
          }
          setState(() {
            setState(() {
              _isLoading = false;
            });
            _imageFile = null;
            mainCategoryValue = null;
            subCategoryValue = null;
          });
          _formKey.currentState!.reset();
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select main and sub categories",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  // Image Picker Parameters & Functions
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _imageFile;

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
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Upload New Product"),
        centerTitle: true,
      ),
      floatingActionButton: _isLoading
          ? const CircularProgressIndicator()
          : FloatingActionButton(
              backgroundColor: Colors.teal,
              onPressed: _isLoading ? null : uploadProduct,
              child: const Icon(
                Icons.upload,
                color: Colors.white,
              ),
            ),
      body:
          // _isLoading
          //     ? const Center(
          //         child: CircularProgressIndicator(),
          //       )
          //     :
          SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: GestureDetector(
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
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        mainCategoryValue == null
                            ? const Text(
                                "* Main Category:",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.red),
                              )
                            : const Text(
                                "Main Category:",
                                style: TextStyle(fontSize: 18),
                              ),
                        DropdownButton(
                          hint: const Text("Select Category"),
                          borderRadius: BorderRadius.circular(12),
                          value: mainCategoryValue,
                          items: mainCategories
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem(
                              value: (value),
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: ((String? value) {
                            mainCategoryValue = value;
                            if (value == mainCategories[0]) {
                              setState(() {
                                subCategoryList = accessoriesSubCategories;
                                subCategoryValue = null;
                              });
                            } else if (value == mainCategories[1]) {
                              setState(() {
                                subCategoryList = bodyComponentsSubCategories;
                                subCategoryValue = null;
                              });
                            } else if (value == mainCategories[2]) {
                              setState(() {
                                subCategoryList = electronicsSubCategories;
                                subCategoryValue = null;
                              });
                            } else if (value == mainCategories[3]) {
                              setState(() {
                                subCategoryList = interiorSubCategories;
                                subCategoryValue = null;
                              });
                            }

                            print(value);
                            setState(() {
                              mainCategoryValue = value;
                            });
                          }),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        subCategoryValue == null
                            ? const Text(
                                "* Sub-Category:",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.red),
                              )
                            : const Text(
                                "Sub-Category:",
                                style: TextStyle(fontSize: 18),
                              ),
                        DropdownButton(
                          hint: const Text("Select Sub-Category"),
                          borderRadius: BorderRadius.circular(12),
                          value: subCategoryValue,
                          items: subCategoryList
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem(
                              value: (value),
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: ((String? value) {
                            print(value);
                            setState(() {
                              subCategoryValue = value;
                            });
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: ((value) {
                            if (value!.isEmpty) {
                              return "Please enter a value";
                            } else if (value.isValidPrice() != true) {
                              return "Invalid value";
                            }
                            return null;
                          }),
                          onSaved: ((value) {
                            price = double.parse(value!);
                          }),
                          keyboardType: TextInputType.number,
                          maxLength: 9,
                          decoration: InputDecoration(
                            labelText: "Price",
                            prefixIcon: const Icon(Icons.currency_pound),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: ((value) {
                            if (value!.isEmpty) {
                              return "Please enter a value";
                            } else if (value.isValidPrice() != true) {
                              return "Invalid value";
                            }
                            return null;
                          }),
                          onSaved: ((value) {
                            discount = double.parse(value!);
                          }),
                          keyboardType: TextInputType.number,
                          maxLength: 5,
                          decoration: InputDecoration(
                            labelText: "Discount",
                            prefixIcon: const Icon(Icons.percent),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Price after discount: "),
                    Text(
                      "EGP ",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: ((value) {
                        if (value!.isEmpty) {
                          return "Please enter a value";
                        } else if (value.isValidQuantity() != true) {
                          return "Invalid value";
                        }
                        return null;
                      }),
                      keyboardType: TextInputType.number,
                      maxLength: 7,
                      onSaved: ((value) {
                        quantity = int.parse(value!);
                      }),
                      decoration: InputDecoration(
                        labelText: "Quantity",
                        prefixIcon: const Icon(Icons.data_array),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: ((value) {
                        if (value!.isEmpty) {
                          return "Please enter a title";
                        } else {
                          return null;
                        }
                      }),
                      onSaved: ((value) {
                        productTitle = value!;
                      }),
                      keyboardType: TextInputType.text,
                      maxLength: 50,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Title",
                        prefixIcon: const Icon(Icons.title),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: ((value) {
                        if (value!.isEmpty) {
                          return "Please enter a description";
                        } else {
                          return null;
                        }
                      }),
                      onSaved: ((value) {
                        productDescription = value!;
                      }),
                      keyboardType: TextInputType.text,
                      maxLength: 200,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: "Description",
                        prefixIcon: const Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'^((([1-9][0-9]*[\.]*)||([0][\.]))([0-9]{1,2}))$')
        .hasMatch(this);
  }
}
