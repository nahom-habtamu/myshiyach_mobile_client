import 'package:flutter/material.dart';

class PostDetailInformationItem extends StatelessWidget {
  final String informationKey;
  final String informationValue;
  const PostDetailInformationItem({
    Key? key,
    required this.informationKey,
    required this.informationValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          informationKey,
          style: const TextStyle(
            color: Color(0xff11435E),
            fontSize: 18,
            height: 1.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          informationValue,
          style: const TextStyle(
            color: Color(0xff434648),
            fontSize: 12,
            height: 2,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
