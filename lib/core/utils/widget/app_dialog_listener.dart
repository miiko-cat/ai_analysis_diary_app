import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/presentation/auth_page.dart';
import '../../../features/auth/presentation/auth_page_args.dart';
import '../../../features/auth/repository/auth_providers.dart';
import '../dialog_service.dart';

class AppDialogListener extends ConsumerStatefulWidget {
  final Widget child;

  const AppDialogListener({super.key, required this.child});

  @override
  ConsumerState<AppDialogListener> createState() => _AppDialogListenerState();
}

class _AppDialogListenerState extends ConsumerState<AppDialogListener> {
  StreamSubscription<DialogRequest>? _subscription;

  @override
  void initState() {
    super.initState();

    final service = ref.read(dialogServiceProvider);
    _subscription = service.stream.listen((request) {
      if (!mounted) return;
      _showDialog(request);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(DialogRequest request) {
    final authRepo = ref.watch(authRepositoryProvider);

    switch (request.type) {
      case DialogType.signupSuccess:
        showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('サインアップ成功'),
            content: const Text(
              '登録したメールアドレスにメールを送信しました。\n\n'
              'メールのリンクをタップし、ログインしてください。',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('OK'),
              ),
            ],
          ),
        ).then((result) {
          if (result == true && mounted) {
            // ログイン画面にメール・パスワードを渡して遷移
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => AuthPage(
                  mode: AuthMode.login,
                  initialEmail: request.email,
                  initialPassword: request.password,
                ),
              ),
            );
          }
        });
        break;

      case DialogType.confirmLogout:
        showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('ログアウト確認'),
            content: const Text('本当にログアウトしますか？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('キャンセル'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('ログアウト'),
              ),
            ],
          ),
        ).then((result) async {
          if (result == true && mounted) {
            await authRepo.signOut();
          }
        });
        break;
    }
  }
}
