import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';  <== 정보 모두 삭제 버튼 사용 시 import할 것
import 'package:tarot_app/widget/banner_widget.dart';

import '../../routes/app_routes.dart';
import 'initial_controller.dart';

class InitialPage extends GetWidget<InitialController> {
  const InitialPage({super.key});

  //
  initialTitle() {
    return Obx(
      () => Visibility(
        // visible이 true일 때 Visibility 안의 것들이 보이게 된다.
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
                const Text(
                  '등 총 7가지의 운세!',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            const Text(
              '오늘! 지금!',
              style: TextStyle(fontSize: 20),
            ),
            const Text(
              '나의 럭키포인트(Lucky point)는??',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  startButton() {
    return TextButton(
      onPressed: () {
        Get.toNamed(Routes.CHECK_PAGE, arguments: 0);
      },
      child: const Text(
        'START!!',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  luckyButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {
            Get.toNamed(Routes.LUCKY_BOX_PAGE,
                arguments: {'initialTab': 1}); // 1은 럭키인증 신호
          },
          child: const Text('럭키인증'),
        ),
        TextButton(
          onPressed: () {
            Get.toNamed(Routes.LUCKY_BOX_PAGE,
                arguments: {'initialTab': 0}); // 0은 럭키박스 신호
          },
          child: const Text('럭키상자'),
        ),

        /// 이 버튼은 getstorage에 저장된 데이터들을 모두 지우는 버튼 (럭키상자에 저장된 사진들 모두 삭제됨)
        //  ElevatedButton(
        //      onPressed: () {
        //        final box = GetStorage();
        //        box.erase();
        //      },
        //      child: Text('정보 모두 삭제'),),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 6초 지난 후 text들 보이게 설정
    Timer(
      const Duration(seconds: 6),
      () {
        controller.showText();
      },
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(252, 199, 3, 1),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 400,
                width: 420,
                child: GetBuilder<InitialController>(
                builder: (_) => Chewie(
                  controller: controller.chewieController,
                ),
                      ),
              ),
              SizedBox(height: 20),
              initialTitle(),
              const SizedBox(height: 20),
              startButton(),
              luckyButtons(),
              const SizedBox(height: 15),
              BannerWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
