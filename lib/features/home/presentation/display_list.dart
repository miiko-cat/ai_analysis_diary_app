import 'package:ai_analysis_diary_app/features/diary/model/diary_with_analysis.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DisplayList extends StatelessWidget {
  final List<DiaryWithAnalysis> diaries;

  const DisplayList({super.key, required this.diaries});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: diaries.length,
        itemBuilder: (context, index) {
          final diary = diaries[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Icon(
                sentimentIcon(diary.sentiment),
                color: sentimentColor(diary.sentiment),
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
              trailing: sentimentChip(diary.sentiment!),
            ),
          );
        },
      ),
    );
  }

  // 感情によって絵文字を使い分ける
  IconData sentimentIcon(String? sentiment) {
    switch (sentiment) {
      case 'positive':
        return Icons.sentiment_satisfied;
      case 'negative':
        return Icons.sentiment_dissatisfied;
      case 'neutral':
        return Icons.sentiment_neutral;
      default:
        return Icons.help_outline;
    }
  }

  // 感情によって色を使い分ける
  Color sentimentColor(String? sentiment) {
    switch (sentiment) {
      case 'positive':
        return Colors.green;
      case 'negative':
        return Colors.red;
      case 'neutral':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  // Chip化
  Widget sentimentChip(String? sentiment) {
    sentiment ??= '-';
    return Chip(
      label: Text(sentiment),
      backgroundColor: sentimentColor(sentiment).withValues(alpha: 0.15),
      labelStyle: TextStyle(color: sentimentColor(sentiment)),
    );
  }
}
