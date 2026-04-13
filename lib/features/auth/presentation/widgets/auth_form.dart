import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth_page_args.dart';
import '../view_model/auth_state.dart';

class AuthForm extends ConsumerStatefulWidget {
  final AuthMode mode;
  final AsyncValue<AuthState> state;
  final GlobalKey<FormState> formKey;
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
    required this.formKey,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthFormState();
}

class _AuthFormState extends ConsumerState<AuthForm> {
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
          key: widget.formKey ,
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
                // サインアップ成功時に渡ってきたEメールを表示
                initialValue: authState.email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'メールアドレス',
                  prefixIcon: Icon(Icons.email),
                ),
                onChanged: widget.onEmailChanged,
                validator: validateEmail,
              ),

              SizedBox(height: 16),

              /// パスワード入力
              TextFormField(
                // サインアップ成功時に渡ってきたパスワードを表示
                initialValue: authState.password,
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
                validator: validatePassword,
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
                  onPressed: widget.onSubmit,
                  child: widget.mode == AuthMode.login
                      ? Text('ログイン')
                      : Text('サインアップ'),
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
