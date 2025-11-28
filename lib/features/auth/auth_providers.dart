import 'package:ai_analysis_diary_app/features/auth/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Supabase クライアント
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// 認証 Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseProvider));
});

// 認証状態監視（StreamProvider）
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// ログインユーザを返す Provider
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(supabaseProvider).auth.currentUser;
});
