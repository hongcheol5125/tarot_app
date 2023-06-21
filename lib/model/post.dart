import "package:json_annotation/json_annotation.dart";

part 'post.g.dart';

@JsonSerializable()
class Post {
  String? nickName;
  String? title;
  String? password;
  List<dynamic>? images = [];
  int views;
  int? date = DateTime.now().millisecondsSinceEpoch;

  Post(
      {this.title,
      this.nickName,
      this.password,
      this.images = const [],
      this.views = 0,
      this.date});

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
