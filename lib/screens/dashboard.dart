import 'package:flutter/material.dart';

List<String> _labels = [
  'My Store',
  'Orders',
  'Edit Profile',
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

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
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
          children: List.generate(6, (index) {
            return GestureDetector(
              onTap: () {},
              child: Card(
                elevation: 5,
                shadowColor: Colors.grey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _icons[index],
                      size: 50,
                    ),
                    Text(
                      _labels[index],
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
