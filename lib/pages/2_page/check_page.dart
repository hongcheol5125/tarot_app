import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer_builder/timer_builder.dart';

import '../../routes/app_routes.dart';
import 'check_controller.dart';

class CheckPage extends GetWidget<CheckController> {
  const CheckPage({super.key});

  checkList() {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.nicknameController,
                      decoration: InputDecoration(hintText: '닉네임'),
                    ),
                  ),
                  controller.checkBox(),
                ],
              ),
              Text('생년월일 드롭다운'),
              Text('태어난 시각 드롭다운 + 체크박스'),
              ElevatedButton(
                onPressed: () {
                  if (controller.checkController.hasClients) {
                    controller.checkController.animateToPage(1,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                    controller.pageIndex.value = 1;
                  }
                },
                child: Text('NEXT!!'),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Get.offAllNamed(Routes.INITIAL_PAGE);
          },
          child: Text('restart!!'),
        ),
        SizedBox(height: 50)
      ],
    );
  }

  cardList() {
    return Column(
      children: [
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 150,
              width: 100,
              child: Image.asset('attachedfiles/tarotcard/대기카드.png'),
            ),
            SizedBox(
              height: 150,
              width: 100,
              child: Image.asset('attachedfiles/tarotcard/대기카드.png'),
            ),
            SizedBox(
              height: 150,
              width: 100,
              child: Image.asset('attachedfiles/tarotcard/대기카드.png'),
            ),
          ],
        ),
        SizedBox(height: 20),
        TimerBuilder.periodic(
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
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Get.toNamed(Routes.RESULT_PAGE);
          },
          child: Text('NEXT!!'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Obx(
            () => IconButton(
                onPressed: () {
                  if (controller.checkController.hasClients) {
                    if (controller.pageIndex.value == 1) {
                      controller.checkController.animateToPage(0,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut);
                      controller.pageIndex.value = 0;
                    }else{
                      Get.offAllNamed(Routes.INITIAL_PAGE);
                    }
                  }
                },
                icon: Icon(Icons.arrow_back),
                color: controller.pageIndex.value == 0
                    ? Colors.purple
                    : Colors.purpleAccent),
          ),
        ),
        body: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Obx(
                      () => GestureDetector(
                        onTap: () {
                          if (controller.checkController.hasClients) {
                            controller.checkController.animateToPage(0,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeInOut);
                            controller.pageIndex.value = 0;
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: controller.pageIndex.value == 0
                              ? const BoxDecoration(
                                  color: Colors.white,
                                )
                              : const BoxDecoration(color: Colors.grey),
                          alignment: Alignment.center,
                          child: Text(
                            'button1',
                            style: TextStyle(
                              color: controller.pageIndex.value == 0
                                  ? null
                                  : Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => GestureDetector(
                        onTap: () {
                          if (controller.checkController.hasClients) {
                            controller.checkController.animateToPage(1,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeInOut);
                            controller.pageIndex.value = 1;
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: controller.pageIndex.value == 1
                              ? const BoxDecoration(
                                  color: Colors.white,
                                )
                              : const BoxDecoration(color: Colors.grey),
                          alignment: Alignment.center,
                          child: Text(
                            'button2',
                            style: TextStyle(
                              color: controller.pageIndex.value == 1
                                  ? null
                                  : Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: controller.checkController,
                children: <Widget>[
                  checkList(),
                  cardList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
