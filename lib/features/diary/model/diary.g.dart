// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Diary _$DiaryFromJson(Map<String, dynamic> json) => _Diary(
  postId: json['post_id'] as String?,
  date: DateTime.parse(json['date'] as String),
  title: json['title'] as String,
  description: json['description'] as String,
  userId: json['user_id'] as String,
  updatedDate: json['updated_date'] == null
      ? null
      : DateTime.parse(json['updated_date'] as String),
);

Map<String, dynamic> _$DiaryToJson(_Diary instance) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'title': instance.title,
  'description': instance.description,
  'user_id': instance.userId,
};
