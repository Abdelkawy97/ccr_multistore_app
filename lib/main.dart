import 'package:ccr_multistore_app/screens/welcome_screen.dart';
import 'package:ccr_multistore_app/views/customer_home.dart';
import 'package:ccr_multistore_app/views/vendor_home.dart';
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
      initialRoute: '/welcome_screen',
      routes: {
        '/welcome_screen': (context) => const WelcomeScreen(),
        '/customer_home': (context) => const CustomerHomeView(),
        '/vendor_home': (context) => const VendorHomeView(),
      },
    );
  }
}
