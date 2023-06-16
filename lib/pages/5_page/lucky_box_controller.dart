import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class LuckyBoxController extends GetxController {
  late PageController luckyController;
  late Rx<int> pageIndex;

  late int initialTab;
  final box = GetStorage();
  late List<Uint8List> captureData;
  late int reverseIndex;
  //----------------<위 : 럭키상자 / 아래 : 럭키인증>-----------------
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  Rx<String> title = Rx('');
  Rx<String> nickname = Rx('');
  Rx<String> password = Rx('');
  DateTime date = DateTime.now();
  Rx<List<DocumentSnapshot>> documents = Rx([]);

  @override
  void onInit() {
    super.onInit();
    initialTab = Get.arguments['initialTab'];
    // capture = Get.arguments['capture'];

    captureData = box.read('captureList') ?? [];
    print(captureData);
    pageIndex = Rx(initialTab);
    luckyController = PageController(initialPage: initialTab);
    fetchData();
  }

  Future<void> saveImageToGallery(Uint8List imageBytes) async {
    final result = await ImageGallerySaver.saveImage(imageBytes);
    if (result['isSuccess']) {
      print('이미지가 갤러리에 저장되었습니다.');
    } else {
      print('이미지 저장에 실패했습니다.');
    }
  }

  void createData(BuildContext context) async {
    String titleText = title.value;
    String nicknameText = nickname.value;
    String passwordText = password.value;
    String dateText =
        '${date.year.toString()}.${date.month.toString()}.${date.day.toString()} ${(date.hour + 9).toString()}:${date.minute.toString()}:${date.second.toString()}';

if (nicknameText.isEmpty) {
      Get.snackbar('닉네임', '닉네임을 적어주세요');
      return;
    }
    if (titleText.isEmpty) {
      Get.snackbar('제목', '제목을 적어주세요');
      return;
    }
    if (passwordText.length != 4) {
      Get.snackbar('비밀번호', '비밀번호 4자리를 적어주세요');
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .add({
            'title': titleText,
            'nickname': nicknameText,
            'password': passwordText,
            'date': dateText,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
      Get.snackbar('Success', 'Data created successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create data!');
      print(e);
    }
    // if (titleText.isNotEmpty && nickname.isNotEmpty && passwordText.length == 4) {
    //   try {
    //     await FirebaseFirestore.instance.collection('posts').add({
    //       'title': titleText,
    //       'nickname' : nicknameText,
    //       'password' : passwordText,
    //       'date' : dateText,
    //     }).then((value) => print("User Added"))
    //       .catchError((error) => print("Failed to add user: $error"));
    //     Get.snackbar('Success', 'Data created successfully!');
    //   } catch (e) {
    //     Get.snackbar('Error', 'Failed to create data!');
    //     print(e);
    //   }
    // }
  }

  void fetchData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('posts').get();
      documents.value = querySnapshot.docs;
    } catch (e) {
      print(e);
    }
  }
}
