import 'dart:io';

import 'package:image_picker/image_picker.dart';

class MediaPicker {
  static final ImagePicker _picker = ImagePicker();
  static Future<File?> singlePhoto() async {
    File? result;
    try {
      XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: null,
        maxHeight: null,
        imageQuality: null,
      );
      result = pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      print(e);
    }
    return result;
  }
}
