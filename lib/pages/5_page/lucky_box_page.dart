import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import 'lucky_box_controller.dart';

class LuckyBoxPage extends GetWidget<LuckyBoxController> {
  const LuckyBoxPage({super.key});

  luckyBox() {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: controller.captureData.length,
            itemBuilder: (context, index) {
              final reversedIndex = controller.captureData.length - 1 - index;
              final captureButton = controller.captureData[reversedIndex];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.black,
                  )),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('팝업 창'),
                            content: Image.memory(captureButton),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('내 앨범에 저장!'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('닫기'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Image.memory(captureButton),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 30),
        ElevatedButton(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size(150, 150)), // 최소 크기 설정
            padding: MaterialStateProperty.all(EdgeInsets.all(10)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // 테두리 모양 설정
      ),
    ),
          ),
          onPressed: () {
            Get.offAllNamed(Routes.INITIAL_PAGE);
          },
          child: Text('restart!!'),
        ),
        SizedBox(height: 70)
      ],
    );
  }

  luckyCertification() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('인증글 쓰기'),
                ),
                SizedBox(width: 20)
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            color: Colors.red,
            height: 400,
            width: 325,
            child: Text('게시판'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              onPressed: () {
                Get.offAllNamed(Routes.INITIAL_PAGE);
              },
              child: Text('restart!!'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(
                    () => ElevatedButton(
                      onPressed: () {
                        if (controller.luckyController.hasClients) {
                          controller.luckyController.animateToPage(0,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut);
                          controller.pageIndex.value = 0;
                        }
                      },
                      child: Text('럭키상자'),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(100, 50),
                          backgroundColor: controller.pageIndex.value == 0
                              ? Colors.blue
                              : Colors.grey),
                    ),
                  ),
                  Obx(
                    () => ElevatedButton(
                      onPressed: () {
                        if (controller.luckyController.hasClients) {
                          controller.luckyController.animateToPage(1,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut);
                          controller.pageIndex.value = 1;
                        }
                      },
                      child: Text('럭키인증'),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(100, 50),
                          backgroundColor: controller.pageIndex.value == 1
                              ? Colors.blue
                              : Colors.grey),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: PageView(
                  controller: controller.luckyController,
                  children: <Widget>[
                    luckyBox(),
                    luckyCertification(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
