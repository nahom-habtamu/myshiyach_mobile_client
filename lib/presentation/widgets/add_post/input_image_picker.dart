import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerInput extends StatefulWidget {
  final Function onImagePicked;
  final String hintText;
  const ImagePickerInput({
    Key? key,
    required this.hintText,
    required this.onImagePicked,
  }) : super(key: key);

  @override
  State<ImagePickerInput> createState() => _ImagePickerInputState();
}

class _ImagePickerInputState extends State<ImagePickerInput> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await pickImage();
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white54,
          borderRadius: const BorderRadius.all(
            Radius.circular(16.0),
          ),
          border: Border.all(
            color: Colors.black26,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            widget.hintText,
            style: const TextStyle(
              color: Color.fromARGB(146, 0, 0, 0),
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  renderImagePicker(bool isCamera) {
    return MaterialButton(
      highlightColor: Colors.black87,
      splashColor: Colors.grey[200],
      onPressed: () async {
        await pickImage();
      },
      child: Row(
        children: [
          Icon(
            isCamera ? Icons.camera_alt : Icons.photo,
            size: 25,
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text(
              isCamera ? 'Camera' : 'Gallery',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          )
        ],
      ),
    );
  }

  pickImage() async {
    try {
      var pickedImages = await _picker.pickMultiImage(
        maxHeight: 480,
        maxWidth: 600,
        imageQuality: 60,
      );
      widget.onImagePicked(pickedImages);
    } catch (e) {
      return null;
    }
  }
}
