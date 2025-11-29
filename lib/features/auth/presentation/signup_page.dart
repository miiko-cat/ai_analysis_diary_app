import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_providers.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authRepo = ref.watch(authRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text('新規登録')),
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
                  await authRepo.signUp(emailCtrl.text, passCtrl.text);
                },
                child: Text('登録'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
