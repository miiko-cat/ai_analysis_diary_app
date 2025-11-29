import 'package:ai_analysis_diary_app/features/auth/presentation/signup_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authRepo = ref.watch(authRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text('ログイン')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(labelText: 'メールアドレス'),
              ),
              TextField(
                controller: passCtrl,
                decoration: InputDecoration(labelText: 'パスワード'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await authRepo.signIn(emailCtrl.text, passCtrl.text);
                },
                child: Text('ログイン'),
              ),
              SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  text: '新規ユーザ登録',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
