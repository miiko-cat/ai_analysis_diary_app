import 'package:ai_analysis_diary_app/features/diary/model/diary_with_analysis.dart';

class DetailDiaryState {
  // 画面パラメータ
  final DiaryWithAnalysis? diary;
  final String? errorMessage;

  const DetailDiaryState({this.diary, this.errorMessage});

  DetailDiaryState copyWith({DiaryWithAnalysis? diaryWithAnalysis, String? errorMessage}) {
    return DetailDiaryState(diary: diaryWithAnalysis ?? diary,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
