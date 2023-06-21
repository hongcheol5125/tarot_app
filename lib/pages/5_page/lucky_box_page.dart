import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarot_app/utils/image_selector.dart';

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
              // childAspectRatio: 1
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
                                  // Uint8List 타입을 저장
                                  controller.saveImageToGallery(captureButton);
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

  luckyCertification(BuildContext context) {
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    TextField(
                                      onChanged: (value) => controller
                                          .post.value.nickName = value,
                                      decoration: InputDecoration(
                                        labelText: '닉네임',
                                      ),
                                    ),
                                    TextField(
                                      onChanged: (value) =>
                                          controller.post.value.title = value,
                                      decoration: InputDecoration(
                                        labelText: '제목',
                                      ),
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) => controller
                                          .post.value.password = value,
                                      decoration: InputDecoration(
                                        labelText: '비밀번호(4자리)',
                                      ),
                                    ),
                                    Obx(() => controller.selectedImage.value ==
                                            null
                                        ? Text('이미지를 선택하세요')
                                        : Image.file(
                                            controller.selectedImage.value!)),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text('이미지 선택'),
                                  onPressed: () async {
                                    File? file =
                                        await MediaPicker.singlePhoto();
                                    if (file != null) {
                                      controller.selectedImage.value = file;

                                      setState(() {});
                                    }
                                  },
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await controller.uploadImage(
                                        controller.selectedImage.value!);
                                    controller.createData(context);

                                    setState(() {});
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('완료'),
                                ),
                                TextButton(
                                  child: Text('취소'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Text('인증글 쓰기'),
                ),
                SizedBox(width: 20)
              ],
            ),
          ),
          SizedBox(height: 10),
          Obx(
            () => Expanded(
              child: ListView.builder(
                itemCount: controller.documents.value.length,
                itemBuilder: (context, index) {
                  final sequentialNumber = index + 1;
                  final titleText = '$sequentialNumber. ';
                  DocumentSnapshot document = controller.documents.value[index];
                  String title = document['title'] as String;
                  String nickname = document['nickname'] as String;
                  int date = int.parse(document['date']);
                  String realDate = DateTime.fromMillisecondsSinceEpoch(date)
                      .toUtc()
                      .toString();
                  String removeMinority = realDate.replaceRange(
                      realDate.length - 5, realDate.length, '');
                  final realRealDate = removeMinority;
                  String img_url = document['img_url'] as String;

                  return TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(title),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nickname: $nickname'),
                                Text('Date: $realRealDate'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showDialog(context: context, builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Image.network(img_url),
                                          );
                                        });
                                      },
                                      icon: Container(
                                        width: 200,
                                        height: 100,
                                        child: Image.network(img_url),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('수정'),
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
                    child: ListTile(
                      key: ValueKey(index),
                      title: Row(
                        children: [
                          Text(titleText),
                          Text(title),
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: Image.network(img_url),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(nickname),
                          Text(realRealDate),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
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
                    luckyCertification(context),
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
