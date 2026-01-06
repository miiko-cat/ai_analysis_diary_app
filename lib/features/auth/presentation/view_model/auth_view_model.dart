import 'dart:async';

import 'package:ai_analysis_diary_app/features/auth/domain/validate_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repository/auth_providers.dart';
import '../auth_page.dart';
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
    // バリデーションNG or ローディング中
    if (!current.isValid || current.isLoading) {
      return;
    }
    state = AsyncData(current.copyWith(isLoading: true));

    try {
      final result = _mode == AuthMode.login
          ? await _repository.signIn(current.email, current.password)
          : await _repository.signUp(current.email, current.password);

      state = AsyncData(current);
    } catch (e) {
      state = AsyncData(current.copyWith(errorMessage: e.toString()));
    } finally {
      state = AsyncData(current.copyWith(isLoading: false));
    }
  }

  void onSwitchModeTap(BuildContext context) {
    if (_mode == AuthMode.login) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AuthPage(mode: AuthMode.signup),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }
}
