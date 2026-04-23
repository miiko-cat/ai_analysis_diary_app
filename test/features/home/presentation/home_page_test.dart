import 'package:ai_analysis_diary_app/features/auth/repository/auth_providers.dart';
import 'package:ai_analysis_diary_app/features/diary/model/diary.dart';
import 'package:ai_analysis_diary_app/features/diary/model/diary_with_analysis.dart';
import 'package:ai_analysis_diary_app/features/diary/model/sentiment.dart';
import 'package:ai_analysis_diary_app/features/diary/presentation/diary_form.dart';
import 'package:ai_analysis_diary_app/features/diary/repository/diary_providers.dart';
import 'package:ai_analysis_diary_app/features/home/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_supabase.dart';

void main() {
  late MockDiaryRepository mockDiaryRepository;
  late MockUser mockUser;

  setUp(() {
    mockDiaryRepository = MockDiaryRepository();
    mockUser = MockUser();

    // MockUserのidを設定
    when(() => mockUser.id).thenReturn('test-user-id');

    // DiaryWithAnalysis のfallback登録
    registerFallbackValue(DiaryWithAnalysis(date: DateTime.now(), title: "日記タイトルテスト", description: "日記詳細テスト"));
    // Diary のfallback登録
    registerFallbackValue(
      Diary(date: DateTime.now(), title: "日記タイトルテスト", description: "日記詳細テスト", userId: 'test-user-id'),
    );
  });

  group("カード", () {
    testWidgets("カードにタイトル、感情に応じたアイコン、本文が省略されて表示されていることを確認", (tester) async {
      // fetchDiariesWithAnalysis で テストデータを返す
      when(
        () => mockDiaryRepository.fetchDiariesWithAnalysis(
          userId: any(named: "userId"),
          isDesc: any(named: "isDesc"),
        ),
      ).thenAnswer(
        (_) async => <DiaryWithAnalysis>[
          // ポジティブ
          DiaryWithAnalysis(
            date: DateTime.now(),
            title: "日記タイトル_ポジティブテスト",
            description: "日記詳細テスト_ポジティブテスト",
            sentiment: Sentiment.positive,
          ),
          // ネガティブ
          DiaryWithAnalysis(
            date: DateTime.now(),
            title: "日記タイトル_ネガティブテスト",
            description: "日記詳細テスト_ネガティブテスト",
            sentiment: Sentiment.negative,
          ),
          // ニュートラル
          DiaryWithAnalysis(
            date: DateTime.now(),
            title: "日記タイトル_ニュートラルテスト",
            description: "日記詳細テスト_ニュートラルテスト",
            sentiment: Sentiment.neutral,
          ),
          // 感情無し
          DiaryWithAnalysis(date: DateTime.now(), title: "日記タイトル_感情無しテスト", description: "日記詳細テスト_感情無しテスト"),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // diaryRepositoryをMockに差し替え
            diaryRepositoryProvider.overrideWithValue(mockDiaryRepository),
            // currentUserをMockUserに差し替え
            currentUserProvider.overrideWith((ref) => mockUser),
          ],
          child: MaterialApp(home: HomePage()),
        ),
      );

      await tester.pump();

      /*** ポジティブテスト ***/
      // タイトルが見つかること
      expect(find.text("日記タイトル_ポジティブテスト"), findsOneWidget);
      // 詳細が見つかること
      expect(find.text("日記詳細テスト_ポジティブテスト"), findsOneWidget);
      // ポジティブに対応したアイコンが見つかること
      expect(find.byIcon(Icons.sentiment_very_satisfied), findsOneWidget);

      /*** ネガティブテスト ***/
      // タイトルが見つかること
      expect(find.text("日記タイトル_ネガティブテスト"), findsOneWidget);
      // 詳細が見つかること
      expect(find.text("日記詳細テスト_ネガティブテスト"), findsOneWidget);
      // ネガティブに対応したアイコンが見つかること
      expect(find.byIcon(Icons.sentiment_very_dissatisfied), findsOneWidget);

      /*** ニュートラルテスト ***/
      // タイトルが見つかること
      expect(find.text("日記タイトル_ニュートラルテスト"), findsOneWidget);
      // 詳細が見つかること
      expect(find.text("日記詳細テスト_ニュートラルテスト"), findsOneWidget);
      // ニュートラルに対応したアイコンが見つかること
      expect(find.byIcon(Icons.sentiment_neutral), findsOneWidget);

      /*** 感情無しテスト ***/
      // タイトルが見つかること
      expect(find.text("日記タイトル_感情無しテスト"), findsOneWidget);
      // 詳細が見つかること
      expect(find.text("日記詳細テスト_感情無しテスト"), findsOneWidget);
      // 感情無しに対応したアイコンが見つかること
      expect(find.byIcon(Icons.help_outline), findsOneWidget);
    });
  });

  group('日記投稿後Home画面遷移', () {
    testWidgets('日記投稿後、Home画面に戻った際に、即座に日記の内容が反映されていること', (tester) async {
      // 初期データ
      final initialData = [DiaryWithAnalysis(date: DateTime(2026, 04, 18), title: "既存タイトル", description: "既存詳細")];
      // 更新後データ
      final updatedData = [
        DiaryWithAnalysis(date: DateTime(2026, 04, 19), title: "新規タイトル", description: "新規詳細"),
        ...initialData,
      ];

      // 最初は既存の日記を返す
      when(
        () => mockDiaryRepository.fetchDiariesWithAnalysis(
          userId: any(named: 'userId'),
          isDesc: any(named: 'isDesc'),
        ),
      ).thenAnswer((_) async => initialData);
      // insertDiaryは成功を返す
      when(() => mockDiaryRepository.insertDiary(any())).thenAnswer(
        (_) async => Diary(
          date: DateTime(2026, 04, 19),
          title: "新規タイトル",
          description: "新規詳細",
          userId: 'test-user-id',
          postId: 'test-post-id',
        ),
      );

      // analyzeDiary, generateAdviceは成功を返す
      when(() => mockDiaryRepository.analyzeDiary(any(), any())).thenAnswer((_) async => null);
      when(() => mockDiaryRepository.generateAdvice(any(), any())).thenAnswer((_) async => null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            diaryRepositoryProvider.overrideWithValue(mockDiaryRepository),
            currentUserProvider.overrideWith((ref) => mockUser),
          ],
          child: MaterialApp(home: HomePage()),
        ),
      );

      await tester.pumpAndSettle();

      // ① 既存の日記が表示されていることを確認
      expect(find.text("既存タイトル"), findsOneWidget);

      // 日記を書くボタンをタップ
      await tester.tap(find.text("日記を書く"));
      await tester.pumpAndSettle();

      // ② 日記投稿画面に遷移したことを確認
      expect(find.byType(DiaryForm), findsOneWidget);

      // 投稿後は新しい日記を返す
      when(
        () => mockDiaryRepository.fetchDiariesWithAnalysis(
          userId: any(named: 'userId'),
          isDesc: any(named: 'isDesc'),
        ),
      ).thenAnswer((_) async => updatedData);

      // 日記を投稿
      await enterDiaryAndTapButton(title: '新規タイトル', description: '新規本文', tester: tester);
      await tester.pumpAndSettle();

      // ③ Home画面に戻ったことを確認
      expect(find.byType(HomePage), findsOneWidget);
      // ④ 新しい日記が即座に反映されていることを確認
      expect(find.text('新規タイトル'), findsOneWidget);
      // ⑤ 既存の日記も存在することを確認
      expect(find.text('既存タイトル'), findsOneWidget);
    });
  });
}

Future<void> enterDiaryAndTapButton({
  required String title,
  required String description,
  required WidgetTester tester,
}) async {
  // タイトルフィールド取得
  final emailField = find.ancestor(of: find.text('タイトル'), matching: find.byType(TextFormField));
  // 本文フィールド取得
  final passwordField = find.ancestor(of: find.text('本文'), matching: find.byType(TextFormField));

  // 入力
  await tester.enterText(emailField, title);
  await tester.enterText(passwordField, description);

  // 投稿ボタンをタップ
  await tester.tap(find.byType(ElevatedButton));
}
