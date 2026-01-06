import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth_page.dart';
import '../view_model/auth_state.dart';

class AuthForm extends ConsumerStatefulWidget {
  final AuthMode mode;
  final AsyncValue<AuthState> state;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onSubmit;
  final Function(BuildContext) onSwitchModeTap;

  const AuthForm({
    super.key,
    required this.mode,
    required this.state,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onSubmit,
    required this.onSwitchModeTap,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthFormState();
}

class _AuthFormState extends ConsumerState<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return widget.state.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          error.toString(),
          style: const TextStyle(color: Colors.red),
        ),
      ),
      data: (authState) {
        return Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.mode == AuthMode.login ? "ようこそ！" : "アカウント作成",
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              SizedBox(height: 12),

              /// メールアドレス入力
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'メールアドレス',
                  prefixIcon: Icon(Icons.email),
                ),
                onChanged: widget.onEmailChanged,
                validator: (_) => authState.emailError,
              ),

              SizedBox(height: 16),

              /// パスワード入力
              TextFormField(
                obscureText: _isObscure,
                keyboardType: TextInputType.visiblePassword,
                autofillHints: [AutofillHints.password],
                decoration: InputDecoration(
                  labelText: 'パスワード',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: _isObscure
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                  ),
                ),
                onChanged: widget.onPasswordChanged,
                validator: (_) => authState.passwordError,
              ),

              if (authState.errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  authState.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],

              SizedBox(height: 24),

              /// ログインボタン
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.state.isLoading ? null : widget.onSubmit,
                  child: widget.state.isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('ログイン'),
                ),
              ),

              SizedBox(height: 16),

              /// 新規登録またはログインへのリンク
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black87),
                  children: [
                    TextSpan(
                      text: widget.mode == AuthMode.login
                          ? 'アカウントがありませんか？'
                          : 'すでにアカウントをお持ちの方はこちら',
                    ),
                    TextSpan(text: '\n'),
                    TextSpan(
                      text: widget.mode == AuthMode.login
                          ? '新規ユーザ登録'
                          : 'ログイン画面',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => widget.onSwitchModeTap(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
