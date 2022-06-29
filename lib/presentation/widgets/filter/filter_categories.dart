import 'package:flutter/material.dart';

import '../home/category_item.dart';

class FilterCategories extends StatefulWidget {
  final String categoryType;
  final List categories;
  final Function onSelectedCategoryChanged;
  const FilterCategories({
    Key? key,
    required this.categories,
    required this.onSelectedCategoryChanged,
    required this.categoryType,
  }) : super(key: key);

  @override
  State<FilterCategories> createState() => _FilterCategoriesState();
}

class _FilterCategoriesState extends State<FilterCategories> {
  dynamic selectedMainCategory;

  @override
  void initState() {
    super.initState();
    if (widget.categories.length == 1) {
      setState(() {
        selectedMainCategory = widget.categories.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            spreadRadius: 1,
            color: Color(0xFFBEBEBE),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Text(
              widget.categoryType,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...widget.categories.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: SizedBox(
                      height: 50,
                      child: CategoryItem(
                        category: e.title,
                        isActive: selectedMainCategory != null &&
                            selectedMainCategory!.id == e.id,
                        onTap: () {
                          setState(() {
                            if (selectedMainCategory != null &&
                                selectedMainCategory.id == e.id) {
                              selectedMainCategory = null;
                            } else {
                              selectedMainCategory = e;
                            }
                          });
                          widget
                              .onSelectedCategoryChanged(selectedMainCategory);
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
