import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../routes/app_routes.dart';
import 'initial_controller.dart';

class InitialPage extends GetWidget<InitialController> {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 6),
      () {
        controller.showText();
      },
    );
    return Scaffold(
      body: Column(
        children: [
          Image.asset('attachedfiles/lotifile/logo_animation.gif'),
          Obx(() => Visibility(
            visible: controller.isVisible.value,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 50,
                        width: 50,
                        child:
                            Image.asset('attachedfiles/initialpage/아이콘01.png')),
                    SizedBox(
                        height: 50,
                        width: 50,
                        child:
                            Image.asset('attachedfiles/initialpage/아이콘02.png')),
                    SizedBox(
                        height: 50,
                        width: 50,
                        child:
                            Image.asset('attachedfiles/initialpage/아이콘03.png')),
                    Text(
                      '등 총 7가지의 운세!',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Text(
                  '오늘! 지금!',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '나의 럭키포인트(Lucky point)는??',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          )),
          SizedBox(
            height: 60,
          ),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.CHECK_PAGE, arguments: 0);
            },
            child: Text('START!!'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.LUCKY_BOX_PAGE,
                        arguments: {'initialTab': 1});
                  },
                  child: Text('럭키인증'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.LUCKY_BOX_PAGE,
                        arguments: {'initialTab': 0});
                  },
                  child: Text('럭키상자'),
                ),
                ElevatedButton(onPressed: (){
                  final box = GetStorage();
                  box.erase();
                }, child: Text('정보 모두 삭제'))
              ],
            ),
          )
        ],
      ),
    );
  }
}
