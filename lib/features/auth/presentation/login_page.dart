import 'package:ai_analysis_diary_app/features/auth/presentation/signup_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/logger_manager.dart';
import '../data/auth_providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authRepo = ref.watch(authRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text('ログイン')),
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "ようこそ！",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),

                          SizedBox(height: 12),

                          /// メールアドレス入力
                          TextFormField(
                            controller: emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'メールアドレス',
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'メールアドレスを入力してください';
                              }
                              if (!value.contains("@")) {
                                return 'メールアドレスの形式が正しくありません';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 16),

                          /// パスワード入力
                          TextFormField(
                            controller: passCtrl,
                            decoration: InputDecoration(
                              labelText: 'パスワード',
                              prefixIcon: Icon(Icons.lock),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'パスワードを入力してください';
                              }
                              if (value.length < 6) {
                                return "6文字以上のパスワードを入力してください";
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 24),

                          /// ログインボタン
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      // ヴァリデーションが失敗しているなら何もしない
                                      if (!_formKey.currentState!.validate()) {
                                        return;
                                      }
                                      // ローディング中のフラグ更新
                                      setState(() {
                                        isLoading = true;
                                      });

                                      try {
                                        await authRepo.signIn(
                                          emailCtrl.text,
                                          passCtrl.text,
                                        );
                                      } catch (e, st) {
                                        // ログにエラーの詳細を残す
                                        LoggerManager().error(
                                          'ログイン失敗',
                                          error: e,
                                          stackTrace: st,
                                        );
                                        // SnackBarを表示
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'ログインに失敗しました。メールとパスワードを確認してください。',
                                            ),
                                          ),
                                        );
                                      } finally {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    },
                              child: isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text('ログイン'),
                            ),
                          ),

                          SizedBox(height: 16),

                          /// 新規登録へのリンク
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.black87),
                              children: [
                                TextSpan(text: 'アカウントがありませんか？'),
                                TextSpan(text: '\n'),
                                TextSpan(
                                  text: '新規ユーザ登録',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SignupPage(),
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
