import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/birthday_list.dart';
import '../../utils/tarotcard_imgs.dart';

class CheckController extends GetxController {
  TextEditingController nicknameController = TextEditingController();
  late int initialTab;
  late Rx<int> pageIndex;
  late PageController checkController;
  Rx<bool?> isCheckedNickName = Rx(false);
  Rx<bool?> isCheckedHour = Rx(false);
  Rx<String> dropdownYear = Rx(years.first);
  Rx<String> dropdownMonth = Rx(months.first);
  Rx<String> dropdownDay = Rx(days.first);
  Rx<String> dropdownHour = Rx(hours.first);
  Rx<String> dropdownMinute = Rx(minutes.first);
  // ----------구분선(위:인적사항 / 아래:타로카드)---------------
  Rx<String> imagePath1 = Rx('attachedfiles/tarotcard/대기카드.png');
  Rx<String> imagePath2 = Rx('attachedfiles/tarotcard/대기카드.png');
  Rx<String> imagePath3 = Rx('attachedfiles/tarotcard/대기카드.png');
  

  @override
  void onInit() {
    super.onInit();
    initialTab = Get.arguments;
    pageIndex = Rx(initialTab);
    checkController = PageController(initialPage: initialTab);
  }

  onChangedCheckNickName(value) {
    isCheckedNickName.value = value;
  }

  onChangedCheckHour(value) {
    isCheckedHour.value = value;
  }

  onChangedDropdownYear(value) {
    dropdownYear.value = value;
  }

  onChangedDropdownMonth(value) {
    dropdownMonth.value = value;
  }

  onChangedDropdownDay(value) {
    dropdownDay.value = value;
  }

  onChangedDropdownHour(value) {
    dropdownHour.value = value;
  }

  onChangedDropdownMinute(value) {
    dropdownMinute.value = value;
  }

  void changeImage1() {
    Random random = Random();
    int randomIndex = random.nextInt(images.length);
    imagePath1.value = images[randomIndex];
  }
  void changeImage2() {
    Random random = Random();
    int randomIndex = random.nextInt(images.length);
    imagePath2.value = images[randomIndex];
  }
  void changeImage3() {
    Random random = Random();
    int randomIndex = random.nextInt(images.length);
    imagePath3.value = images[randomIndex];
  }
}
