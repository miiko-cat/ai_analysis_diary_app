import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dialog_service.dart';

class AppDialogListener extends ConsumerWidget {
  final Widget child;

  const AppDialogListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<DialogService>(
      dialogServiceProvider,
          (_, _) {},
    );

    ref.listen(
      dialogServiceProvider.select((s) => s.stream),
          (_, stream) {
        stream.listen((request) {
          _showDialog(context, request);
        });
      },
    );

    return child;
  }

  void _showDialog(BuildContext context, DialogRequest request) {
    switch (request.type) {
      case DialogType.signupSuccess:
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('サインアップ成功'),
            content: const Text(
              '登録したメールアドレスにメールを送信しました。\n\n'
                  'メールのリンクをタップし、ログインしてください。',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        break;

      case DialogType.confirmLogout:
        showDialog(
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
                  Navigator.pop(context);
                  // 実際のログアウト処理
                },
                child: const Text('ログアウト'),
              ),
            ],
          ),
        );
        break;
    }
  }
}