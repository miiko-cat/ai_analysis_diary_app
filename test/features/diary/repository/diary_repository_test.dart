import 'package:ai_analysis_diary_app/features/diary/domain/diary_exception.dart';
import 'package:ai_analysis_diary_app/features/diary/repository/diary_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mock_supabase.dart';

void main() {
  late MockSupabaseClient mockClient;
  late DiaryRepository repo;

  setUp(() {
    mockClient = MockSupabaseClient();
    repo = DiaryRepository(mockClient);
  });

  group('deleteメソッド', () {
    test('postIdがnullの場合、invalidPostIdコードが返ってくるか', () async {
      await expectLater(
        () => repo.delete(null),
        throwsA(isA<DiaryException>()
          // エラーコードチェック
          .having((e) => e.code, 'errorCode', DiaryErrorCode.invalidPostId)
          // エラーメッセージチェック
          .having((e) => e.message, 'errorMessage', '削除対象のポストIDがありません')
        ),
      );
    });
  });
}
