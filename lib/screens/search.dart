import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ccr_multistore_app/screens/product_details.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchInput = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          actions: [
            Row(
              children: const [
                Icon(
                  Icons.abc,
                  color: Colors.transparent,
                ),
                Icon(
                  Icons.abc,
                  color: Colors.transparent,
                ),
              ],
            ),
          ],
          title: TextFormField(
            autofocus: true,
            style: const TextStyle(
              color: Colors.white,
            ),
            onChanged: (value) {
              setState(() {
                searchInput = value;
              });
            },
            decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.white),
              hintText: "Search",
            ),
          ),
        ),
        body: searchInput == ''
            ? const Center(
                child: Text("Enter a product title to search!"),
              )
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final result = snapshot.data!.docs
                      .where(
                        (e) => e['productTitle']
                            .contains(searchInput.toLowerCase()),
                      )
                      .toList();

                  return ListView(
                      children: result.map((e) => SearchModel(e: e)).toList());
                },
              ));
  }
}

class SearchModel extends StatelessWidget {
  final dynamic e;
  const SearchModel({Key? key, required this.e}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              mainCategoryName: e['mainCategory'],
              subCategoryName: e['subCategory'],
              productTitle: e['productTitle'],
              productDescription: e['productDescription'],
              productPrice: e['price'],
              productStock: e['inStock'],
              productImageUrl: e['productImageUrl'],
              productId: e['productId'],
              vid: e['vid'],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.network(
                    e['productImageUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      e['productTitle'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "EGP ${e['price'].toStringAsFixed(2)}",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
