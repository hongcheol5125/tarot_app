import "package:json_annotation/json_annotation.dart";

part 'post.g.dart';

@JsonSerializable()
class Post {
  String nickName;
  String title;
  String password;
  List<dynamic> images;
  int views;
  int date;

  Post({
    required this.title,
    required this.nickName,
    required this.password,
    required this.images,
    required this.views,
    required this.date,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
