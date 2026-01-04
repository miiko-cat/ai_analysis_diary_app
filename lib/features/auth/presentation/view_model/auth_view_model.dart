import 'dart:async';

import 'package:ai_analysis_diary_app/features/auth/domain/validate_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repository/auth_providers.dart';
import '../auth_mode.dart';
import 'auth_state.dart';

final authViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<AuthViewModel, AuthState, AuthMode>(AuthViewModel.new);

class AuthViewModel extends AsyncNotifier<AuthState> {
  final AuthMode _mode;

  AuthViewModel(this._mode);

  late final _repository = ref.read(authRepositoryProvider);

  @override
  Future<AuthState> build() async {
    // 初期状態
    return const AuthState();
  }

  // ====== 入力更新 ======
  void onEmailChanged(String value) {
    state = AsyncData(
      state.requireValue.copyWith(
        email: value,
        emailError: validateEmail(value),
      ),
    );
  }

  void onPasswordChanged(String value) {
    state = AsyncData(
      state.requireValue.copyWith(
        password: value,
        passwordError: validatePassword(value),
      ),
    );
  }

  // ====== 送信処理 ======
  Future<void> submit() async {
    final current = state.requireValue;

    state = const AsyncLoading();

    final result = _mode == AuthMode.login
        ? await _repository.signIn(current.email, current.password)
        : await _repository.signUp(current.email, current.password);

    result.fold(
      (failure) {
        state = AsyncData(current.copyWith(errorMessage: failure.message));
      },
      (_) {
        state = AsyncData(current);
      },
    );
  }
}
