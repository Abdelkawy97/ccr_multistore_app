import 'package:flutter/material.dart';

import 'package:ccr_multistore_app/helpers/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {
        // TO-DO
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Car Care & Repair",
      themeMode: currentTheme.currentTheme,
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Flutter Theme Demo"),
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_4_rounded),
              onPressed: () => currentTheme.toggleTheme(),
            ),
          ],
        ),
      ),
    );
  }
}
