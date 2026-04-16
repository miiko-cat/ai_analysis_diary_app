import 'package:ai_analysis_diary_app/features/auth/repository/auth_providers.dart';
import 'package:ai_analysis_diary_app/features/diary/model/diary_with_analysis.dart';
import 'package:ai_analysis_diary_app/features/diary/model/sentiment.dart';
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

    // DiaryWithAnalysis のfallbak登録
    registerFallbackValue(
        DiaryWithAnalysis(
          postId: "post-id-test",
          userId: "user-id-test",
          date: DateTime.now(),
          title: "日記タイトルテスト",
          description: "日記詳細テスト",
          sentiment: Sentiment.positive,
        )
    );
  });

  group("カード", () {
    testWidgets("カードにタイトル、感情に応じたアイコン、本文が省略されて表示されていることを確認", (tester) async {
      // fetchDiariesWithAnalysis で テストデータを返す
      when(() => mockDiaryRepository.fetchDiariesWithAnalysis(
        userId: any(named: "userId"),
        isDesc: any(named: "isDesc")
      )
      ).thenAnswer((_) async => <DiaryWithAnalysis>[
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
        DiaryWithAnalysis(
          date: DateTime.now(),
          title: "日記タイトル_感情無しテスト",
          description: "日記詳細テスト_感情無しテスト",
        ),
      ]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // diaryRepositoryをMockに差し替え
            diaryRepositoryProvider.overrideWithValue(mockDiaryRepository),
            // currentUserをMockUserに差し替え
            currentUserProvider.overrideWith((ref) => mockUser),
          ],
          child: MaterialApp(
            home: HomePage(),
          )
        )
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
}