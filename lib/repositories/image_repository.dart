import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class ImageRepository extends GetxService {
  // 이렇게 써도 되는지 확인!!!!
  final Reference _storageReference = FirebaseStorage.instance.ref('images');


  Future<String?> uploadImage(File? imageFile,
      {required String fileName}) async {
    try {
      Reference storageReference = _storageReference.child(fileName);
      UploadTask uploadTask = storageReference.putFile(imageFile!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      print(imageUrl);
      return imageUrl;
    } catch (e) {
      print('Image upload failed: $e');
      return null;
    }
  }
}
