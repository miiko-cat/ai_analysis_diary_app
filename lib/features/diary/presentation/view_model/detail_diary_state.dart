import 'package:ai_analysis_diary_app/features/diary/model/diary_with_analysis.dart';

class DetailDiaryState {
  // 画面パラメータ
  final DiaryWithAnalysis? diaryWithAnalysis;
  final String? errorMessage;

  const DetailDiaryState({this.diaryWithAnalysis, this.errorMessage});

  DetailDiaryState copyWith({DiaryWithAnalysis? diaryWithAnalysis, String? errorMessage}) {
    return DetailDiaryState(diaryWithAnalysis: diaryWithAnalysis ?? this.diaryWithAnalysis,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
