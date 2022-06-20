import 'package:flutter/material.dart';

class EditBusinessProfile extends StatelessWidget {
  const EditBusinessProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Business Profile"),
        centerTitle: true,
      ),
    );
  }
}
