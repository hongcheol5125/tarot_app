import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:tarot_app/model/post.dart';

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
  Rx<TextEditingController> modifyTitleController =
      Rx(TextEditingController(text: 'title수정'));
  Rx<TextEditingController> modifyContentController =
      Rx(TextEditingController(text: 'contene수정'));
  // Rx<String> title = Rx(''); // 23~26째 줄을 post클래스로 대체할 수 있지 않을까?
  // Rx<String> nickname = Rx(''); // 23~26째 줄을 post클래스로 대체할 수 있지 않을까?
  // Rx<String> password = Rx(''); // 23~26째 줄을 post클래스로 대체할 수 있지 않을까?
  // DateTime date = DateTime.now(); // 23~26째 줄을 post클래스로 대체할 수 있지 않을까?
  // DateTime abc = DateTime.fromMillisecondsSinceEpoch(1234);
  Rx<Post> post = Rx(Post(date: DateTime.now().millisecondsSinceEpoch));
  Rx<List<DocumentSnapshot>> documents = Rx([]);
  // Rx<File?> selectedImage = Rx(File());
  final selectedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    initialTab = Get.arguments['initialTab'];
    // capture = Get.arguments['capture'];
    if (box.read('captureList') == null) {
      captureData = [];
    } else {
      List<dynamic> encodedList = box.read('captureList');
      List<Uint8List> dataList =
          encodedList.map((encodedData) => base64Decode(encodedData)).toList();

      captureData = dataList;
    }

    print(captureData);
    pageIndex = Rx(initialTab);
    luckyController = PageController(initialPage: initialTab);
    fetchData();
    // subscribeToDataChanges();
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
    String titleText = post.value.title!;
    String nicknameText = post.value.nickName!;
    String passwordText = post.value.password!;
    String dateText = '${post.value.date}';
    String? urlText = await uploadImage(selectedImage.value!);

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
          .doc(dateText)
          .set({
            'title': titleText,
            'nickname': nicknameText,
            'password': passwordText,
            'date': dateText,
            'views': post.value.views,
            'img_url': urlText,
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

// 데이터 변경을 구독하고 변경 감지되면 변수 업데이트 함
  // void subscribeToDataChanges() {
  //   final collection = FirebaseFirestore.instance.collection('posts');
  //   collection.snapshots().listen((snapshot) {
  //     documents.value = snapshot.docs;
  //   });
  // }

// posts라는 콜렉션에 데이터 저장하는 메소드
  void fetchData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('posts').get();
      documents.value = querySnapshot.docs;
    } catch (e) {
      print(e);
    }
  }

  incrementViews() {
    post.value.views++;
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      String fileName = post.value.date.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      print(imageUrl);
      return imageUrl;
    } catch (e) {
      print('Image upload failed: $e');
      return null;
    }
  }
}
