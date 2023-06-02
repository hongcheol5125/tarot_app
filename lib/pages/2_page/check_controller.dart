// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CheckController extends GetxController {
// PageController checkController = PageController();
// late Rx<int> pageIndex;
// late int initialTab;

// @override
//   void onInit() {
//     super.onInit();
//     initialTab = Get.arguments;
//     pageIndex = Rx(initialTab);
//     checkController = PageController(initialPage: initialTab);
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckController extends GetxController {
  TextEditingController nicknameController = TextEditingController();
  late PageController checkController;
  late Rx<int> pageIndex;
  bool? isChecked = false;

  late int initialTab;

  @override
  void onInit() {
    super.onInit();
    initialTab = Get.arguments;
    pageIndex = Rx(initialTab);
    checkController = PageController(initialPage: initialTab);
  }

  checkBox() {
    return Transform.scale(
      scale: 1.5,
      child: Checkbox(
        activeColor: Colors.white,
        checkColor: Colors.red,
        value: isChecked,
        onChanged: (value) {
          // ignore: unused_element
          setState(){
            isChecked = value;
          }
        },
      ),
    );
  }
}
