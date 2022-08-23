import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String category;
  final Function onTap;
  final bool isActive;
  const CategoryItem({
    Key? key,
    required this.category,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          height: 32,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 3,
            ),
            child: Center(
              child: Text(
                category,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey,
                ),
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xff11435E) : null,
            border:
                !isActive ? Border.all(color: const Color(0xFF686666)) : null,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
