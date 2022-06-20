// Package imports
import 'package:flutter/material.dart';

// Helper imports
import 'package:ccr_multistore_app/helpers/categories.dart';

// Screen imports
import 'package:ccr_multistore_app/screens/sub_category_products.dart';

class AccessoriesCategory extends StatelessWidget {
  const AccessoriesCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: accessoriesSubCategoriesImages.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategoryProductsScreen(
                    subCategoryName: accessoriesSubCategories[i],
                  ),
                ),
              );
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
                          image: AssetImage(accessoriesSubCategoriesImages[i]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(accessoriesSubCategories[i]),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
