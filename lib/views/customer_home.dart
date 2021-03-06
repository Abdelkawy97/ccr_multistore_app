// Package imports
import 'package:badges/badges.dart';
import 'package:ccr_multistore_app/models/cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Screen imports
import 'package:ccr_multistore_app/screens/customer_view/cart.dart';
import 'package:ccr_multistore_app/screens/categories.dart';
import 'package:ccr_multistore_app/screens/products_home.dart';
import 'package:ccr_multistore_app/screens/customer_view/profile.dart';
import 'package:ccr_multistore_app/screens/stores.dart';
import 'package:provider/provider.dart';

class CustomerHomeView extends StatefulWidget {
  const CustomerHomeView({Key? key}) : super(key: key);

  @override
  State<CustomerHomeView> createState() => _CustomerHomeViewState();
}

class _CustomerHomeViewState extends State<CustomerHomeView> {
  static int _selectedIndex = 0;
  final List<Widget> _tabs = [
    const ProductsHomeScreen(),
    const CategoriesScreen(),
    const CartScreen(),
    const StoresScreen(),
    ProfileScreen(documentId: FirebaseAuth.instance.currentUser!.uid),
  ];
  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.shifting,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.category), label: "Categories"),
          context.watch<Cart>().getItems.isEmpty
              ? const BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart), label: "Cart")
              : BottomNavigationBarItem(
                  icon: Badge(
                    badgeContent: Text(
                      context.watch<Cart>().getItems.length.toString(),
                    ),
                    badgeColor: Colors.teal,
                    child: const Icon(Icons.shopping_cart),
                  ),
                  label: "Cart"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.shop), label: "Stores"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
