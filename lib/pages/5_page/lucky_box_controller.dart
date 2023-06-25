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
import 'package:tarot_app/utils/image_selector.dart';

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
  Rx<bool> isEnd = Rx(false);
  Rx<bool> isRequested = Rx(false);

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
    
    String nicknameText = nicknameC.text;
    
    
    String passwordText = pwC.text;
    

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
  int page = 0;

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

  // 게시물 수정
  Future<void> updatePostData(String documentId, Map<String, dynamic> newData) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(documentId)
        .update(newData);
  }

  Future<void> onPressedChangeButton(context, Post post) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newTitle = post.title; // 기존 데이터 초기값으로 설정
        String newNickName = post.nickName;
        String checkPassword = post.password;
        // 추가로 수정할 필드들을 선언하고 초기값 설정

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('수정'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      padding: const EdgeInsets.only(bottom: 10),
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
                    Obx(() => selectedImage.value == null
                        ? Text('이미지를 선택하세요')
                        : Image.file(selectedImage.value!)),
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
                    File? file = await MediaPicker.singlePhoto();
                    if (file != null) {
                      selectedImage.value = file;

                      setState(() {});
                    }
                  },
                ),
                TextButton(
                  onPressed: () async {
                    int date = DateTime.now().millisecondsSinceEpoch;
                    if (selectedImage.value == null) {
                      Get.snackbar('이미지', '이미지를 선택해 주세요.');
                    } else {
                      String? urlText = await uploadImage(selectedImage.value!,
                          fileName: date.toString());
                      if (urlText == null) {
                        Get.snackbar('이미지', '이미지를 등록해주세요');
                        return;
                      }
                      if (newTitle != '' &&
                          newNickName != '' &&
                          checkPassword == //여기서 newTitle, newnickName에 대해 써봤자이다
                              post.password &&
                          selectedImage.value != null) {
                        // 비밀번호가 일치하면 수정을 진행
                        // 수정한 데이터를 Firestore에 업데이트
                        final newData = {
                          'title': newTitle,
                          'nickName': newNickName,
                          'images': [urlText],
                        };
                        updatePostData(post.date.toString(), newData).then((_) {
                          Navigator.of(context).pop();
                        }).catchError((error) {
                          print('Failed to update post: $error');
                        });
                      } else {
                        // 비밀번호가 일치하지 않으면 에러 메시지 표시
                        // if(title == ''){
                        //     Get.snackbar('제목', '제목을 입력하세요');
                        //   }else if(nickName == ''){
                        //      Get.snackbar('닉네임', '닉네임을 입력하세요');
                        //   }else
                        if (selectedImage.value != null) {
                          Get.snackbar('이미지', '이미지를 선택하세요');
                        } else {
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
  }
}
