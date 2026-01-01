import 'package:ai_analysis_diary_app/features/diary/model/diary_with_analysis.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/sentiment.dart';

class DetailDiary extends StatelessWidget {
  final DiaryWithAnalysis diary;

  const DetailDiary({super.key, required this.diary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('日記詳細')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(diary: diary),
            SizedBox(height: 16),
            title(context, diary.title),
            SizedBox(height: 12),
            description(context, diary.description),
            SizedBox(height: 24),
            aiAnalysis(context, diary),
          ],
        ),
      ),
    );
  }

  // ヘッダー
  Widget header({required DiaryWithAnalysis diary}) {
    return Row(
      children: [
        Icon(diary.sentiment.icon, size: 32, color: diary.sentiment.color),
        SizedBox(width: 8),
        diary.sentiment.chip,
        Spacer(),
        Text(DateFormat('yyyy/MM/dd HH:mm:ss').format(diary.date.toLocal()))
      ],
    );
  }

  // タイトル
  Widget title(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.headlineSmall);
  }

  // 本文
  Widget description(BuildContext context, String description) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
        ),
      ),
    );
  }

  // 分析結果
  Widget aiAnalysis(BuildContext context, DiaryWithAnalysis diary) {
    return Card(
      child: ExpansionTile(
        title: Text('AI分析', style: Theme.of(context).textTheme.titleMedium),
        childrenPadding: EdgeInsetsGeometry.all(16),
        children: [
          SizedBox(height: 8),
          Text(
            '感情: ${diary.emotion ?? '-'}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 8),
          if (diary.summary != null)
            summarySection(context, diary.summary!),
        ],
      ),
    );
  }

  Widget summarySection(BuildContext context, String summary) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '要約',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              summary,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
