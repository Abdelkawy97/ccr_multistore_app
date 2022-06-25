import 'package:flutter/material.dart';
import 'package:ccr_multistore_app/screens/vendor_view/dashboard_components/orders/preparing.dart';
import 'package:ccr_multistore_app/screens/vendor_view/dashboard_components/orders/shipping.dart';
import 'package:ccr_multistore_app/screens/vendor_view/dashboard_components/orders/delivered.dart';

class VendorOrders extends StatelessWidget {
  const VendorOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text(
            "Orders",
          ),
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Preparing"),
              Tab(text: "Shipping"),
              Tab(
                text: "Delivered",
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Preparing(),
            Shipping(),
            Delivered(),
          ],
        ),
      ),
    );
  }
}
