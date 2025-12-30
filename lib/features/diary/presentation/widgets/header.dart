import 'package:flutter/cupertino.dart';

import '../../model/diary_with_analysis.dart';
import '../../model/sentiment.dart';

class Header extends StatelessWidget {
  final DiaryWithAnalysis diary;

  const Header({super.key, required this.diary});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(diary.sentiment.icon, size: 32, color: diary.sentiment.color),
      ],
    );
  }
}
