import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalDataService extends GetxService {
  late GetStorage box;
  @override
  Future<void> onInit() async {
    super.onInit();
    await GetStorage.init();
    box = GetStorage();
  }

  Future<void> saveImage(Uint8List? imageFile) async {
    if (box.read('captureList') == null) {
      List<Uint8List> noCaptureData = [];
      noCaptureData.add(imageFile!);
      List<dynamic> encodedList =
          noCaptureData.map((data) => base64Encode(data)).toList();
      await box.write('captureList', encodedList);
    } else {
      List<dynamic> encodedList = box.read('captureList');
      List<Uint8List> dataList =
          encodedList.map((encodedData) => base64Decode(encodedData)).toList();
      dataList.add(imageFile!);
      List<dynamic> _encodedList =
          dataList.map((data) => base64Encode(data)).toList();
      await box.write('captureList', _encodedList);
    }
  }

  List<Uint8List> getImage() {
    // List<Uint8List> 이게 리턴이 되어야 해
    List<Uint8List> result;
    if (box.read('captureList') == null) {
      result = [];
    } else {
      List<dynamic> encodedList = box.read('captureList');
      List<Uint8List> dataList =
          encodedList.map((encodedData) => base64Decode(encodedData)).toList();

      result = dataList;
    }
    return result;
  }
}
