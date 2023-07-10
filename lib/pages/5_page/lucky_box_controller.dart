import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:tarot_app/model/post.dart';
import 'package:tarot_app/routes/app_routes.dart';
import 'package:tarot_app/services/local_data_service.dart';
import 'package:tarot_app/services/post_service.dart';
import 'package:tarot_app/utils/image_selector.dart';

class LuckyBoxController extends GetxController {
  final LocalDataService localDataService;
  final PostService postService;
  LuckyBoxController({
    required this.localDataService,
    required this.postService,
  });
  late PageController luckyController;
  late Rx<int> pageIndex = Rx(0);
  late List<Uint8List> captureData;
  //----------------<위 : 럭키상자 / 아래 : 럭키인증>-----------------
  TextEditingController nicknameC = TextEditingController();
  TextEditingController titleC = TextEditingController();
  TextEditingController pwC = TextEditingController();
  TextEditingController nicknameChangeC = TextEditingController();
  TextEditingController titleChangeC = TextEditingController();
  TextEditingController pwCheckC = TextEditingController();
  Rx<List<DocumentSnapshot>> documents = Rx([]);
  final selectedImage1 = Rx<File?>(null);
  final selectedImage2 = Rx<File?>(null);
  final selectedImage3 = Rx<File?>(null);

  @override
  void onInit() async {
    super.onInit();
    pageIndex.value = Get.arguments['initialTab'];
    // capture = Get.arguments['capture'];
    captureData = localDataService.getImage();

    print(captureData);
    luckyController = PageController(initialPage: pageIndex.value);
    initTopFiveView();
    postService.insertInitialData();
  }

  // 이미지 캡쳐 메소드
  Future<void> saveImageToGallery(Uint8List imageBytes) async {
    final result = await ImageGallerySaver.saveImage(imageBytes);
    if (result['isSuccess']) {
      print('이미지가 갤러리에 저장되었습니다.');
    } else {
      print('이미지 저장에 실패했습니다.');
    }
  }

  // firestore에 제목, 닉네임, 시간, 이미지 등 저장
  Future<void> onPressedUploadButton(BuildContext context) async {
    String titleText = titleC.text;
    String nicknameText = nicknameC.text;
    String passwordText = pwC.text;
    List<File?> files = [];
    if (selectedImage1.value != null) {
      files.add(selectedImage1.value!);
    }
    if (selectedImage2.value != null) {
      files.add(selectedImage2.value!);
    } else {
      files.add(null);
    }
    if (selectedImage3.value != null) {
      files.add(selectedImage3.value!);
    } else {
      files.add(null);
    }
    if (await postService.uploadPost(
      titleText: titleText,
      nicknameText: nicknameText,
      passwordText: passwordText,
      files: files,
    )) {
      Get.snackbar('업로드', '업로드 성공!');
    } else {
      Get.snackbar('업로드', '업로드 실패');
    }
  }

// 데이터 변경을 구독하고 변경 감지되면 변수 업데이트 함
  // void subscribeToDataChanges() {
  //   final collection = FirebaseFirestore.instance.collection('posts');
  //   collection.snapshots().listen((snapshot) {
  //     documents.value = snapshot.docs;
  //   });
  // }

  int perPage = 5;
  int page = 0;

  // 처음 페이지 나왔을 때 posts 콜렉션에서 데이터를 내림차순으로 5개(perPage만큼)씩 게시판 목록에 띄움
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

// 154번줄 ~196번줄까지 모두 기존 데이터 불러오기를 위한 녀석들!(luckyBoxPage의 334줄에 불러옴)
  final ScrollController scrollController =
      ScrollController(); // 기존 데이터 불러오기 controller
  bool isLoading = false; // 중복 호출 방지를 위한 변수

  listenScroll() {
    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    if (!isLoading &&
        scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
      // Reached the bottom
      loadMoreOld(); // 지난 데이터를 추가하는 메서드 호출
    }
  }

  // perPage수 만큼 다 보여주고 스크롤을 아래로 내릴 때, 더 오래된 데이터를 불러오는 메소드
  loadMoreOld() async {
    try {
      if (isLoading) return; // 이미 호출 중인 경우 중복 호출 방지

      isLoading =
          true; // 호출 시작 : 이 상태이면 scrollListener()가 다시 실행(중복)될 일을 막을 수 있다.
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

      documents.update((val) {
        documents.value.addAll(querySnapshot.docs);
      });
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
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
      // documents.update((val) {
      //   documents.value.insertAll(0, querySnapshot.docs);
      // });
      List<DocumentSnapshot> newDocs = querySnapshot.docs;
      List<DocumentSnapshot> currentDocs = documents.value;

      List<DocumentSnapshot> updatedDocs = [];
      updatedDocs.addAll(newDocs);
      updatedDocs.addAll(currentDocs);

      documents.value = updatedDocs;
    } catch (e) {
      print(e);
    }
  }

  Rx<List<DocumentSnapshot>> documentsForTopFiveView = Rx([]);

  // 조회수(views) Top5를 firestore에 저장
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

  // view수 올리는 메소드
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

  onTapSaveButton(Post post) async {
    String titleChangeText = titleChangeC.text;
    if (titleChangeText.isEmpty) {
      Get.snackbar('제목', '제목을 적어주세요');
      return;
    }
    String nicknameChangeText = nicknameChangeC.text;
    if (nicknameChangeText.isEmpty) {
      Get.snackbar('닉네임', '닉네임을 적어주세요');
      return; // return을 써주면 if문 읽고 빠져나와서 그 다음은 안읽는다.
    }
    if (selectedImage1.value == null) {
      Get.snackbar('이미지', '이미지를 한 개 이상 선택해 주세요');
      return;
    }
    String passwordCheckText = pwCheckC.text;
    if (passwordCheckText != post.password) {
      Get.snackbar('비밀번호', '비밀번호가 틀렸습니다');
      return;
    }

    List<File?> files = [];
    if (selectedImage1.value != null) {
      files.add(selectedImage1.value!);
    } else {
      Get.snackbar('이미지', '이미지를 한 개 이상 등록해주세요');
      return;
    }
    if (selectedImage2.value != null) {
      files.add(selectedImage2.value!);
    } else {
      files.add(null);
    }
    if (selectedImage3.value != null) {
      files.add(selectedImage3.value!);
    } else {
      files.add(null);
    }

    if (await postService.updatePost(
      documentId: post.date.toString(),
      titleText: titleChangeText,
      nicknameText: nicknameChangeText,
      files: files,
    )) {
      Get.back();
      Get.snackbar('업로드', '업로드 성공!');
    } else {
      Get.back();
      Get.snackbar('업로드', '업로드 실패');
    }
  }

  selectFirstImage() async {
    File? file = await MediaPicker.singlePhoto();
    if (file != null) {
      selectedImage1.value = file;
    }
  }

  selectSecondImage() async {
    File? file = await MediaPicker.singlePhoto();
    if (file != null) {
      selectedImage2.value = file;
    }
  }

  selectThirdImage() async {
    File? file = await MediaPicker.singlePhoto();
    if (file != null) {
      selectedImage3.value = file;
    }
  }

  Future<bool> onWillPop() {
    // 뒤로가기 버튼 처리 로직 작성
    Get.offNamed(Routes.CHECK_PAGE, arguments: 0);
    // true를 반환하면 기본 뒤로가기 동작 실행, false를 반환하면 동작 무시
    return Future.value(true);
  }
}
