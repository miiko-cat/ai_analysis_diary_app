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
    });

    test('データが見つからない場合、notFoundコードのDiaryExceptionが投げられること', () async {
      final targetId = 'non-existent-id';

      final mockQueryBuilder = MockPostgrestQueryBuilder();
      final mockFilterBuilder = MockPostgrestFilterBuilder();
      final mockTransformBuilder = MockPostgrestTransformBuilder();

      // 1. from('diary')
      when(() => mockClient.from('diary')).thenReturn(mockQueryBuilder);

      // 2. delete()
      when(() => mockQueryBuilder.delete()).thenReturn(mockFilterBuilder);

      // 3. eq('post_id', targetId)
      when(() => mockFilterBuilder.eq('post_id', targetId)).thenReturn(mockFilterBuilder);

      // 4. select()
      when(() => mockFilterBuilder.select()).thenReturn(mockTransformBuilder);

      // 5. maybeSingle()
      when(() => (mockClient.from('diary').delete().eq('post_id', targetId).select().maybeSingle() as Future<Map<String, dynamic>?>)).thenAnswer((_) async => null);

      // when(() => (mockTransformBuilder.maybeSingle() as Future<Map<String, dynamic>?>)).thenAnswer((_) async => null);

      // 実行と検証
      await expectLater(
        () => repo.delete(targetId),
        throwsA(isA<DiaryException>()
          .having((e) => e.code, 'errorCode', DiaryErrorCode.notFound)
          .having((e) => e.message, 'errorMessage', 'データが見つからないため、削除されませんでした')
        ),
      );
    }, skip: 'Supabaseのモック化が複雑なため一旦スキップ');
  });
}
