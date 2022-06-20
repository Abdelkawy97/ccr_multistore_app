import 'package:flutter/material.dart';

class VendorStatisticsScreen extends StatelessWidget {
  const VendorStatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
        centerTitle: true,
      ),
    );
  }
}
