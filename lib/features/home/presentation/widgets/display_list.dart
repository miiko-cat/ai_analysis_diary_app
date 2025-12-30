import 'package:ai_analysis_diary_app/features/diary/model/diary_with_analysis.dart';
import 'package:ai_analysis_diary_app/features/diary/model/sentiment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DisplayList extends StatelessWidget {
  final List<DiaryWithAnalysis> diaries;

  const DisplayList({super.key, required this.diaries});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // FABの分だけ下に余白を作る
      padding: EdgeInsets.only(bottom: 96),
      itemCount: diaries.length,
      itemBuilder: (context, index) {
        final diary = diaries[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: Icon(
              diary.sentiment.icon,
              color: diary.sentiment.color,
              size: 30,
            ),
            title: Text(
              diary.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              DateFormat('yyyy/MM/dd HH:mm:ss').format(diary.date.toLocal()),
            ),
            trailing: diary.sentiment.chip,
          ),
        );
      },
    );
  }
}
