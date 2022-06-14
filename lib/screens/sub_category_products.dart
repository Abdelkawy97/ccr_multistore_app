import 'package:flutter/material.dart';

class SubCategoryProductsScreen extends StatelessWidget {
  final String subCategoryName;
  const SubCategoryProductsScreen({
    Key? key,
    required this.subCategoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subCategoryName),
        centerTitle: true,
      ),
    );
  }
}
