import 'package:flutter/material.dart';

import 'picked_post_image_item.dart';

class PostImages extends StatefulWidget {
  final List<dynamic> pickedImages;
  final List<dynamic> imagesAlreadyInProduct;
  final Function onStateChange;
  const PostImages({
    Key? key,
    required this.pickedImages,
    required this.imagesAlreadyInProduct,
    required this.onStateChange,
  }) : super(key: key);

  @override
  State<PostImages> createState() => _PostImagesState();
}

class _PostImagesState extends State<PostImages> {
  List<dynamic> imagesInDisplay = [];

  @override
  void initState() {
    super.initState();
    initImagesToDisplay();
  }

  void initImagesToDisplay() {
    setState(() {
      var builtImages = [
        ...buildImageWithUrls(),
        ...buildPickedImages(),
      ];
      imagesInDisplay = builtImages;
    });
  }

  @override
  Widget build(BuildContext context) {
    initImagesToDisplay();
    return imagesInDisplay.isNotEmpty ? SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imagesInDisplay.length,
        itemBuilder: (context, index) => PickedPostImageItem(
          imageFile: imagesInDisplay[index]["imageFile"],
          imageUrl: imagesInDisplay[index]["imageUrl"],
          onDeleteClicked: () {
            if (imagesInDisplay[index]["imageFile"] == null) {
              handleDeletingProductImage(index);
            } else {
              handleDeletingPickedImage(index);
            }
          },
        ),
      ),
    ) : Container();
  }

  List<Map<String, dynamic>> buildPickedImages() {
    return widget.pickedImages
        .map(
          (e) => {
            "imageFile": e.path,
            "imageUrl": null,
          },
        )
        .toList();
  }

  List<Map<String, dynamic>> buildImageWithUrls() {
    return widget.imagesAlreadyInProduct
        .map((e) => {
              "imageUrl": e,
              "imageFile": null,
            })
        .toList();
  }

  void handleDeletingPickedImage(int index) {
    widget.pickedImages.removeWhere(
        (element) => element.path == imagesInDisplay[index]["imageFile"]);
    handleChangingStateAndNotifyingParent();
  }

  void handleDeletingProductImage(int index) {
    widget.imagesAlreadyInProduct.removeWhere(
        (element) => element == imagesInDisplay[index]["imageUrl"]);
    handleChangingStateAndNotifyingParent();
  }

  void handleChangingStateAndNotifyingParent() {
    setState(() {
      imagesInDisplay = [
        ...buildImageWithUrls(),
        ...buildPickedImages(),
      ];
    });

    widget.onStateChange(buildImageWithUrls(), buildPickedImages());
  }
}
