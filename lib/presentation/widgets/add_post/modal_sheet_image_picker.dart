import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ModalSheetImagePicker extends StatefulWidget {
  final String hintText;
  const ModalSheetImagePicker({
    Key? key,
    required this.hintText,
  }) : super(key: key);

  @override
  State<ModalSheetImagePicker> createState() => _ModalSheetImagePickerState();
}

class _ModalSheetImagePickerState extends State<ModalSheetImagePicker> {
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
        child: const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            'Pick Images',
            style: TextStyle(
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
      var pickedImage = await _picker.pickMultiImage(
        maxHeight: 480,
        maxWidth: 600,
        imageQuality: 60,
      );
      if (pickedImage != null) {
        Navigator.pop(context);
      }
    } catch (e) {
      return null;
    }
  }
}
