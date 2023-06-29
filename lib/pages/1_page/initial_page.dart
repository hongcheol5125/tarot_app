import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';  <== 정보 모두 삭제 버튼 사용 시 import할 것
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../routes/app_routes.dart';
import 'initial_controller.dart';

class InitialPage extends GetWidget<InitialController> {
  const InitialPage({super.key});

  // 
  initialTitle() {
    return Obx(
      () => Visibility(  // visible이 true일 때 Visibility 안의 것들이 보이게 된다.
        visible: controller.isVisible.value,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset('attachedfiles/initialpage/아이콘01.png')),
                SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset('attachedfiles/initialpage/아이콘02.png')),
                SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset('attachedfiles/initialpage/아이콘03.png')),
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
      ),
    );
  }

  startButton() {
    return ElevatedButton(
      onPressed: () {
        Get.toNamed(Routes.CHECK_PAGE, arguments: 0);
      },
      child: Text('START!!'),
    );
  }

  luckyButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.LUCKY_BOX_PAGE, arguments: {'initialTab': 1}); // 1은 럭키인증 신호
            },
            child: Text('럭키인증'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.LUCKY_BOX_PAGE, arguments: {'initialTab': 0}); // 0은 럭키박스 신호
            },
            child: Text('럭키상자'),
          ),

          /// 이 버튼은 getstorage에 저장된 데이터들을 모두 지우는 버튼 (럭키상자에 저장된 사진들 모두 삭제됨)
          //  ElevatedButton(
          //      onPressed: () {
          //        final box = GetStorage();
          //        box.erase();
          //      },
          //      child: Text('정보 모두 삭제'),),
        ],
      ),
    );
  }

  adMob(){
    return Obx(() {
            if (controller.bannerAd.value != null) {
              return Align(
                child: Container(
                  width: controller.bannerAd.value!.size.width.toDouble(),
                  height: controller.bannerAd.value!.size.height.toDouble(),
                  child: AdWidget(ad: controller.bannerAd.value!),
                ),
              );
            } else {
              return SizedBox(height: 10, width: 10);
            }
          });
  }
  
  @override
  Widget build(BuildContext context) {
    // 6초 지난 후 text들 보이게 설정
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
          initialTitle(),
          const SizedBox(height: 60),
          startButton(),
          luckyButtons(),
          const SizedBox(height: 15),
          adMob(),
        ],
      ),
    );
  }
}
