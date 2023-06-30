import 'package:get/state_manager.dart';

class InitialController extends GetxController {
  Rx<bool> isVisible = Rx(false);

  showText() {
    isVisible.value = true;
  }

  ///Rx변수는 dispose를 사용 할 수 없다.
  ///void dispose() {
  ///bannerAd?.dispose();
  ///super.dispose();
  ///}
}
