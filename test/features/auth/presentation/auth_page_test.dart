import 'dart:async';

import 'package:ai_analysis_diary_app/core/utils/widget/app_dialog_listener.dart';
import 'package:ai_analysis_diary_app/features/auth/presentation/auth_page.dart';
import 'package:ai_analysis_diary_app/features/auth/presentation/auth_page_args.dart';
import 'package:ai_analysis_diary_app/features/auth/repository/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../helpers/mock_supabase.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockUser mockUser;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockUser = MockUser();
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

  group('サインアップ画面', () {
    testWidgets('サインアップ成功後にダイアログが表示され、OKタップ後ログイン画面にメールとパスワードが表示される', (tester) async {
      // signUpが成功するようにMockを設定
      when(() => mockAuthRepository.signUp(any(), any()))
        .thenAnswer((_) async => mockUser);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // 本物のSupabase通信をMockに差し替え
            authRepositoryProvider.overrideWithValue(mockAuthRepository),
          ],
          child: MaterialApp(
            // ダイアログをサインアップ後に表示されるために、
            // AppDialogListenerでラップ
            home: AppDialogListener(child: AuthPage(mode: AuthMode.signup)),
          ),
        )
      );
      await tester.pumpAndSettle();

      // テストデータ
      final testEmail = 'test@example.com';
      final testPassword = 'Passw0rd1!';

      // サインアップ時メールアドレスフィールド取得
      final signUpEmailField = find.ancestor(
          of: find.text('メールアドレス'),
          matching: find.byType(TextFormField)
      );
      // サインアップ時パスワードフィールド取得
      final signUpPasswordField = find.ancestor(
          of: find.text('パスワード'),
          matching: find.byType(TextFormField)
      );

      // 入力
      await tester.enterText(signUpEmailField, testEmail);
      await tester.enterText(signUpPasswordField, testPassword);

      // SignUpボタンをタップ
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // ① ダイアログが表示されることを確認
      expect(find.text('サインアップ成功'), findsOneWidget);

      // OKボタンをタップ
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // ② ログイン画面に遷移していることを確認
      expect(
        find.byWidgetPredicate(
          (widget) => widget is AuthPage && widget.mode == AuthMode.login
        ),
        findsOneWidget
      );

      // ③ メールアドレス、パスワードがデフォルト表示されていることを確認
      expect(find.text(testEmail), findsOneWidget);
      expect(find.text(testPassword), findsOneWidget);
    });

    testWidgets('サインアップ時にCircularProgressIndicatorが2つ以上表示されない', (tester) async {
      // Completerを使って、テスト終了後にTimerが残らないようにする
      final completer = Completer<User>();

      // signUpが呼ばれたら永遠に待ち続ける（ローディング状態を維持）
      when(() => mockAuthRepository.signUp(any(), any()))
          .thenAnswer((_) => completer.future);

      await tester.pumpWidget(
          ProviderScope(
              overrides: [
                // 本物のSupabase通信をMockに差し替え
                authRepositoryProvider.overrideWithValue(mockAuthRepository),
              ],
              child: MaterialApp(
                home: AuthPage(mode: AuthMode.signup,),
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

      // SignUpボタンをタップ
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