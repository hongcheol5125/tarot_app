import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:tarot_app/widget/banner_widget.dart';
import 'package:timer_builder/timer_builder.dart';

import '../../routes/app_routes.dart';
import 'result_controller.dart';

class ResultPage extends GetWidget<ResultController> {
  const ResultPage({super.key});

  delayedTime() {
    return Obx(
      () => Visibility(
        visible: controller.isVisibleTexts.value,
        replacement: Container(
          // 왜 안되지...?
          height: 25,
          width: 20,
          color: Color.fromRGBO(252, 199, 3, 1),
        ),
        child: TimerBuilder.periodic(
          Duration(seconds: 1),
          builder: (context) {
            // 한국 시간은 표준시간 + 9
            DateTime date = DateTime.now().add(Duration(hours: 9));
            return Text(
              '${date.year}.${date.month}.${date.day}  ${date.hour} : ${date.minute} : ${date.second}',
              style: TextStyle(fontSize: 20),
            );
          },
        ),
      ),
    );
  }

  delayedLuckyPoint() {
    return Obx(
      () => Visibility(
        visible: controller.isVisibleTexts.value,
        replacement: Container(
          // 왜 안되지...?
          height: 25,
          width: 20,
          color: Color.fromRGBO(252, 199, 3, 1),
        ),
        child: controller.isVisibleTexts.value
            ? Column(
                children: [
                  Text('나의 럭키포인트(Lucky Point)는 ${controller.luckyPoint}!!'),
                  Text(
                    '나의 행운 숫자 ${controller.lottoNumbers[0]}, ${controller.lottoNumbers[1]}, ${controller.lottoNumbers[2]}, ${controller.lottoNumbers[3]}, ${controller.lottoNumbers[4]}, ${controller.lottoNumbers[5]}',
                  ),
                ],
              )
            : Container(
                // 왜 안되지...?
                height: 20,
                width: 20,
                color: Colors.red,
              ),
      ),
    );
  }

  // delayedLuckyNumber() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Text(
  //         '나의 행운 숫자 ${controller.lottoNumbers[0]}, ${controller.lottoNumbers[1]}, ${controller.lottoNumbers[2]}, ${controller.lottoNumbers[3]}, ${controller.lottoNumbers[4]}, ${controller.lottoNumbers[5]}',
  //       ),
  //     ],
  //   );
  // }

  luckyPyramid() {
    return SizedBox(
      child: controller.luckyPoint <= 60
          ? Image.asset('attachedfiles/levelfile/g-1.gif')
          : controller.luckyPoint > 60 && controller.luckyPoint <= 70
              ? Image.asset('attachedfiles/levelfile/g-2.gif')
              : controller.luckyPoint > 70 && controller.luckyPoint <= 80
                  ? Image.asset('attachedfiles/levelfile/g-3.gif')
                  : controller.luckyPoint > 80 && controller.luckyPoint <= 90
                      ? Image.asset('attachedfiles/levelfile/g-4.gif')
                      : Image.asset('attachedfiles/levelfile/g-5.gif'),
    );
  }

  restartButton() {
    return Obx(
      () => Visibility(
        visible: controller.isVisibleButtons.value,
        child: controller.isVisibleButtons.value
            ? TextButton(
                onPressed: () {
                  Get.offAllNamed(Routes.INITIAL_PAGE);
                },
                child: Text('restart!!'),
              )
            : Container(
                // 왜 안되지...?
                height: 20,
                width: 20,
                color: Colors.red,
              ),
      ),
    );
  }

  luckyPageButtons() {
    return Obx(
      () => Visibility(
        visible: controller.isVisibleButtons.value,
        child: controller.isVisibleButtons.value
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.LUCKY_BOX_PAGE,
                          arguments: {'initialTab': 1});
                    },
                    child: Text('럭키인증'),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.LUCKY_BOX_PAGE,
                          arguments: {'initialTab': 0});
                    },
                    child: Text('럭키박스'),
                  ),
                ],
              )
            : Container(
                // 왜 안되지...?
                height: 20,
                width: 20,
                color: Colors.red,
              ),
      ),
    );
  }

  delayedAdMob() {
    return Obx(
      () => Visibility(
        visible: controller.isVisibleButtons.value,
        child: controller.isVisibleButtons.value
            ? BannerWidget()
            : Container(
                // 왜 안되지...?
                height: 20,
                width: 20,
                color: Colors.red,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 10초 있다가 뜨게 만듦
    Timer(
      controller.luckyPoint <= 60
          ? Duration(seconds: 8)
          : controller.luckyPoint > 60 && controller.luckyPoint <= 70
              ? Duration(seconds: 9)
              : controller.luckyPoint > 70 && controller.luckyPoint <= 80
                  ? Duration(seconds: 10)
                  : controller.luckyPoint > 80 && controller.luckyPoint <= 90
                      ? Duration(seconds: 11)
                      : Duration(seconds: 12),
      () {
        controller.showText();
      },
    );
    Timer(
      controller.luckyPoint <= 60
          ? Duration(seconds: 9)
          : controller.luckyPoint > 60 && controller.luckyPoint <= 70
              ? Duration(seconds: 10)
              : controller.luckyPoint > 70 && controller.luckyPoint <= 80
                  ? Duration(seconds: 11)
                  : controller.luckyPoint > 80 && controller.luckyPoint <= 90
                      ? Duration(seconds: 12)
                      : Duration(seconds: 13),
      () {
        controller.showButtons();
      },
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(252, 199, 3, 1),
        body: Column(
          children: [
            Screenshot(
              controller: controller.screenshotController,
              child: Column(
                children: [
                  SizedBox(height: 30),
                  delayedTime(),
                  delayedLuckyPoint(),
                  SizedBox(height: 15),
                  // delayedLuckyNumber(),
                  luckyPyramid(),
                  SizedBox(height: 20),
                ],
              ),
            ),
            restartButton(),
            luckyPageButtons(),
            SizedBox(height: 20),
            delayedAdMob(),
          ],
        ),
      ),
    );
  }
}
