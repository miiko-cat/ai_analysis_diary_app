import 'package:ai_analysis_diary_app/features/diary/model/diary_with_analysis.dart';

class DetailDiaryState {
  // 画面パラメータ
  final DiaryWithAnalysis? diaryWithAnalysis;

  const DetailDiaryState({this.diaryWithAnalysis});

  DetailDiaryState copyWith({DiaryWithAnalysis? diaryWithAnalysis}) {
    return DetailDiaryState(diaryWithAnalysis: diaryWithAnalysis ?? this.diaryWithAnalysis);
  }
}
