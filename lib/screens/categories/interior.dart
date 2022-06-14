import 'package:ccr_multistore_app/screens/sub_category_products.dart';
import 'package:flutter/material.dart';

List<String> _namesList = [
  'Air Fresheners',
  'Phone Holders',
  'Car Covers',
];
List<String> _imageList = [
  'assets/images/interior/0.jpg',
  'assets/images/interior/1.jpg',
  'assets/images/interior/2.jpg',
];

class InteriorCategory extends StatelessWidget {
  const InteriorCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: _imageList.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SubCategoryProductsScreen(subCategoryName: _namesList[i],)));
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                child: Column(
                  children: [
                    SizedBox(
                      height: 130,
                      width: 130,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          image: AssetImage(_imageList[i]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_namesList[i]),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
