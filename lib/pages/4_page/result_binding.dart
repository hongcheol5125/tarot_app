import 'package:get/get.dart';

import 'result_controller.dart';

class ResultBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ResultController(localDataService: Get.find()));
  }
}
