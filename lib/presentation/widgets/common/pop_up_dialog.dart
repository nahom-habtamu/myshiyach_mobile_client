import 'package:flutter/material.dart';

class PopupDialog extends StatelessWidget {
  final String content;
  const PopupDialog({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirm"),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            "CONFIRM",
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("CANCEL"),
        ),
      ],
    );
  }
}
