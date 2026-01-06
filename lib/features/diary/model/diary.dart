// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary.freezed.dart';
part 'diary.g.dart';

@freezed
abstract class Diary with _$Diary {

  // プロパティ指定
  const factory Diary({
    @JsonKey(name: 'post_id', includeToJson: false)
    String? postId,
    required DateTime date,
    required String title,
    required String description,
    @JsonKey(name: 'user_id')
    required String userId,
    @JsonKey(name: 'updated_date', includeToJson: false)
    DateTime? updatedDate,
  }) = _Diary;

  factory Diary.fromJson(Map<String, dynamic> json) => _$DiaryFromJson(json);
}