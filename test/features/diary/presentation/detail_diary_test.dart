import 'dart:async';

import 'package:ai_analysis_diary_app/core/utils/dialog_service.dart';
import 'package:ai_analysis_diary_app/core/utils/widget/app_dialog_listener.dart';
import 'package:ai_analysis_diary_app/features/auth/repository/auth_providers.dart';
import 'package:ai_analysis_diary_app/features/diary/model/diary_with_analysis.dart';
import 'package:ai_analysis_diary_app/features/diary/repository/diary_providers.dart';
import 'package:ai_analysis_diary_app/features/home/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_supabase.dart';
import '../../../helpers/test_helpers.dart';

final dummyDiaryData = [
  DiaryWithAnalysis(date: DateTime(2026, 04, 18), title: "ダミータイトル", description: "ダミー本文", postId: 'test-post-id'),
];

void main() {
  late MockDiaryRepository mockDiaryRepo;
  late MockUser mockUser;
  late MockDialogService mockDialogService;
  late StreamController<DialogRequest> dialogStreamController;
  late MockAuthRepository mockAuthRepo;

  setUpAll(() {
    registerFallbackValue(DialogRequest(type: DialogType.confirmDeleteDiary, completer: Completer()));
  });

  setUp(() {
    mockDiaryRepo = MockDiaryRepository();
    mockAuthRepo = MockAuthRepository();
    mockUser = MockUser();
    mockDialogService = MockDialogService();
    // broadcastにすることで、listenされる前にイベントが消えるのを防ぎます
    dialogStreamController = StreamController<DialogRequest>.broadcast();

    // MockUserのidを設定
    when(() => mockUser.id).thenReturn('test-user-id');
    // デリート実行は何も返さない
    when(() => mockDiaryRepo.delete(any())).thenAnswer((_) async {});
    // DialogServiceをMock化
    setupMockDialogService(mockDialogService, dialogStreamController);
  });

  tearDown(() {
    dialogStreamController.close();
  });

  testWidgets('削除ボタンをタップし、ダイアログで承諾すると、削除処理が実行され画面を閉じること', (tester) async {
    // ダミーデータを返す
    when(
      () => mockDiaryRepo.fetchDiariesWithAnalysis(
        userId: any(named: 'userId'),
        isDesc: any(named: 'isDesc'),
      ),
    ).thenAnswer((_) async => dummyDiaryData);

    // 初期表示
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          diaryRepositoryProvider.overrideWithValue(mockDiaryRepo),
          currentUserProvider.overrideWith((ref) => mockUser),
          dialogServiceProvider.overrideWithValue(mockDialogService),
          authRepositoryProvider.overrideWithValue(mockAuthRepo),
        ],
        child: MaterialApp(home: AppDialogListener(child: HomePage())),
      ),
    );

    await tester.pumpAndSettle();

    // 対象の記事をタップして詳細画面に遷移
    await tester.tap(find.text('ダミータイトル'));
    await tester.pumpAndSettle();

    // Home画面に返ってきたときに、何もデータが帰ってこない状況を再現
    when(
      () => mockDiaryRepo.fetchDiariesWithAnalysis(
        userId: any(named: 'userId'),
        isDesc: any(named: 'isDesc'),
      ),
    ).thenAnswer((_) async => []);

    // 削除ボタンを探してタップ
    await tester.tap(find.byKey(Key('削除ボタン')));
    await tester.pumpAndSettle();

    // ① ダイアログが表示されたか確認
    expect(find.text('日記削除確認'), findsOneWidget);

    // ② ダイアログ内の「削除」ボタンをタップ
    await tester.tap(find.byKey(Key('ダイアログ削除ボタン')));
    await tester.pumpAndSettle();

    // ③ デリート実行が一度だけ行われたことを確認
    verify(() => mockDiaryRepo.delete(any())).called(1);

    // ④ Home画面に戻ったことを確認
    expect(find.byType(HomePage), findsOneWidget);

    // ⑤ 対象のデータが存在しないことを確認
    expect(find.text('ダミータイトル'), findsNothing);
  });
}
