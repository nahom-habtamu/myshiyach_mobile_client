import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 17),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color(0xff11435E),
      elevation: 0,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 45);
}
