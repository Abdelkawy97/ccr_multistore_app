import 'package:ccr_multistore_app/screens/cart.dart';
import 'package:ccr_multistore_app/screens/categories.dart';
import 'package:ccr_multistore_app/screens/products_home.dart';
import 'package:ccr_multistore_app/screens/profile.dart';
import 'package:ccr_multistore_app/screens/stores.dart';
import 'package:flutter/material.dart';

class CustomerHomeView extends StatefulWidget {
  const CustomerHomeView({Key? key}) : super(key: key);

  @override
  State<CustomerHomeView> createState() => _CustomerHomeViewState();
}

class _CustomerHomeViewState extends State<CustomerHomeView> {
  static int _selectedIndex = 0;
  final List<Widget> _tabs = const [
    ProductsHomeScreen(),
    CategoriesScreen(),
    CartScreen(),
    StoresScreen(),
    ProfileScreen(),
  ];
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: "Categories"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: "Stores"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
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
