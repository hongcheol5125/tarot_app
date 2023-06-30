import 'package:get/get.dart';

import 'lucky_box_controller.dart';

class LuckyBoxBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LuckyBoxController(localDataService: Get.find()));
  }
}
