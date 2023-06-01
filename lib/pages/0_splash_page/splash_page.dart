import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  final int duration;
  const SplashPage({required this.duration, super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed( 
       Duration(seconds: widget.duration),
      () {
        Get.toNamed(Routes.INITIAL_PAGE);
      },
    );
    super.initState();
  }
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('attachedfiles/lotifile/char_animation.gif'),
      ],
    ));
  }
}
