// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ccr_multistore_app/screens/vendor_view/dashboard_components/edit_business_profile.dart';
import 'package:ccr_multistore_app/screens/vendor_view/dashboard_components/manage_products.dart';
import 'package:ccr_multistore_app/screens/vendor_view/dashboard_components/my_store.dart';
import 'package:ccr_multistore_app/screens/vendor_view/dashboard_components/vendor_orders.dart';
import 'package:ccr_multistore_app/screens/vendor_view/dashboard_components/vendor_balance.dart';
import 'package:ccr_multistore_app/screens/vendor_view/dashboard_components/vendor_statistics.dart';

List<String> _labels = [
  'My Store',
  'Orders',
  'Edit Business Profile',
  'Manage Products',
  'Balance',
  'Statistics',
];

List<IconData> _icons = [
  Icons.store,
  Icons.list_alt,
  Icons.edit,
  Icons.settings,
  Icons.attach_money,
  Icons.show_chart
];

List<Widget> _dashboardScreens = [
  const MyStore(),
  const VendorOrders(),
  const EditBusinessProfile(),
  const ManageProducts(),
  const BalanceScreen(),
  const VendorStatisticsScreen(),
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    "Warning",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(
                            context, '/welcome_screen');
                      },
                      child: const Text("Yes"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("No"),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: GridView.count(
          mainAxisSpacing: 50,
          crossAxisSpacing: 50,
          crossAxisCount: 2,
          children: List.generate(
            _dashboardScreens.length,
            (index) {
              return Material(
                child: Card(
                  elevation: 5,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _dashboardScreens[index],
                        ),
                      );
                    },
                    child: Ink(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _icons[index],
                            size: 50,
                          ),
                          Text(
                            _labels[index],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
