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
  late Rx<int> pageIndex = Rx(0);
  final box = GetStorage();
  late List<Uint8List> captureData;
  //----------------<위 : 럭키상자 / 아래 : 럭키인증>-----------------
  TextEditingController nicknameC = TextEditingController();
  TextEditingController titleC = TextEditingController();
  TextEditingController pwC = TextEditingController();

  // Rx<String> title = Rx(''); // 23~26째 줄을 post클래스로 대체할 수 있지 않을까?
  // Rx<String> nickname = Rx(''); // 23~26째 줄을 post클래스로 대체할 수 있지 않을까?
  // Rx<String> password = Rx(''); // 23~26째 줄을 post클래스로 대체할 수 있지 않을까?
  // DateTime date = DateTime.now(); // 23~26째 줄을 post클래스로 대체할 수 있지 않을까?
  // DateTime abc = DateTime.fromMillisecondsSinceEpoch(1234);
  Rx<List<DocumentSnapshot>> documents = Rx([]);
  // Rx<File?> selectedImage = Rx(File());
  final selectedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    pageIndex.value = Get.arguments['initialTab'];
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
    luckyController = PageController(initialPage: pageIndex.value);
    initTopFiveView();
    initialData();
  }

  Future<void> saveImageToGallery(Uint8List imageBytes) async {
    final result = await ImageGallerySaver.saveImage(imageBytes);
    if (result['isSuccess']) {
      print('이미지가 갤러리에 저장되었습니다.');
    } else {
      print('이미지 저장에 실패했습니다.');
    }
  }

  Future<void> onPressedUploadButton(BuildContext context) async {
    String titleText = titleC.text;
    if (titleText.isEmpty) {
      Get.snackbar('제목', '제목을 적어주세요');
      return;
    }
    String nicknameText = nicknameC.text;
    if (nicknameText.isEmpty) {
      Get.snackbar('닉네임', '닉네임을 적어주세요');
      return;
    }
    String passwordText = pwC.text;
    if (passwordText.length != 4) {
      Get.snackbar('비밀번호', '비밀번호 4자리를 적어주세요');
      return;
    }

    int date = DateTime.now().millisecondsSinceEpoch;

    String? urlText =
        await uploadImage(selectedImage.value!, fileName: date.toString());
    if (urlText == null) {
      Get.snackbar('이미지', '이미지를 등록해주세요');
      return;
    }

    Post post = Post(
      title: titleText,
      nickName: nicknameText,
      password: passwordText,
      images: [urlText],
      views: 0,
      date: date,
    );

    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.date.toString())
          .set(post.toJson())
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

  int perPage = 5;

  // 처음 페이지 나왔을 때 posts 콜렉션에서 데이터를 내림차순으로 2개씩 게시판 목록에 띄움
  void initialData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('date', descending: true)
          .limit(perPage)
          .get();
      documents.value = querySnapshot.docs; //
    } catch (e) {
      print(e);
    }
  }

  // perPage수 만큼 다 보여주고 스크롤을 아래로 내릴 때, 더 오래된 데이터를 불러오는 메소드
  loadMoreOld() async {
    try {
      //querySnapshot은 .data()를 붙여줘야 비로소 거기 안의 데이터를 가져올 수 있다.
      var json = documents.value.last.data()
          as Map<String, dynamic>; // .last는 List 중 가장 마지막 데이터를 가져옴
      Post lastPost = Post.fromJson(json);
      int lastPostDate = lastPost.date;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('date', descending: true)
          .where('date', isLessThan: lastPostDate)
          .limit(perPage)
          .get();

      documents.value.addAll(querySnapshot.docs);
    } catch (e) {
      print(e);
    }
  }

  // 가장 처음에서 새로 들어온 최신 데이터를 불러오는 메소드
  Future<void> loadMoreNew() async {
    try {
      var json = documents.value.first.data() // .first는 List 중 가장 처음 데이터를 가져옴
          as Map<String, dynamic>;
      Post firsPost = Post.fromJson(
          json); // firstPost는 firestore에 있는 모든 데이터를 Post클래스 형태로 다 가져옴
      int firstPostDocId =
          firsPost.date; // 데이터를 다 가져온 중에 date만 뽑아서 firstPostDocId에 집어넣음
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('date', descending: true)
          .where('date', isGreaterThan: firstPostDocId)
          .limitToLast(perPage)
          .get();

      /// 1. 아무리 스크롤 내려도 업데이트 안되길래 174번줄부터 183번줄까지 모두 breakPoint 걸어서 데이터 요정 잘 되는지,
      /// 2. 186번줄 breakPoint 걸어서 데이터 잘 가져오는지,
      /// 3. luckyBoxPage의 ListView.Builder에 breakPoint 걸어서 가져온 데이터를 가지고 다시 리빌드 해주는지 확인함
      /// 그 결과 3.번이 문제여서 아래처럼 진행해주니 해결됨
      /// insertAll은 List의 맨 처음에 집어넣음 => 근데 Obx가 바뀐걸 인식을 못해서 documents.update 안에 넣으니 스크롤 아래로 당기니까 업데이트 됨
      documents.update((val) {
        documents.value.insertAll(0, querySnapshot.docs);
      });
    } catch (e) {
      print(e);
    }
  }

  Rx<List<DocumentSnapshot>> documentsForTopFiveView = Rx([]);

  initTopFiveView() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('views', descending: true)
          .limit(5)
          .get();
      documentsForTopFiveView.value = querySnapshot.docs; //
    } catch (e) {
      print(e);
    }
  }

  // 걍 initTopFiveView() 메소드 쓰면 되는건데 삽질함....
  // Future<String?> loadMoreView() async {
  //   try {
  //     var json = documentsForTopFiveView.value.first.data() // .first는 List 중 가장 처음 데이터를 가져옴
  //         as Map<String, dynamic>;
  //     Post firsPost = Post.fromJson(
  //         json); // firstPost는 firestore에 있는 모든 데이터를 Post클래스 형태로 다 가져옴
  //     int firstPostDocId =
  //         firsPost.views; // 데이터를 다 가져온 중에 date만 뽑아서 firstPostDocId에 집어넣음
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('posts')
  //         .orderBy('views', descending: true)
  //         .where('views', isGreaterThan: firstPostDocId)
  //         .limitToLast(5)
  //         .get();

  //     documentsForTopFiveView.update((val) {
  //       documentsForTopFiveView.value[4] = documentsForTopFiveView.value[3];
  //       documentsForTopFiveView.value[3] = documentsForTopFiveView.value[2];
  //       documentsForTopFiveView.value[2] = documentsForTopFiveView.value[1];
  //       documentsForTopFiveView.value[1] = documentsForTopFiveView.value[0];
  //       documentsForTopFiveView.value[0] = querySnapshot.docs.first;
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<String?> uploadImage(File imageFile,
      {required String fileName}) async {
    try {
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

  void incrementViewCount(String documentId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(documentId)
        .update({
          'views': FieldValue.increment(1),
        })
        .then((_) => print('View count incremented successfully.'))
        .catchError((error) => print('Failed to increment view count: $error'));
  }
}
