import 'dart:async';

import 'package:ai_analysis_diary_app/features/auth/domain/validate_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/utils/dialog_service.dart';
import '../../../../core/utils/widget/app_loading_overlay.dart';
import '../../repository/auth_providers.dart';
import '../auth_page.dart';
import 'auth_state.dart';

final authViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<AuthViewModel, AuthState, AuthMode>(AuthViewModel.new);

class AuthViewModel extends AsyncNotifier<AuthState> {
  final AuthMode _mode;

  AuthViewModel(this._mode);

  // 認証Repository取得
  late final _repository = ref.read(authRepositoryProvider);

  // 共通DialogService取得
  late final _dialogService = ref.read(dialogServiceProvider);

  // ローディング状態管理
  late final StateController<bool> _loadingController = ref.read(
    loadingProvider.notifier,
  );

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
    if (!current.isValid || state.isLoading) {
      return;
    }

    // ローディング中
    _loadingController.state = true;
    try {
      if (_mode == AuthMode.login) {
        // ログイン
        await _repository.signIn(current.email, current.password);
      } else {
        // サインアップとDialog表示
        await _repository.signUp(current.email, current.password);
        _dialogService.show(DialogRequest(DialogType.signupSuccess));
      }
      state = AsyncData(current);
    } catch (e) {
      state = AsyncData(current.copyWith(errorMessage: e.toString()));
    } finally {
      // ローディング解除
      _loadingController.state = false;
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
