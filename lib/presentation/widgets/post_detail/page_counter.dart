import 'package:flutter/material.dart';

class PageCounter extends StatelessWidget {
  final int pageCount;
  final int currentPage;
  const PageCounter({
    Key? key,
    required this.pageCount,
    required this.currentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 15,
      left: 15,
      child: Container(
        height: 35,
        width: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(
              Icons.photo_camera_back_rounded,
              color: Colors.white,
            ),
            Text(
              '${currentPage + 1} / $pageCount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        decoration: const BoxDecoration(
          color: Color(0xB9000000),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );
  }
}
