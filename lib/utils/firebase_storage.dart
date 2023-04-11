// Dart imports:
import 'dart:developer';
import 'dart:io';

// Package imports:
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// Flutter imports:

// Project imports:

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(
    String filePath,
    String fileName,
    String folder,
  ) async {
    File file = File(filePath);
    try {
      await storage.ref('$folder/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      log(e.toString());
    }
  }

  Future<String>? getImage(String name) async {
    try {
      // firebase_storage.ListResult result =
      //     await storage.ref('FoodItemImages').listAll();
      // for (int i = 0; i < result.items.length; i++) {
      //   var imageName = result.items[i].name.toString().split(".")[0];
      //   imageName = imageName.toLowerCase();
      //   name = name.toLowerCase();
      //   if (imageName == name) {
      //     return await result.items[i].getDownloadURL();
      //   }
      // }
      firebase_storage.Reference stockImage =
          storage.ref().child('MarkerPics/$name');
      return await stockImage.getDownloadURL();
    } catch (e) {
      return "HTTP_ERROR";
    }
  }
}
