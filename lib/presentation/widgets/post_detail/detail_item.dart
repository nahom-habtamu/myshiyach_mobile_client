import 'package:flutter/material.dart';

class DetailItem extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final Function? onClick;
  final bool isCurved;
  final Color? color;
  const DetailItem({
    Key? key,
    required this.title,
    required this.subtitle,
    this.onClick,
    this.isCurved = false,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick == null ? () {} : onClick!(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: color ?? Colors.white,
            boxShadow: [
              BoxShadow(
                color:
                    onClick != null ? Colors.black38 : const Color(0xFFECE9E9),
                blurRadius: 1,
                spreadRadius: 1,
              )
            ],
            borderRadius: BorderRadius.circular(isCurved ? 15 : 0),
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
