import 'package:get/get.dart';

import 'card_controller.dart';

class CardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CardController());
  }
}