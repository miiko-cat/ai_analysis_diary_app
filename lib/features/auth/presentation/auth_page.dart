import 'package:ai_analysis_diary_app/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:ai_analysis_diary_app/features/auth/presentation/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/widget/app_loading_overlay.dart';
import 'auth_mode.dart';

class AuthPage extends ConsumerWidget {
  final AuthMode mode;

  const AuthPage({super.key, required this.mode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authViewModelProvider(mode));
    final notifier = ref.read(authViewModelProvider(mode).notifier);

    // stateの変化を監視してTextControllerに反映
    ref.listen(authViewModelProvider(mode), (previous, next) {
      final nextValue = next.value;
      if (nextValue == null) return;

      // 現在の入力値と違う場合のみ反映
      if (notifier.emailController.text != nextValue.email) {
        notifier.emailController.text = nextValue.email;
      }
      if (notifier.passwordController.text != nextValue.password) {
        notifier.passwordController.text = nextValue.password;
      }
    });

    return AppLoadingOverlay(
      child: Scaffold(
        appBar: AppBar(title: Text(mode == AuthMode.login ? 'ログイン' : 'サインアップ')),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight * 0.8,
                ),
                child: Center(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: AuthForm(
                        mode: mode,
                        state: state,
                        formKey: notifier.formKey,
                        emailController: notifier.emailController,
                        passwordController: notifier.passwordController,
                        onEmailChanged: notifier.onEmailChanged,
                        onPasswordChanged: notifier.onPasswordChanged,
                        onSubmit: notifier.submit,
                        onSwitchModeTap: notifier.onSwitchModeTap,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
