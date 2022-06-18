import 'package:flutter/material.dart';

import '../../../domain/enitites/main_category.dart';
import '../home/category_item.dart';

class FilterCategories extends StatefulWidget {
  final List<MainCategory> categories;
  final Function onSelectedCategoriesChanged;
  const FilterCategories({
    Key? key,
    required this.categories,
    required this.onSelectedCategoriesChanged,
  }) : super(key: key);

  @override
  State<FilterCategories> createState() => _FilterCategoriesState();
}

class _FilterCategoriesState extends State<FilterCategories> {
  List<MainCategory> selectedMainCategories = [];

  @override
  void initState() {
    super.initState();
    if (widget.categories.length == 1) {
      setState(() {
        selectedMainCategories = [...widget.categories];
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
          const Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: Text(
              'Categories',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Wrap(
            runAlignment: WrapAlignment.center,
            runSpacing: 15.0,
            spacing: 5,
            children: [
              ...widget.categories.map(
                (e) => SizedBox(
                  height: 50,
                  width: 120,
                  child: CategoryItem(
                    category: e.title,
                    isActive:
                        selectedMainCategories.any((cat) => cat.id == e.id),
                    onTap: () {
                      setState(() {
                        if (selectedMainCategories
                            .any((cat) => cat.id == e.id)) {
                          selectedMainCategories
                              .removeWhere((cat) => cat.id == e.id);
                        } else {
                          selectedMainCategories.add(e);
                        }
                      });
                      widget
                          .onSelectedCategoriesChanged(selectedMainCategories);
                    },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

