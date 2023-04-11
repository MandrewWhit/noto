import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImageWrapper extends StatefulWidget {
  ImageWrapper({Key? key, required this.path}) : super(key: key);

  String path;

  @override
  State<ImageWrapper> createState() => _ImageWrapperState();
}

class _ImageWrapperState extends State<ImageWrapper> {
  XFile? widgetImage;
  bool notSet = true;

  @override
  Widget build(BuildContext context) {
    if (notSet) {
      return GestureDetector(child: Image.asset(widget.path), onTap: pickImage);
    }
    // return GestureDetector(
    //     child: Image.file(File(widgetImage!.path)), onTap: pickImage);
    return GestureDetector(
      onTap: pickImage,
      child: ExtendedImage.file(
        File(widget.path),
        fit: BoxFit.contain,
        cacheHeight: 150,
        cacheWidth: 200,
      ),
    );
  }

  Future pickImage() async {
    try {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = XFile(image.path);
      notSet = false;
      setState(() {
        widgetImage = imageTemp;
        widget.path = imageTemp.path;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
