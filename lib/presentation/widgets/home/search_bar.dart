import 'package:flutter/material.dart';

import '../../../domain/enitites/main_category.dart';
import '../../pages/filter_data_page.dart';

class SearchBar extends StatelessWidget {
  final List<MainCategory> categories;
  const SearchBar({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.73,
            child: TextFormField(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              onChanged: (value) => {},
              decoration: const InputDecoration(
                labelText: "Search Item",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.black26,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.black26,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.black26,
                    width: 1,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 30,
                ),
                isDense: true,
                contentPadding: EdgeInsets.all(15),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  FilterDataPage.routeName,
                  arguments: categories,
                );
              },
              icon: const Icon(Icons.filter),
            ),
          )
        ],
      ),
    );
  }
}
