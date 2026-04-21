import 'dart:async';

import 'package:ai_analysis_diary_app/core/utils/dialog_service.dart';
import 'package:ai_analysis_diary_app/core/utils/widget/app_loading_overlay.dart';
import 'package:ai_analysis_diary_app/features/diary/domain/diary_exception.dart';
import 'package:ai_analysis_diary_app/features/diary/model/diary_with_analysis.dart';
import 'package:ai_analysis_diary_app/features/diary/presentation/view_model/detail_diary_view_model.dart';
import 'package:ai_analysis_diary_app/features/diary/repository/diary_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_supabase.dart';

void main() {
  late MockDiaryRepository mockRepo;
  late MockDialogService mockDialog;
  late ProviderContainer container;

  // ダミーデータ
  final dummyDiary = DiaryWithAnalysis(date: DateTime.now(), title: 'ダミータイトル', description: 'ダミー本文', postId: 'test-id');

  setUp(() {
    mockRepo = MockDiaryRepository();
    mockDialog = MockDialogService();

    container = ProviderContainer(
      overrides: [
        diaryRepositoryProvider.overrideWithValue(mockRepo),
        dialogServiceProvider.overrideWithValue(mockDialog),
      ],
    );

    // DialogRequestのfallback登録
    registerFallbackValue(DialogRequest(type: DialogType.confirmDeleteDiary, completer: Completer()));
  });

  tearDown(() => container.dispose());

  group('deleteDiary', () {
    test('削除がキャンセルされた場合、Repositoryは呼ばれないこと', () async {
      // 1. ダイアログで「キャンセル(false)」が押されたシミュレーション
      when(() => mockDialog.show(any())).thenAnswer((invocation) {
        final request = invocation.positionalArguments[0] as DialogRequest;
        request.completer?.complete(false); // キャンセルを返す
      });

      // 2. ViewModel実行
      // familyプロバイダなので、引数にdummyDiaryを渡す
      await container.read(detailDiaryVMProvider(dummyDiary).notifier).deleteDiary();

      // 3. 検証
      verifyNever(() => mockRepo.delete(any()));
    });

    test('削除が承諾され、成功した場合、Repositoryが呼ばれローディングが制御されること', () async {
      // 1. セットアップ
      when(() => mockDialog.show(any())).thenAnswer((invocation) {
        final request = invocation.positionalArguments[0] as DialogRequest;
        request.completer?.complete(true); // 削除をタップ
      });
      when(() => mockRepo.delete('test-id')).thenAnswer((_) async => {});

      // ローディング状態を監視
      final loadingStates = <bool>[];
      container.listen<bool>(loadingProvider, (prev, next) {
        loadingStates.add(next);
      });

      // 2. 実行
      await container.read(detailDiaryVMProvider(dummyDiary).notifier).deleteDiary();

      // 3. 検証
      verify(() => mockRepo.delete('test-id')).called(1);

      // ローディングが true -> false と遷移したか
      expect(loadingStates, containsAllInOrder([true, false]));
    });

    test('削除中にエラーが発生した場合、stateにエラーメッセージが保持されること', () async {
      // 1. セットアップ（エラーを投げる）
      when(() => mockDialog.show(any())).thenAnswer((invocation) {
        final request = invocation.positionalArguments[0] as DialogRequest;
        request.completer?.complete(true); // 削除をタップ
      });
      when(
        () => mockRepo.delete(any()),
      ).thenThrow(DiaryException(message: 'データが見つからないため、削除されませんでした', code: DiaryErrorCode.notFound));

      // 2. 実行
      await container.read(detailDiaryVMProvider(dummyDiary).notifier).deleteDiary();

      // 3. 検証
      final state = container.read(detailDiaryVMProvider(dummyDiary));
      expect(state.value?.errorMessage, contains('データが見つからないため、削除されませんでした'));
    });
  });
}
