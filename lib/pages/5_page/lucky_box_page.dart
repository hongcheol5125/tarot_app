import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarot_app/model/post.dart';
import 'package:tarot_app/utils/image_selector.dart';
import 'package:tarot_app/widget/banner_widget.dart';

import '../../routes/app_routes.dart';
import 'lucky_box_controller.dart';

class LuckyBoxPage extends GetWidget<LuckyBoxController> {
  const LuckyBoxPage({super.key});

  boxButton() {
    return Obx(
      () => ElevatedButton(
        onPressed: () {
          if (controller.luckyController.hasClients) {
            controller.luckyController.animateToPage(0,
                duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
            controller.pageIndex.value = 0;
          }
        },
        child: Text('럭키상자'),
        style: ElevatedButton.styleFrom(
            minimumSize: Size(100, 50),
            backgroundColor: controller.pageIndex.value == 0
                ? Color.fromRGBO(252, 199, 3, 1)
                : Colors.grey),
      ),
    );
  }

  certificationButton() {
    return Obx(
      () => ElevatedButton(
        onPressed: () {
          if (controller.luckyController.hasClients) {
            controller.luckyController.animateToPage(1,
                duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
            controller.pageIndex.value = 1;
          }
        },
        child: Text('럭키인증'),
        style: ElevatedButton.styleFrom(
            minimumSize: Size(100, 50),
            backgroundColor: controller.pageIndex.value == 1
                ? Color.fromRGBO(252, 199, 3, 1)
                : Colors.grey),
      ),
    );
  }

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
        SizedBox(height: 20),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromRGBO(252, 180, 3, 1)),
            minimumSize: MaterialStateProperty.all(Size(100, 100)), // 최소 크기 설정
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
        SizedBox(height: 20)
      ],
    );
  }

  luckyCertification(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(252, 180, 3, 1),
                  )),
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
                                    Obx(() => controller.selectedImage1.value ==
                                            null
                                        ? IconButton(
                                            onPressed: () async {
                                              File? file = await MediaPicker
                                                  .singlePhoto();
                                              if (file != null) {
                                                controller.selectedImage1
                                                    .value = file;
                                                setState(() {});
                                              }
                                            },
                                            icon: Icon(
                                                Icons.photo_album_outlined))
                                        : Image.file(
                                            controller.selectedImage1.value!)),
                                    Obx(() => controller.selectedImage2.value ==
                                            null
                                        ? IconButton(
                                            onPressed: () async {
                                              File? file = await MediaPicker
                                                  .singlePhoto();
                                              if (file != null) {
                                                controller.selectedImage2
                                                    .value = file;
                                                setState(() {});
                                              }
                                            },
                                            icon: Icon(
                                                Icons.photo_album_outlined))
                                        : Image.file(
                                            controller.selectedImage2.value!)),
                                    Obx(() => controller.selectedImage3.value ==
                                            null
                                        ? IconButton(
                                            onPressed: () async {
                                              File? file = await MediaPicker
                                                  .singlePhoto();
                                              if (file != null) {
                                                controller.selectedImage3
                                                    .value = file;
                                                setState(() {});
                                              }
                                            },
                                            icon: Icon(
                                                Icons.photo_album_outlined))
                                        : Image.file(
                                            controller.selectedImage3.value!)),
                                  ],
                                ),
                              ),
                              actions: [
                                // TextButton(
                                //   child: Text('이미지 선택'),
                                //   onPressed: () async {
                                //     File? file =
                                //         await MediaPicker.singlePhoto();
                                //     if (file != null) {
                                //       controller.selectedImage1.value = file;

                                //       setState(() {});
                                //     }
                                //   },
                                // ),
                                TextButton(
                                  onPressed: () async {
                                    String nicknameText =
                                        controller.nicknameC.text;
                                    if (nicknameText.isEmpty) {
                                      Get.snackbar('닉네임', '닉네임을 적어주세요');
                                      return; // return을 써주면 if문 읽고 빠져나와서 그 다음은 안읽는다.
                                    }
                                    String titleText = controller.titleC.text;
                                    if (titleText.isEmpty) {
                                      Get.snackbar('제목', '제목을 적어주세요');
                                      return;
                                    }
                                    if (controller.selectedImage1.value ==
                                        null) {
                                      Get.snackbar(
                                          '이미지', '이미지를 한 개 이상 선택해 주세요.');
                                      return;
                                    }
                                    String passwordText = controller.pwC.text;
                                    if (passwordText.length != 4) {
                                      Get.snackbar('비밀번호', '비밀번호 4자리를 적어주세요');
                                      return;
                                    }
                                    await controller
                                        .onPressedUploadButton(context);

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
// TODO: images에 여러개의 사진이 들어가면 수정 필요함. 현재는 1개의 이미지만 첨부된다는 전제 하에 진행했음
                    String imgUrl1 = post.images[0];
                    String? imgUrl2 = post.images[1];
                    String? imgUrl3 = post.images[2];
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
                                                  title: Image.network(imgUrl1),
                                                );
                                              });
                                        },
                                        icon: Expanded(
                                          child: SizedBox(
                                            width: 50,
                                            height: 25,
                                            child: Image.network(imgUrl1),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: imgUrl2 != null
                                                      ? Image.network(imgUrl2)
                                                      : Icon(Icons
                                                          .photo_album_outlined),
                                                );
                                              });
                                        },
                                        icon: Expanded(
                                          child: SizedBox(
                                            width: 50,
                                            height: 25,
                                            child: imgUrl2 != null
                                                ? Image.network(imgUrl2)
                                                : Icon(
                                                    Icons.photo_album_outlined),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: imgUrl3 != null
                                                      ? Image.network(imgUrl3)
                                                      : Icon(Icons
                                                          .photo_album_outlined),
                                                );
                                              });
                                        },
                                        icon: Expanded(
                                          child: SizedBox(
                                            width: 50,
                                            height: 25,
                                            child: imgUrl3 != null
                                                ? Image.network(imgUrl3)
                                                : Icon(
                                                    Icons.photo_album_outlined),
                                          ),
                                        ),
                                      ),
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
                      child: Column(
                        children: [
                          ListTile(
                            key: ValueKey(index),
                            title: Row(
                              children: [
                                Text(titleText),
                                Text(title),
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Image.network(imgUrl1),
                                ),
                                imgUrl2 != null
                                    ? SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: Image.network(imgUrl2),
                                      )
                                    : SizedBox(
                                        height: 30,
                                        width: 30,
                                      ),
                                imgUrl3 != null
                                    ? SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: Image.network(imgUrl3),
                                      )
                                    : SizedBox(
                                        height: 30,
                                        width: 30,
                                      ),
                                Spacer(),

                                // 수정 버튼
                                TextButton(
                                  onPressed: () {
                                    showChangeDialog(post);
                                  },
                                  child: Text('수정'),
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
                          // 마지막 항목은 구분선을 추가하지 않음
                          const Divider(
                            color: Colors.white,
                            thickness: 1.0,
                          ),
                        ],
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

                    // String title = post.title;
                    // String password = post.password;
                    // String nickName = post.nickName;
                    // int date = post.date;
                    DateTime _date =
                        DateTime.fromMillisecondsSinceEpoch(post.date);
                    String showDate =
                        '${_date.year}년${_date.month}월${_date.day}일 ${_date.hour}:${_date.minute}';

// TODO: images에 여러개의 사진이 들어가면 수정 필요함. 현재는 1개의 이미지만 첨부된다는 전제 하에 진행했음
                    String imgUrl1 = post.images[0];
                    String? imgUrl2 = post.images[1];
                    String? imgUrl3 = post.images[2];
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
                              title: Text(post.title),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Nickname: ${post.nickName.substring(0, 1)}**'),
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
                                                  title: Image.network(imgUrl1),
                                                );
                                              });
                                        },
                                        icon: Expanded(
                                          child: SizedBox(
                                            width: 50,
                                            height: 25,
                                            child: Image.network(imgUrl1),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: imgUrl2 != null
                                                      ? Image.network(imgUrl2)
                                                      : Icon(Icons
                                                          .photo_album_outlined),
                                                );
                                              });
                                        },
                                        icon: Expanded(
                                          child: SizedBox(
                                            width: 50,
                                            height: 25,
                                            child: imgUrl2 != null
                                                ? Image.network(imgUrl2)
                                                : Icon(
                                                    Icons.photo_album_outlined),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: imgUrl3 != null
                                                      ? Image.network(imgUrl3)
                                                      : Icon(Icons
                                                          .photo_album_outlined),
                                                );
                                              });
                                        },
                                        icon: Expanded(
                                          child: SizedBox(
                                            width: 50,
                                            height: 25,
                                            child: imgUrl3 != null
                                                ? Image.network(imgUrl3)
                                                : Icon(
                                                    Icons.photo_album_outlined),
                                          ),
                                        ),
                                      ),
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
                      child: Column(
                        children: [
                          ListTile(
                        key: ValueKey(index),
                        title: Row(
                          children: [
                            Text(titleText),
                            Text(post.title),
                            SizedBox(
                              height: 30,
                              width: 30,
                              child: Image.network(imgUrl1),
                            ),
                            imgUrl2 != null
                                ? SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Image.network(imgUrl2),
                                  )
                                : SizedBox(
                                    height: 30,
                                    width: 30,
                                  ),
                            imgUrl3 != null
                                ? SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Image.network(imgUrl3),
                                  )
                                : SizedBox(
                                    height: 30,
                                    width: 30,
                                  ),
                            Spacer(),

                            // 수정 버튼
                            TextButton(
                              onPressed: () {
                                showChangeDialog(post);
                              },
                              child: Text('수정'),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${post.nickName.substring(0, 1)}**'),
                            Text(showDate),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 1.0,
                      )
                        ],
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
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromRGBO(252, 180, 3, 1),
              )),
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
      child: WillPopScope(
        onWillPop: controller.onWillPop,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(252, 199, 3, 1),
          body: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    boxButton(),
                    certificationButton(),
                  ],
                ),
                SizedBox(height: 15),
                Expanded(
                  child: PageView(
                    controller: controller.luckyController,
                    children: <Widget>[
                      luckyBox(),
                      luckyCertification(context),
                    ],
                  ),
                ),
                BannerWidget(),
                SizedBox(height: 15)
              ],
            ),
          ),
        ),
      ),
    );
  }

  showChangeDialog(Post post) => showDialog(
        context: Get.context!, //getx 라이브러리
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('수정'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller.titleChangeC,
                    decoration: InputDecoration(
                      labelText: '제목',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextField(
                      controller: controller.nicknameChangeC,
                      decoration: InputDecoration(
                        labelText: '닉네임',
                      ),
                    ),
                  ),
                  Obx(() => controller.selectedImage1.value == null
                      ? IconButton(
                          onPressed: controller.selectFirstImage,
                          icon: Icon(Icons.photo_album_outlined))
                      : Image.file(controller.selectedImage1.value!)),
                  Obx(() => controller.selectedImage2.value == null
                      ? IconButton(
                          onPressed: controller.selectSecondImage,
                          icon: Icon(Icons.photo_album_outlined))
                      : Image.file(controller.selectedImage2.value!)),
                  Obx(() => controller.selectedImage3.value == null
                      ? IconButton(
                          onPressed: controller.selectThirdImage,
                          icon: Icon(Icons.photo_album_outlined))
                      : Image.file(controller.selectedImage3.value!)),
                  TextField(
                    controller: controller.pwCheckC,
                    decoration: InputDecoration(
                      labelText: '비밀번호 확인',
                    ),
                  ),
                  // 추가로 수정할 필드들을 TextField로 추가
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => controller.onTapSaveButton(post),
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
}
