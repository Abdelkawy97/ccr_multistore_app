import 'package:flutter/material.dart';

class Dummy extends StatelessWidget {
  const Dummy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Card(
            child: TextField(),
          ),
          Row(
            children: [Flexible(child: TextFormField())],
          ),
        ],
      ),
    );
  }
}
