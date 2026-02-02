import 'package:ai_analysis_diary_app/features/auth/repository/auth_failure.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient supabase;

  AuthRepository(this.supabase);

  Future<User> signUp(String email, String password) async {
    // Webアプリの場合、リダイレクトURL取得
    // モバイルの場合、指定なし
    final redirectUrl = kIsWeb ? Uri.base.origin : null;
    final res = await supabase.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: redirectUrl,
    );

    final user = res.user;
    if (user == null) {
      throw AuthFailure('既にアカウントが登録されています');
    }

    return user;
  }

  Future<User> signIn(String email, String password) async {
    final res = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = res.user;
    if (user == null) {
      throw AuthFailure('ログインに失敗しました');
    }

    return user;
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;
}
