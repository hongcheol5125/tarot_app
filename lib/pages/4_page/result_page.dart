import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer_builder/timer_builder.dart';

import '../../routes/app_routes.dart';
import 'result_controller.dart';

class ResultPage extends GetWidget<ResultController> {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              TimerBuilder.periodic(
                Duration(seconds: 1),
                builder: (context) => Text(
                  '${DateTime.now().year}.${DateTime.now().month}.${DateTime.now().day}  ${DateTime.now().hour} : ${DateTime.now().minute} : ${DateTime.now().second}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Text('나의 럭키포인트(Lucky Point)는 XX!!'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('텍스트(나의 행운 숫자) + 1~45 중 랜덤숫자 6개'),
                ],
              ),
              SizedBox(
                child: Image.asset('attachedfiles/levelfile/g-1.gif'),
              ),
              ElevatedButton(
            onPressed: () {
              Get.offAllNamed(Routes.INITIAL_PAGE);
            },
            child: Text('restart!!'),
          ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.LUCKY_CERTIFICATION_PAGE);
            },
            child: Text('럭키인증'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.LUCKY_BOX_PAGE);
            },
            child: Text('럭키박스'),
          ),
            ],
          )
            ],
          ),
        ),
      ),
    );
  }
}
