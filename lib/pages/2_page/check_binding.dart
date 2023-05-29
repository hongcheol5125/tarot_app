import 'package:get/get.dart';
import 'check_controller.dart';

class CheckBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CheckController());
  }
}