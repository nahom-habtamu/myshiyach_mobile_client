import 'package:flutter/material.dart';

import 'category_item.dart';

class MainCategoryBar extends StatelessWidget {
  final List<String> categories;
  final int selectedMainCategory;
  final Function onItemTapped;

  const MainCategoryBar({
    Key? key,
    required this.categories,
    required this.selectedMainCategory,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: SizedBox(
        height: 35,
        child: ListView.builder(
          itemCount: categories.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return CategoryItem(
              category: categories[index],
              isActive: selectedMainCategory == index,
              onTap: () {
                onItemTapped(index);
              },
            );
          },
        ),
      ),
    );
  }
}
