// ignore_for_file: invalid_annotation_target

import 'package:ai_analysis_diary_app/features/diary/model/sentiment.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary_with_analysis.freezed.dart';
part 'diary_with_analysis.g.dart';

@freezed
abstract class DiaryWithAnalysis with _$DiaryWithAnalysis {

  // プロパティ指定
  const factory DiaryWithAnalysis({
    @JsonKey(name: 'post_id', includeToJson: false)
    String? postId,
    @JsonKey(name: 'user_id', includeToJson: false)
    String? userId,
    required DateTime date,
    required String title,
    required String description,
    Sentiment? sentiment,
    List<String>? emotion,
    String? summary,
    String? advice
  }) = _DiaryWithAnalysis;

  factory DiaryWithAnalysis.fromJson(Map<String, dynamic> json) => _$DiaryWithAnalysisFromJson(json);
}