import 'package:ccr_multistore_app/screens/categories/accessories.dart';
import 'package:ccr_multistore_app/screens/categories/body_components.dart';
import 'package:ccr_multistore_app/screens/categories/electronics.dart';
import 'package:ccr_multistore_app/screens/categories/interior.dart';
import 'package:ccr_multistore_app/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:ccr_multistore_app/helpers/categories.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: mainCategories.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Categories",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.search),
              color: Colors.white,
            ),
          ],
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Theme.of(context).secondaryHeaderColor,
            tabs: [
              Tab(
                child: Text(
                  mainCategories[0],
                ),
              ),
              Tab(
                child: Text(
                  mainCategories[1],
                ),
              ),
              Tab(
                child: Text(
                  mainCategories[2],
                ),
              ),
              Tab(
                child: Text(
                  mainCategories[3],
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AccessoriesCategory(),
            BodyComponentsCategory(),
            ElectronicsCategory(),
            InteriorCategory(),
          ],
        ),
      ),
    );
  }
}
