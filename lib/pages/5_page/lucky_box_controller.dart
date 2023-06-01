import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LuckyBoxController extends GetxController {
  late PageController luckyController;
  late Rx<int> pageIndex;

  late int initialTab;
  
  @override
  void onInit() {
    super.onInit();
    initialTab = Get.arguments['initialTab'];
    pageIndex = Rx(initialTab);
    luckyController = PageController(initialPage: initialTab);
  }
}
