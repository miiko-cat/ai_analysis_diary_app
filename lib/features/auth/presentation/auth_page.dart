import 'package:ai_analysis_diary_app/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:ai_analysis_diary_app/features/auth/presentation/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/widget/app_loading_overlay.dart';
import 'auth_page_args.dart';

class AuthPage extends ConsumerWidget {
  final AuthMode mode;
  final String? initialEmail;
  final String? initialPassword;

  const AuthPage({
    super.key,
    required this.mode,
    this.initialEmail,
    this.initialPassword
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = AuthPageArgs(
      mode: mode,
      initialEmail: initialEmail ?? '',
      initialPassword: initialPassword ?? ''
    );
    final state = ref.watch(authViewModelProvider(args));
    final notifier = ref.read(authViewModelProvider(args).notifier);

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
