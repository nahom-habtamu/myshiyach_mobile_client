import 'package:flutter/material.dart';

import '../home/category_item.dart';

class FilterCategories extends StatefulWidget {
  final String categoryType;
  final List categories;
  final Function onSelectedCategoryChanged;
  final dynamic initialSelectedCategory;
  const FilterCategories({
    Key? key,
    required this.categories,
    required this.onSelectedCategoryChanged,
    required this.categoryType,
    required this.initialSelectedCategory,
  }) : super(key: key);

  @override
  State<FilterCategories> createState() => _FilterCategoriesState();
}

class _FilterCategoriesState extends State<FilterCategories> {
  dynamic selectedCategory;

  @override
  void initState() {
    super.initState();
    if (widget.categories.length == 1) {
      setState(() {
        selectedCategory = widget.categories.first;
      });
    }
    if (widget.initialSelectedCategory != null) {
      selectedCategory = widget.initialSelectedCategory;
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
                        isActive: selectedCategory != null &&
                            selectedCategory!.id == e.id,
                        onTap: () {
                          setState(() {
                            if (selectedCategory != null &&
                                selectedCategory.id == e.id) {
                              selectedCategory = null;
                            } else {
                              selectedCategory = e;
                            }
                          });
                          widget.onSelectedCategoryChanged(selectedCategory);
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
