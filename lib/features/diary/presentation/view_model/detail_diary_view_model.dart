import 'dart:async';

import 'package:ai_analysis_diary_app/features/diary/model/diary_with_analysis.dart';
import 'package:ai_analysis_diary_app/features/diary/presentation/view_model/detail_diary_state.dart';
import 'package:ai_analysis_diary_app/features/diary/repository/diary_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/dialog_service.dart';
import '../../../../core/utils/widget/app_loading_overlay.dart';
import '../../domain/diary_exception.dart';
import '../../repository/diary_repository.dart';

final detailDiaryVMProvider = AsyncNotifierProvider.autoDispose
    .family<DetailDiaryViewModel, DetailDiaryState, DiaryWithAnalysis>(DetailDiaryViewModel.new);

class DetailDiaryViewModel extends AsyncNotifier<DetailDiaryState> {
  final DiaryWithAnalysis _diary;

  DetailDiaryViewModel(this._diary);

  DiaryRepository get _diaryRepository => ref.read(diaryRepositoryProvider);

  DialogService get _dialogService => ref.read(dialogServiceProvider);

  @override
  Future<DetailDiaryState> build() async {
    // リポジトリから最新の日記を1件取得
    final latestDiary = await _diaryRepository.fetchDiaryWithAnaylysis(userId: _diary.userId!, postId: _diary.postId!);
    // 最新のデータを保持した状態を返す
    return DetailDiaryState(diary: latestDiary);
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
      // awaitの後はRefが生きているか確認する
      if (!ref.mounted) return;
      // 使う直前に notifier を取得する
      final loading = ref.read(loadingProvider.notifier);
      try {
        // ローディング
        loading.state = true;
        // 日記削除実行
        await _diaryRepository.delete(_diary.postId);
        if (!ref.mounted) return;

      } on DiaryException catch (e) {
        state = AsyncData(state.requireValue.copyWith(errorMessage: e.message));
      } catch (e) {
        state = AsyncData(state.requireValue.copyWith(errorMessage: e.toString()));
      } finally {
        // ローディング解除
        if (ref.mounted) {
          loading.state = false;
        }
      }
    }
  }

  // エラーメッセージ削除
  void clearError() {
    state = AsyncData(state.requireValue.copyWith(errorMessage: null));
  }
}
