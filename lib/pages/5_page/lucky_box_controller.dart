import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LuckyBoxController extends GetxController {
  late PageController luckyController;
  late Rx<int> pageIndex;

  late int initialTab;
  final box = GetStorage();
  late List<Uint8List> captureData; 
  late int reverseIndex;

  
  @override
  void onInit() {
    super.onInit();
    initialTab = Get.arguments['initialTab'];
    // capture = Get.arguments['capture'];
    
    captureData = box.read('captureList') ?? [];
    print(captureData);
    pageIndex = Rx(initialTab);
    luckyController = PageController(initialPage: initialTab);
  }
}
