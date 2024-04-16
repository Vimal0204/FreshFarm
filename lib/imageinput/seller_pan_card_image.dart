import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickedImage});
  final void Function(File image) onPickedImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? selectedImage;
  void _takePicture() async {
    final imagepicker = ImagePicker();
    final pickedimage =
        await imagepicker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (pickedimage == null) {
      return;
    }
    setState(() {
      selectedImage = File(pickedimage.path);
    });
    widget.onPickedImage(selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Expanded(
      // child: TextButton.icon(
      //   onPressed: _takePicture,
      //   icon: const Icon(Icons.camera),
      //   // icon:  Image.asset("assets/images/pancardMode.jpg",fit: BoxFit.cover,),
      //   label: const Text('Take Picture like mentioned'),
      // ),
      child: Column(
        children: [
          const Text(
            "Take Picture like mentioned in the preview",
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          IconButton(
            onPressed: _takePicture,
            icon: Image.asset(
              "assets/images/pancardMode.jpg",
              width: double.infinity,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Icon(Icons.camera),
        ],
      ),
    );

    if (selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
        ),
      ),
      height: 320,
      width: double.infinity,
      child: content,
    );
  }
}
