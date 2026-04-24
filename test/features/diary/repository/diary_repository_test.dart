import 'dart:async';

import 'package:ai_analysis_diary_app/features/diary/domain/diary_exception.dart';
import 'package:ai_analysis_diary_app/features/diary/repository/diary_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_supabase.dart';

void main() {
  late MockSupabaseClient mockClient;
  late DiaryRepository repo;

  setUp(() {
    mockClient = MockSupabaseClient();
    repo = DiaryRepository(mockClient);
  });

  group('updateメソッド', () {
    test('正しい引数を渡したときに、updateが呼ばれ、Diaryオブジェクトに変換されるか', () async {
      final mockQueryBuilder = MockPostgrestQueryBuilder();
      final mockFilterBuilder = MockPostgrestFilterBuilder();
      final mockTransformBuilder = MockPostgrestTransformBuilder();

      // 1. from('diary') が呼ばれたら QueryBuilder を返す
      when(() => mockClient.from('diary')).thenAnswer((_) => mockQueryBuilder);

      // 2. update(...) が呼ばれたら FilterBuilder を返す
      when(() => mockQueryBuilder.update(any())).thenAnswer((_) => mockFilterBuilder);

      // 3. eq(...) が呼ばれたら FilterBuilder (自身) を返す
      when(() => mockFilterBuilder.eq(any(), any())).thenAnswer((_) => mockFilterBuilder);

      // 4. select() が呼ばれたら TransformBuilder を返す
      when(() => mockFilterBuilder.select()).thenAnswer((_) => mockFilterBuilder);

      // 5. maybeSingle() は TransformBuilder を返す
      when(() => mockFilterBuilder.maybeSingle()).thenAnswer((_) => mockTransformBuilder);

      // 6. mockTransformBuilderがawaitされたときに、最終的なデータを返す
      when(() => mockTransformBuilder.then(any())).thenAnswer((invocation) {
        // 第1引数（callback）を取り出す
        final callback =
            invocation.positionalArguments[0] as FutureOr<Map<String, dynamic>?> Function(Map<String, dynamic>?);
        // 返したいダミーデータ
        final mockData = <String, dynamic>{
          'post_id': 'test-id',
          'date': DateTime.now().toIso8601String(),
          'title': 'テストタイトル',
          'description': 'テスト本文',
          'user_id': 'test-user-id',
          'updated_date': null,
        };
        // callback を実行してその結果を Future で包んで返す
        return Future.value(callback(mockData));
      });

      // when(() => mockTransformBuilder.then(any <FutureOr<Map<String, dynamic>?>> Function(Map<String, dynamic>?)>
      //   (_) async => <String, dynamic>{
      //     'date': DateTime.now().toIso8601String(),
      //     'title': 'テストタイトル',
      //     'description': 'テスト本文',
      //     'userId': 'test-user-id',
      //     'updated_date': null,
      //   },
      // );

      // 実行
      final result = await repo.updateDiary(
        postId: 'test-post-id',
        title: 'テストタイトル',
        description: 'テスト本文',
        updatedDate: DateTime.now().toIso8601String(),
      );
      // 検証
      expect(result.title, 'テストタイトル');
    });
  });

  group('deleteメソッド', () {
    test('postIdがnullの場合、invalidPostIdコードのDiaryExceptionが投げられること', () async {
      await expectLater(
        () => repo.delete(null),
        throwsA(
          isA<DiaryException>()
              // エラーコードチェック
              .having((e) => e.code, 'errorCode', DiaryErrorCode.invalidPostId)
              // エラーメッセージチェック
              .having((e) => e.message, 'errorMessage', '削除対象のポストIDがありません'),
        ),
      );
    }, skip: 'Supabaseのモック化が複雑なため一旦スキップ');

    test('データが見つからない場合、notFoundコードのDiaryExceptionが投げられること', () async {
      final targetId = 'non-existent-id';

      final mockQueryBuilder = MockPostgrestQueryBuilder();
      final mockFilterBuilder = MockPostgrestFilterBuilder();
      // final mockTransformBuilder = MockPostgrestTransformBuilder();

      // 1. from('diary')
      when(() => mockClient.from('diary')).thenReturn(mockQueryBuilder);

      // 2. delete()
      when(() => mockQueryBuilder.delete()).thenReturn(mockFilterBuilder);

      // 3. eq('post_id', targetId)
      when(() => mockFilterBuilder.eq('post_id', targetId)).thenReturn(mockFilterBuilder);

      // 4. select()
      when(() => mockFilterBuilder.select()).thenReturn(mockFilterBuilder);

      // 5. maybeSingle()
      when(
        () =>
            (mockClient.from('diary').delete().eq('post_id', targetId).select().maybeSingle()
                as Future<Map<String, dynamic>?>),
      ).thenAnswer((_) async => null);

      // when(() => (mockTransformBuilder.maybeSingle() as Future<Map<String, dynamic>?>)).thenAnswer((_) async => null);

      // 実行と検証
      await expectLater(
        () => repo.delete(targetId),
        throwsA(
          isA<DiaryException>()
              .having((e) => e.code, 'errorCode', DiaryErrorCode.notFound)
              .having((e) => e.message, 'errorMessage', 'データが見つからないため、削除されませんでした'),
        ),
      );
    }, skip: 'Supabaseのモック化が複雑なため一旦スキップ');
  });
}
