import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditBusinessProfile extends StatefulWidget {
  final dynamic data;
  const EditBusinessProfile({Key? key, required this.data}) : super(key: key);

  @override
  State<EditBusinessProfile> createState() => _EditBusinessProfileState();
}

final TextEditingController _firstNameController = TextEditingController();

class _EditBusinessProfileState extends State<EditBusinessProfile> {
  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(() => setState(() {}));
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? imageFile;
  late String storeName;
  late String phoneNumber;
  late String address;
  late String storeImageUrl;

  bool isLoading = false;

  void saveChanges() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      editStoreData();
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
  }

  Future uploadImage() async {
    if (imageFile != null) {
      try {
        Reference ref = FirebaseStorage.instance
            .ref('vendor-images/${widget.data['email']}.jpg');
        await ref.putFile(File(imageFile!.path));

        storeImageUrl = await ref.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      storeImageUrl = widget.data['profileImageUrl'];
    }
  }

  void pickImage() async {
    try {
      final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 95,
      );
      setState(() {
        imageFile = pickedImage;
      });
    } catch (e) {
      print(e);
    }
  }

  editStoreData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('vendors')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        'storeName': storeName,
        'phoneNumber': phoneNumber,
        'address': address,
      });
    }).whenComplete(
      () {
        setState(() {
          isLoading = false;
        });
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Changes saved",
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Business Profile"),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 180,
                width: 200,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text("Store Image"),
                      imageFile == null
                          ? CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.teal,
                              backgroundImage: NetworkImage(
                                widget.data['profileImageUrl'],
                              ),
                            )
                          : CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.teal,
                              backgroundImage: FileImage(
                                File(imageFile!.path),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  pickImage();
                },
                child: const Text("Change Photo"),
              ),
              const Divider(
                thickness: 1.5,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  initialValue: widget.data['storeName'],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter the store's name";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    storeName = value!;
                  },
                  keyboardType: TextInputType.name,
                  maxLength: 15,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.store),
                    labelText: "Store Name",
                    suffixIcon: _firstNameController.text.isEmpty
                        ? Container(width: 0)
                        : IconButton(
                            onPressed: () => _firstNameController.clear(),
                            icon: const Icon(Icons.close),
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  initialValue: widget.data['phoneNumber'],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter the store's phone number";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    phoneNumber = value!;
                  },
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone),
                    labelText: "Phone Number",
                    suffixIcon: _firstNameController.text.isEmpty
                        ? Container(width: 0)
                        : IconButton(
                            onPressed: () => _firstNameController.clear(),
                            icon: const Icon(Icons.close),
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  initialValue: widget.data['address'],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter the store's address";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    address = value!;
                  },
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone),
                    labelText: "Address",
                    suffixIcon: _firstNameController.text.isEmpty
                        ? Container(width: 0)
                        : IconButton(
                            onPressed: () => _firstNameController.clear(),
                            icon: const Icon(Icons.close),
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                          ),
                          child: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            saveChanges();
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                          ),
                          child: const Icon(
                            Icons.check_circle_outline_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
