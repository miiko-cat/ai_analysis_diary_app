// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_with_analysis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiaryWithAnalysis _$DiaryWithAnalysisFromJson(Map<String, dynamic> json) =>
    _DiaryWithAnalysis(
      postId: json['post_id'] as String?,
      userId: json['user_id'] as String?,
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      sentiment: $enumDecodeNullable(_$SentimentEnumMap, json['sentiment']),
      emotion: (json['emotion'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      summary: json['summary'] as String?,
      advice: json['advice'] as String?,
    );

Map<String, dynamic> _$DiaryWithAnalysisToJson(_DiaryWithAnalysis instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'title': instance.title,
      'description': instance.description,
      'sentiment': _$SentimentEnumMap[instance.sentiment],
      'emotion': instance.emotion,
      'summary': instance.summary,
      'advice': instance.advice,
    };

const _$SentimentEnumMap = {
  Sentiment.positive: 'positive',
  Sentiment.negative: 'negative',
  Sentiment.neutral: 'neutral',
};
