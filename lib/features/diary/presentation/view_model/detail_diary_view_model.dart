import 'package:ai_analysis_diary_app/features/diary/model/diary_with_analysis.dart';
import 'package:ai_analysis_diary_app/features/diary/presentation/view_model/detail_diary_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/utils/dialog_service.dart';
import '../../../../core/utils/widget/app_loading_overlay.dart';

final detailDiaryVMProvider = AsyncNotifierProvider.autoDispose
    .family<DetailDiaryViewModel, DetailDiaryState, DiaryWithAnalysis>(DetailDiaryViewModel.new);

class DetailDiaryViewModel extends AsyncNotifier<DetailDiaryState> {
  // ignore: unused_field
  final DiaryWithAnalysis _diary;

  DetailDiaryViewModel(this._diary);

  // 共通DialogService取得
  late final _dialogService = ref.read(dialogServiceProvider);

  // ローディング状態管理
  late final StateController<bool> _loadingController = ref.read(loadingProvider.notifier);

  @override
  Future<DetailDiaryState> build() async {
    // 初期状態
    return DetailDiaryState();
  }


}
