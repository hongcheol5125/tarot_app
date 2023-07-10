import 'dart:io';

import 'package:get/get.dart';
import 'package:tarot_app/model/post.dart';
import 'package:tarot_app/repositories/image_repository.dart';
import 'package:tarot_app/repositories/post_repository.dart';

class PostService extends GetxService {
  ImageRepository imageRepository;
  PostRepository postRepository;
  PostService({
    required this.imageRepository,
    required this.postRepository,
  });

  Future<bool> uploadPost({
    required String titleText,
    required String nicknameText,
    required String passwordText,
    required List<File?> files,
  }) async {
    bool result = false;
    try {
      int date = DateTime.now()
          .toUtc()
          .add(const Duration(hours: 9))
          .millisecondsSinceEpoch;
      List<String?> listUrlTexts = [];
      for (var i = 0; i < files.length; i++) {
        String fileName = (date + i).toString();
        listUrlTexts.add(
            await imageRepository.uploadImage(files[i], fileName: fileName));
      }

      Post post = Post(
        title: titleText,
        nickName: nicknameText,
        password: passwordText,
        images: listUrlTexts,
        views: 0,
        date: date,
      );

      await postRepository.createPost(post);

      result = true;
    } catch (e) {}
    return result;
  }

  Future<bool> updatePost({
    required String documentId,
    required String titleText,
    required String nicknameText,
    required List<File?> files,
  }) async {
    bool result = false;
    try {
      int date = DateTime.now()
          .toUtc()
          .add(const Duration(hours: 9))
          .millisecondsSinceEpoch;
      List<String?> listUrlTexts = [];
      for (var i = 0; i < files.length; i++) {
        String fileName = (date + i).toString();
        listUrlTexts.add(
            await imageRepository.uploadImage(files[i], fileName: fileName));
      }
      var newData = {
        'title': titleText,
        'nickName': nicknameText,
        'images': listUrlTexts,
      };

      await postRepository.updatePostData(documentId, newData);

      result = true;
    } catch (e) {}
    return result;
  }

  Future<void> insertInitialData() async{
   await postRepository.initialData(perPage: 5, documents: Rx([]));
  }
}
