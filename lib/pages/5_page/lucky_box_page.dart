import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarot_app/model/post.dart';
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
                                      controller: controller.nicknameC,
                                      decoration: InputDecoration(
                                        labelText: '닉네임',
                                      ),
                                    ),
                                    TextField(
                                      controller: controller.titleC,
                                      decoration: InputDecoration(
                                        labelText: '제목',
                                      ),
                                    ),
                                    TextField(
                                      controller: controller.pwC,
                                      keyboardType: TextInputType.number,
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
                                    if (controller.selectedImage.value ==
                                        null) {
                                      Get.snackbar('이미지', '이미지를 선택해 주세요.');
                                    } else {
                                      await controller
                                          .onPressedUploadButton(context);

                                      setState(() {});
                                      Navigator.of(context).pop();
                                    }
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Top 5',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),

          //view 수에 따른 Listview 하나 더 만들어
          Obx(
            () => Expanded(
              child: RefreshIndicator(
                // 스크롤을 맨 상단으로 올려 refresh 하는 기능
                onRefresh: () => controller.initTopFiveView(),
                child: ListView.builder(
                  itemCount: controller.documentsForTopFiveView.value.length,
                  itemBuilder: (context, index) {
                    final sequentialNumber = index + 1;
                    final titleText = '$sequentialNumber. ';
                    DocumentSnapshot documentsForTopFiveView =
                        controller.documentsForTopFiveView.value[index];
                    var json = documentsForTopFiveView.data() as Map<String,
                        dynamic>; // firestore에 저장된 데이터들을 가져와서 json이라는 변수에 담음
                    Post post = Post.fromJson(json);

                    String title = post.title;
                    String nickName = post.nickName;
                    int date = post.date;
                    DateTime _date = DateTime.fromMillisecondsSinceEpoch(date);
                    String showDate =
                        '${_date.year}년${_date.month}월${_date.day}일 ${_date.hour}:${_date.minute}';

                    String imgUrl = post.images[
                        0]; // TODO: images에 여러개의 사진이 들어가면 수정 필요함. 현재는 1개의 이미지만 첨부된다는 전제 하에 진행했음
                    return TextButton(
                      onPressed: () {
                        controller.incrementViewCount(post.date.toString());
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(title),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Nickname: ${nickName.substring(0, 1)}**'),
                                  Text('Date: $showDate'),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Image.network(imgUrl),
                                                );
                                              });
                                        },
                                        icon: Container(
                                          width: 200,
                                          height: 100,
                                          child: Image.network(imgUrl),
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
                              child: Image.network(imgUrl),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${nickName.substring(0, 1)}**'),
                            Text(showDate),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '최신순',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),

          // 최신순 게시물 목록
          Obx(
            () => Expanded(
              child: RefreshIndicator(
                // 스크롤을 맨 상단으로 올려 refresh 하는 기능
                onRefresh: () => controller.loadMoreNew(),
                child: ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.documents.value.length,
                  itemBuilder: (context, index) {
                    final sequentialNumber = index + 1;
                    final titleText = '$sequentialNumber. ';
                    DocumentSnapshot document =
                        controller.documents.value[index];
                    var json = document.data() as Map<String,
                        dynamic>; // firestore에 저장된 데이터들을 가져와서 json이라는 변수에 담음
                    Post post = Post.fromJson(json);

                    String title = post.title;
                    String password = post.password;
                    String nickName = post.nickName;
                    int date = post.date;
                    DateTime _date = DateTime.fromMillisecondsSinceEpoch(date);
                    String showDate =
                        '${_date.year}년${_date.month}월${_date.day}일 ${_date.hour}:${_date.minute}';

                    String imgUrl = post.images[
                        0]; // TODO: images에 여러개의 사진이 들어가면 수정 필요함. 현재는 1개의 이미지만 첨부된다는 전제 하에 진행했음
                    controller.listenScroll(); // 기존 데이터 불러오기 메소드
                    return TextButton(
                      onPressed: () {
                        controller.incrementViewCount(post.date.toString());
                        // post.views ++;
                        // print(post.views);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(title),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Nickname: ${nickName.substring(0, 1)}**'),
                                  Text('Date: $showDate'),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Image.network(imgUrl),
                                              );
                                            },
                                          );
                                        },
                                        icon: Container(
                                          width: 200,
                                          height: 100,
                                          child: Image.network(imgUrl),
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
                              child: Image.network(imgUrl),
                            ),
                            SizedBox(width: 150),

                            // 수정 버튼
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String newTitle = title; // 기존 데이터 초기값으로 설정
                                    String newNickName = nickName;
                                    String checkPassword = password;
                                    // 추가로 수정할 필드들을 선언하고 초기값 설정

                                    return StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        return AlertDialog(
                                          title: Text('수정'),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextField(
                                                  onChanged: (value) {
                                                    setState(() {
                                                      newTitle = value;
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                    labelText: '제목',
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  child: TextField(
                                                    onChanged: (value) {
                                                      setState(() {
                                                        newNickName = value;
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: '닉네임',
                                                    ),
                                                  ),
                                                ),
                                                Obx(() => controller
                                                            .selectedImage
                                                            .value ==
                                                        null
                                                    ? Text('이미지를 선택하세요')
                                                    : Image.file(controller
                                                        .selectedImage.value!)),
                                                TextField(
                                                  onChanged: (value) {
                                                    setState(() {
                                                      checkPassword = value;
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                    labelText: '비밀번호',
                                                  ),
                                                ),
                                                // 추가로 수정할 필드들을 TextField로 추가
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text('이미지 선택'),
                                              onPressed: () async {
                                                File? file = await MediaPicker
                                                    .singlePhoto();
                                                if (file != null) {
                                                  controller.selectedImage
                                                      .value = file;

                                                  setState(() {});
                                                }
                                              },
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (newTitle != '' && newNickName != '' && checkPassword == //여기서 newTitle, newnickName에 대해 써봤자이다
                                                    post.password && controller.selectedImage
                                                      .value != null) {
                                                  // 비밀번호가 일치하면 수정을 진행
                                                  // 수정한 데이터를 Firestore에 업데이트
                                                  final newData = {
                                                    'title': newTitle,
                                                    'nickName': newNickName,
                                                    'images': [
                                                      controller
                                                          .selectedImage.value.toString()
                                                    ],
                                                  };
                                                  controller
                                                      .updatePostData(
                                                          post.date.toString(),
                                                          newData)
                                                      .then((_) {
                                                    Navigator.of(context).pop();
                                                  }).catchError((error) {
                                                    print(
                                                        'Failed to update post: $error');
                                                  });
                                                } else {
                                                  // 비밀번호가 일치하지 않으면 에러 메시지 표시
                                                  // if(title == ''){
                                                  //     Get.snackbar('제목', '제목을 입력하세요');
                                                  //   }else if(nickName == ''){
                                                  //      Get.snackbar('닉네임', '닉네임을 입력하세요');
                                                  //   }else
                                                     if(controller.selectedImage
                                                      .value != null) {
                                                      Get.snackbar('이미지', '이미지를 선택하세요');
                                                    }else{
                                                      Get.snackbar('비밀번호', '비밀번호가 일치하지 않습니다');
                                                    }
                                                  // checkPassword !=
                                                  //   post.password
                                                  // showDialog(
                                                  //   context: context,
                                                  //   builder:
                                                  //       (BuildContext context) {
                                                  //     return AlertDialog(
                                                  //       title: Text('오류'),
                                                  //       content: Text(
                                                  //           '비밀번호가 일치하지 않습니다.'),
                                                  //       actions: [
                                                  //         TextButton(
                                                  //           onPressed: () {
                                                  //             Navigator.of(
                                                  //                     context)
                                                  //                 .pop();
                                                  //           },
                                                  //           child: Text('닫기'),
                                                  //         ),
                                                  //       ],
                                                  //     );
                                                  //   },
                                                  // );
                                                }
                                              },
                                              child: Text('저장'),
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
                                );
                              },
                              child: Text('수정'),
                            )
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${nickName.substring(0, 1)}**'),
                            Text(showDate),
                          ],
                        ),
                      ),
                    );
                  },
                ),
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
