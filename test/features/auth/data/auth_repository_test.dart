import 'package:ai_analysis_diary_app/features/auth/data/auth_failure.dart';
import 'package:ai_analysis_diary_app/features/auth/data/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_supabase.dart';

void main() {
  late MockSupabaseClient mockClient;
  late MockSupabaseAuth mockAuth;
  late AuthRepository repo;

  setUp(() {
    mockClient = MockSupabaseClient();
    mockAuth = MockSupabaseAuth();

    when(() => mockClient.auth).thenReturn(mockAuth);

    repo = AuthRepository(mockClient);
  });

  group('AuthRepository SignUp', () {
    test('成功したら例外を投げない', () async {
      final mockRes = MockAuthResponse();

      // MockUser に email を設定
      final mockUser = MockUser();
      when(() => mockRes.user).thenReturn(mockUser);
      when(() => mockUser.email).thenReturn('test@example.com');

      // AuthRepositoryのsignUpを呼び出す
      when(
        () => mockAuth.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => mockRes);

      // 明示的に await して例外が出ないことを確認
      final user = await repo.signUp('test@example.com', 'pass123');

      expect(user.email, 'test@example.com');
      verify(
        () => mockAuth.signUp(email: 'test@example.com', password: 'pass123'),
      ).called(1);
    });

    test('エラーの場合は例外を投げる', () async {
      final mockRes = MockAuthResponse();
      when(() => mockRes.user).thenReturn(null);
      when(
        () => mockAuth.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => mockRes);

      // 非同期関数の例外は Future を渡して検証する
      await expectLater(
        () => repo.signUp('test@example.com', 'pass123'),
        throwsA(isA<AuthFailure>()),
      );
    });
  });

  group('AuthRepository singIn', () {
    test('成功したら例外を投げない', () async {
      final mockRes = MockAuthResponse();

      // MockUser に email を設定
      final mockUser = MockUser();
      when(() => mockRes.user).thenReturn(mockUser);
      when(() => mockUser.email).thenReturn('test@example.com');

      when(
        () => mockAuth.signInWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => mockRes);

      final user = await repo.signIn('test@example.com', 'pass123');

      expect(user.email, 'test@example.com');

      verify(
        () => mockAuth.signInWithPassword(
          email: 'test@example.com',
          password: 'pass123',
        ),
      ).called(1);
    });

    test('エラーの場合は例外を投げる', () async {
      final mockRes = MockAuthResponse();
      when(() => mockRes.user).thenReturn(null);
      when(
        () => mockAuth.signInWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => mockRes);
      await expectLater(
        () => repo.signIn('test@example.com', 'pass12'),
        throwsA(isA<AuthFailure>()),
      );
    });
  });

  group('AuthRepository signOut', () {
    test('signOutが呼ばれる', () async {
      when(() => mockAuth.signOut()).thenAnswer((_) async {});
      await repo.signOut();
      verify(() => mockAuth.signOut()).called(1);
    });
  });
}
