import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/birthday_list.dart';

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
}
