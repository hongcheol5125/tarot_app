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
        visible: controller.isVisible.value,
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
        visible: controller.isVisible.value,
        child: controller.isVisible.value
            ? Text('나의 럭키포인트(Lucky Point)는 ${controller.luckyPoint}!!')
            : Container(
                // 왜 안되지...?
                height: 20,
                width: 20,
                color: Colors.red,
              ),
      ),
    );
  }

  delayedLuckyNumber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            '나의 행운 숫자 ${controller.lottoNumbers[0]}, ${controller.lottoNumbers[1]}, ${controller.lottoNumbers[2]}, ${controller.lottoNumbers[3]}, ${controller.lottoNumbers[4]}, ${controller.lottoNumbers[5]}'),
      ],
    );
  }

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
    return ElevatedButton(
      onPressed: () {
        controller.isButtonDisabled.value
            ? null
            : Get.offAllNamed(Routes.INITIAL_PAGE);
      },
      child: Text('restart!!'),
    );
  }

  luckyPageButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            controller.isButtonDisabled.value
                ? null
                : Get.toNamed(Routes.LUCKY_BOX_PAGE,
                    arguments: {'initialTab': 1});
          },
          child: Text('럭키인증'),
        ),
        ElevatedButton(
          onPressed: () {
            controller.isButtonDisabled.value
                ? null
                : Get.toNamed(Routes.LUCKY_BOX_PAGE,
                    arguments: {'initialTab': 0});
          },
          child: Text('럭키박스'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // 10초 있다가 뜨게 만듦
    Timer(
      Duration(seconds: 10),
      () {
        controller.showText();
      },
    );
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Screenshot(
              controller: controller.screenshotController,
              child: Column(
                children: [
                  delayedTime(),
                  delayedLuckyPoint(),
                  delayedLuckyNumber(),
                  luckyPyramid(),
                ],
              ),
            ),
            restartButton(),
            luckyPageButtons(),
            SizedBox(height: 50),
            BannerWidget(),
          ],
        ),
      ),
    );
  }
}
