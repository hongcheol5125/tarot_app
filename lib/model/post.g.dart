// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      title: json['title'] as String,
      nickName: json['nickName'] as String,
      password: json['password'] as String,
      images: json['images'] as List<dynamic>,
      views: json['views'] as int,
      date: json['date'] as int,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'nickName': instance.nickName,
      'title': instance.title,
      'password': instance.password,
      'images': instance.images,
      'views': instance.views,
      'date': instance.date,
    };
