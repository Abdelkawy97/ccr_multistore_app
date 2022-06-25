// Package imports
import 'package:ccr_multistore_app/models/cart.dart';
import 'package:ccr_multistore_app/models/favorite.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Screen imports
import 'package:ccr_multistore_app/screens/customer_view/customer_login.dart';
import 'package:ccr_multistore_app/screens/customer_view/customer_signup.dart';
import 'package:ccr_multistore_app/screens/welcome_screen.dart';
import 'package:ccr_multistore_app/views/customer_home.dart';
import 'package:ccr_multistore_app/views/vendor_home.dart';
import 'package:ccr_multistore_app/screens/vendor_view/vendor_signup.dart';
import 'package:ccr_multistore_app/screens/vendor_view/vendor_login.dart';

// Helper imports
import 'package:ccr_multistore_app/helpers/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => Favorite())
      ],
      child: MaterialApp(
        title: "Car Care & Repair",
        // themeMode: currentTheme.currentTheme,
        themeMode: ThemeMode.system,
        theme: CustomTheme.lightTheme,
        darkTheme: CustomTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        // home: const CustomerSignUpScreen(),
        initialRoute: '/welcome_screen',
        routes: {
          '/welcome_screen': (context) => const WelcomeScreen(),
          '/customer_home': (context) => const CustomerHomeView(),
          '/customer_signup': (context) => const CustomerSignUpScreen(),
          '/customer_login': (context) => const CustomerLoginScreen(),
          '/vendor_home': (context) => const VendorHomeView(),
          '/vendor_signup': (context) => const VendorSignUpScreen(),
          '/vendor_login': (context) => const VendorLoginScreen(),
        },
      ),
    );
  }
}
