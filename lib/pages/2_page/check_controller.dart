import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckController extends GetxController {
PageController checkController = PageController();
late Rx<int> pageIndex;
late int initialTab;

@override
  void onInit() {
    super.onInit();
    initialTab = Get.arguments;
    pageIndex = Rx(initialTab);
    checkController = PageController(initialPage: initialTab);
  }
}