import 'dart:async';

import 'package:ai_analysis_diary_app/features/auth/presentation/auth_page.dart';
import 'package:ai_analysis_diary_app/features/auth/repository/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../helpers/mock_supabase.dart';

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  group('ログイン画面', () {
    testWidgets(
        'ログイン処理中にCircularProgressIndicatorが2つ以上表示されない', (
        tester) async {
      // Completerを使って、テスト終了後にTimerが残らないようにする
      final completer = Completer<User>();

      // signInが呼ばれたら永遠に待ち続ける（ローディング状態を維持）
      when(() => mockAuthRepository.signIn(any(), any()))
          .thenAnswer((_) => completer.future);

      await tester.pumpWidget(
          ProviderScope(
              overrides: [
                // 本物のSupabase通信をMockに差し替え
                authRepositoryProvider.overrideWithValue(mockAuthRepository),
              ],
              child: MaterialApp(
                home: AuthPage(mode: AuthMode.login,),
              )
          )
      );

      // build()の完了を待つ（AsyncLoadingが解消されるまで）
      await tester.pumpAndSettle();

      // メールアドレスフィールド取得
      final emailField = find.ancestor(
          of: find.text('メールアドレス'),
          matching: find.byType(TextFormField)
      );
      // パスワードフィールド取得
      final passwordField = find.ancestor(
          of: find.text('パスワード'),
          matching: find.byType(TextFormField)
      );

      // 入力
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'Passw0rd1!');

      // ログインボタンタップ
      await tester.tap(find.byType(ElevatedButton));

      // ローディング状態をレンダリング（非同期処理は完了させない）
      await tester.pump();

      // CircularProgressIndicatorが一つだけ
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // テスト終了前にCompleterを完了させてタイマーを解消
      completer.completeError(Exception('テスト終了'));
      await tester.pumpAndSettle();
    });
  });
}