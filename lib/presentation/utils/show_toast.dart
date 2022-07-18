import 'package:flutter/material.dart';

void showToast(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
      ),
      duration: const Duration(seconds: 1),
    ),
  );
}
