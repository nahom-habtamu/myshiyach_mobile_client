import 'dart:io';

import 'package:flutter/material.dart';

class PickedPostImageItem extends StatelessWidget {
  final String? imageFile;
  final String? imageUrl;
  final Function onDeleteClicked;
  const PickedPostImageItem({
    Key? key,
    this.imageFile,
    this.imageUrl,
    required this.onDeleteClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            height: 100,
            child: imageUrl == null
                ? Image.file(
                    File(imageFile!),
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
            right: 5,
            top: 5,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.black54,
              child: IconButton(
                onPressed: () {
                  onDeleteClicked();
                },
                icon: const Icon(
                  Icons.close,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
