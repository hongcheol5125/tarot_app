import 'package:chewie/chewie.dart';
import 'package:get/state_manager.dart';
import 'package:video_player/video_player.dart';

class InitialController extends GetxController {
  Rx<bool> isVisible = Rx(false);
   late ChewieController chewieController;

  @override
  void onInit(){
    super.onInit();
  final videoPlayerController = VideoPlayerController.asset('attachedfiles/lotifile/Logo+Animation.mp4');
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoInitialize: true,
      autoPlay: true,
      showControls: false,
      looping: true,
    );
  }

  @override
  void onClose() {
    chewieController.dispose();
    super.onClose();
  }

  showText() {
    isVisible.value = true;
  }

  ///Rx변수는 dispose를 사용 할 수 없다.
  ///void dispose() {
  ///bannerAd?.dispose();
  ///super.dispose();
  ///}
}
