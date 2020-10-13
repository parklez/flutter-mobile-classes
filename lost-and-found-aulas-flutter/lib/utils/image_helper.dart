import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageHelper {
  static Future<File> getImageFromCamera({int imageQuality = 70}) async {
    return await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: imageQuality);
  }

  static Future<File> getImageFromGallery({int imageQuality = 70}) async {
    return await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: imageQuality);
  }
}
