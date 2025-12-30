import 'package:ai_analysis_diary_app/features/diary/model/diary_with_analysis.dart';
import 'package:flutter/material.dart';

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
            // Header(diary: diary),
            SizedBox(height: 16),
            // Title(diary.title),
            SizedBox(height: 12),
            // Description(diary.description),
            SizedBox(height: 24),
            // AIAnalysis(diary),
          ],
        ),
      ),
    );
  }
}
