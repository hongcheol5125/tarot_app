import 'package:get/get.dart';

import 'lucky_certification_controller.dart';

class LuckyCertificationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() =>LuckyCertificationController());
  }
}