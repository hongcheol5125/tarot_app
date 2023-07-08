import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  final int duration;
  const SplashPage({required this.duration, super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late ChewieController _chewieController;
  late VideoPlayerController _videoPlayerController;
  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.asset('attachedfiles/lotifile/Char+Animation.mp4');
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      showControls: false,
    );
    Future.delayed( 
       Duration(seconds: widget.duration),
      () {
        Get.toNamed(Routes.INITIAL_PAGE);
      },
    );
    super.initState();
  }

   @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
 
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(252, 199, 3, 1),
        body: Center(
        child: Chewie(
          controller: _chewieController,
        ),)
    //     Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Image.asset('attachedfiles/lotifile/char_animation.gif'),
    //   ],
    // ),
    );
  }
}
