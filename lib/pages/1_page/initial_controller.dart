import 'package:get/state_manager.dart';

class InitialController extends GetxController {
  Rx<bool> isVisible = Rx(false);
showText() {
    isVisible.value = true;
  }
}