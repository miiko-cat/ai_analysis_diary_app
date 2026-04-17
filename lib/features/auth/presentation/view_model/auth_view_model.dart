import 'dart:async';

import 'package:ai_analysis_diary_app/features/auth/presentation/auth_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/dialog_service.dart';
import '../../../../core/utils/widget/app_loading_overlay.dart';
import '../../domain/auth_error_handling.dart';
import '../../repository/auth_providers.dart';
import '../auth_page.dart';
import 'auth_state.dart';

final authViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<AuthViewModel, AuthViewState, AuthMode>(AuthViewModel.new);

class AuthViewModel extends AsyncNotifier<AuthViewState> {
  final AuthMode _mode;
  AuthViewModel(this._mode);

  // GlobalKeyでヴァリデーションチェック
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // コントローラーを定義
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 認証Repository取得
  late final _repository = ref.read(authRepositoryProvider);

  // 共通DialogService取得
  late final _dialogService = ref.read(dialogServiceProvider);

  // ローディング状態管理
  late final StateController<bool> _loadingController = ref.read(
    loadingProvider.notifier,
  );

  @override
  Future<AuthViewState> build() async {
    // 初期状態
    return AuthViewState();
  }

  // ====== 入力更新 ======
  void onEmailChanged(String value) {
    state = AsyncData(
      state.requireValue.copyWith(
        email: value,
      ),
    );
  }

  void onPasswordChanged(String value) {
    state = AsyncData(
      state.requireValue.copyWith(
        password: value,
      ),
    );
  }

  // ====== 送信処理 ======
  Future<void> submit() async {
    final currentState = state.requireValue;
    final currentFormKeyState = formKey.currentState;

    // バリデーションNG or ローディング中
    if (!currentFormKeyState!.validate() ||
        state.isLoading ||
        _loadingController.state
    ) {
      return;
    }

    // ローディング中
    _loadingController.state = true;
    try {
      if (_mode == AuthMode.login) {
        // ログイン
        await _repository.signIn(currentState.email, currentState.password);
      } else {
        // サインアップとDialog表示
        await _repository.signUp(currentState.email, currentState.password);
        _dialogService.show(
            DialogRequest(
              type : DialogType.signupSuccess,
              email: currentState.email,
              password: currentState.password
            )
        );
      }
      state = AsyncData(currentState);
    } on AuthApiException catch (e) {
      state = AsyncData(currentState.copyWith(errorMessage: authErrorHandling(e)));
    } catch (e) {
      state = AsyncData(currentState.copyWith(errorMessage: e.toString()));
    } finally {
      // ローディング解除
      _loadingController.state = false;
    }
  }

  void onSwitchModeTap(BuildContext context) async {
    if (_mode == AuthMode.login) {
      final result = await Navigator.push<({String email, String password})>(
        context,
        MaterialPageRoute(
          builder: (context) => AuthPage(mode: AuthMode.signup),
        ),
      );

      if (result != null && context.mounted) {
        // サインアップ画面から返ってきたメールとパスワードをセット
        state = AsyncData(
          state.requireValue.copyWith(
            email: result.email,
            password: result.password,
          ),
        );
      }
    } else {
      // Navigator.pop(context);
      Navigator.pop(context, (
          email: state.requireValue.email,
          password: state.requireValue.password
      ));
    }
  }
}
