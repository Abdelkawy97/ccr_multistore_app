// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({Key? key}) : super(key: key);

  @override
  State<ProductImages> createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? imageFileList = [];

  void selectImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
    print("Image List Length : ${imageFileList!.length.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: selectImages,
              child: const Text("Select Images"),
            ),
            Expanded(
              child: GridView.builder(
                  itemCount: imageFileList?.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(imageFileList![i].path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
      // GridView.builder(
      //     itemCount: 6,
      //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //         crossAxisCount: 2),
      //     itemBuilder: (context, i) {
      // return Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.circular(12),
      //     child: Material(
      //       child: InkWell(
      //         onTap: selectImages,
      //         child: Ink(
      //           color: Colors.teal,
      //           child: const Center(
      //             child: Text(
      //               "Pick an Image",
      //               style: TextStyle(color: Colors.white),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // );
      // }),
    );
  }
}
