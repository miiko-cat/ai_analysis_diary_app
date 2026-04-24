import 'dart:async';

import 'package:ai_analysis_diary_app/features/auth/repository/auth_providers.dart';
import 'package:ai_analysis_diary_app/features/diary/model/diary.dart';
import 'package:ai_analysis_diary_app/features/diary/presentation/diary_form.dart';
import 'package:ai_analysis_diary_app/features/diary/repository/diary_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mock_supabase.dart';

void main() {
  late MockDiaryRepository mockDiaryRepository;
  late MockUser mockUser;

  setUp(() {
    mockDiaryRepository = MockDiaryRepository();
    mockUser = MockUser();

    // MockUserのidを設定
    when(() => mockUser.id).thenReturn('test-user-id');

    // Diaryのfallback登録
    registerFallbackValue(
        Diary(
            date: DateTime.now(),
            title: 'TestTitle',
            description: 'TestDescription',
            userId: 'test-user-id'
        )
    );
  });

  testWidgets('投稿処理中にCircularProgressIndicatorが2つ以上表示されない', (
      tester) async {
    // insertDiaryが呼ばれたら永遠に待ち続ける（ローディング状態を維持）
    final completer = Completer<Diary>();
    when(() => mockDiaryRepository.insertDiary(any())).thenAnswer(
        ((_) => completer.future));

    await tester.pumpWidget(
        ProviderScope(
            overrides: [
              // diaryRepositoryをMockに差し替え
              diaryRepositoryProvider.overrideWithValue(mockDiaryRepository),
              // currentUserをMockUserに差し替え
              currentUserProvider.overrideWith((ref) => mockUser),
            ],
            child: MaterialApp(
              home: DiaryForm(),
            )
        )
    );

    await tester.pump();

    // タイトルフィールド取得
    final titleField = find.ancestor(
      of: find.text('タイトル'),
      matching: find.byType(TextFormField),
    );
    // 本文フィールド取得入力
    final descriptionField =  find.ancestor(
      of: find.text('本文'),
      matching: find.byType(TextFormField),
    );

    // 入力
    await tester.enterText(titleField, 'テストタイトル');
    await tester.enterText(descriptionField, 'テスト本文');

    // 投稿ボタンタップ
    await tester.tap(find.byType(ElevatedButton));

    // ローディング状態をレンダリング（非同期処理は完了させない）
    await tester.pump();

    // CircularProgressIndicatorが一つだけ
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // テスト終了前にCompleterを完了させてタイマーを解消
    completer.completeError(Exception('テスト終了'));
    await tester.pumpAndSettle();
  });
}