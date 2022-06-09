import 'package:flutter/material.dart';

class SettingsItemHeader extends StatelessWidget {
  final String content;
  const SettingsItemHeader({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Text(
          content.toUpperCase(),
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 0.9,
          ),
        ),
      ),
    );
  }
}
