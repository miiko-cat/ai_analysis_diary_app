import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient supabase;

  AuthRepository(this.supabase);

  Future<void> signUp(String email, String password) async {
    final res = await supabase.auth.signUp(email: email, password: password);
    if (res.user == null) {
      throw Exception('サインアップに失敗しました');
    }
  }

  Future<void> signIn(String email, String password) async {
    final res = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (res.user == null) {
      throw Exception('ログインに失敗しました');
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;
}
