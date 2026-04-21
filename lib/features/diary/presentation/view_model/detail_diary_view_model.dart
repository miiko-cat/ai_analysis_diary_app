import 'dart:async';

import 'package:ai_analysis_diary_app/features/diary/model/diary_with_analysis.dart';
import 'package:ai_analysis_diary_app/features/diary/presentation/view_model/detail_diary_state.dart';
import 'package:ai_analysis_diary_app/features/diary/repository/diary_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/dialog_service.dart';
import '../../../../core/utils/widget/app_loading_overlay.dart';
import '../../domain/diary_exception.dart';

final detailDiaryVMProvider = AsyncNotifierProvider.autoDispose
    .family<DetailDiaryViewModel, DetailDiaryState, DiaryWithAnalysis>(DetailDiaryViewModel.new);

class DetailDiaryViewModel extends AsyncNotifier<DetailDiaryState> {
  final DiaryWithAnalysis _diary;

  DetailDiaryViewModel(this._diary);

  // 共通DialogService取得
  late final _dialogService = ref.read(dialogServiceProvider);

  // ローディング状態管理
  late final _loadingController = ref.read(loadingProvider.notifier);

  // 日記Repository取得
  late final _diaryRepository = ref.read(diaryRepositoryProvider);

  @override
  Future<DetailDiaryState> build() async {
    // 初期状態
    return DetailDiaryState();
  }

  // 日記削除処理
  Future<void> deleteDiary() async {
    final completer = Completer<bool>();
    // 日記削除確認ダイアログ表示
    _dialogService.show(DialogRequest(type: DialogType.confirmDeleteDiary, completer: completer));
    // ユーザーがボタンを押すまでここで待機する
    final result = await completer.future;

    // 削除ボタンをタップした場合
    if (result) {
      try {
        // ローディング
        _loadingController.state = true;
        // 日記削除実行
        await _diaryRepository.delete(_diary.postId);
      } on DiaryException catch (e) {
        state = AsyncData(state.requireValue.copyWith(errorMessage: e.message));
      } catch (e) {
        state = AsyncData(state.requireValue.copyWith(errorMessage: e.toString()));
      } finally {
        // ローディング解除
        _loadingController.state = false;
      }
    }
  }

  // エラーメッセージ削除
  void clearError() {
    state = AsyncData(state.requireValue.copyWith(errorMessage: null));
  }
}
