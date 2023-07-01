import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tarot_app/model/post.dart';

class PostRepository extends GetxService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference get postCollection =>
      _firebaseFirestore.collection('posts');

  Future<bool> createPost(Post post) async {
    bool result = false;
    try {
      await postCollection.doc(post.date.toString()).set(post.toJson());
      result = true;
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  Future<void> updatePostData(String documentId, Map<String, dynamic> newData) {
    return postCollection.doc(documentId).update(newData);
  }

  
}
