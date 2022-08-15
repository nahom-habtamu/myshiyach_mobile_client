import 'package:flutter/material.dart';

class DetailItem extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final Function onClick;
  const DetailItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0xFFECE9E9),
                blurRadius: 1,
                spreadRadius: 1,
              )
            ],
          ),
          child: ListTile(
            subtitle: subtitle,
            title: title,
          ),
        ),
      ),
    );
  }
}
