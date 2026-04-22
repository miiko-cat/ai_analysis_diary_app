import 'dart:async';

import 'package:ai_analysis_diary_app/features/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    // 認証リポジトリ
    final authRepo = ref.watch(authRepositoryProvider);

    // ケースによりダイアログを使い分ける
    switch (request.type) {
      case DialogType.signupSuccess:
        signUpSuccessDialog(context, request.email, request.password);
        break;

      case DialogType.confirmLogout:
        confirmLogoutDialog(context, authRepo);
        break;

      case DialogType.confirmDeleteDiary:
        // 削除ボタンを押した際に、trueを返す
        confirmDeleteDialog(context).then((result) => {
          request.completer?.complete(result ?? false)
        });
        break;
    }
  }
}

// サインアップ成功ダイアログ
Future<Null> signUpSuccessDialog(BuildContext context, String? email, String? password) {
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('サインアップ成功'),
      content: const Text(
        '登録したメールアドレスにメールを送信しました。\n\n'
        'メールのリンクをタップし、ログインしてください。',
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('OK'))],
    ),
  ).then((result) {
    if (result == true && context.mounted) {
      // ログイン画面にメール・パスワードを渡して遷移
      Navigator.pop(context, (email: email, password: password));
    }
  });
}

// ログアウト確認ダイアログ
Future<Null> confirmLogoutDialog(BuildContext context, AuthRepository authRepo) {
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('ログアウト確認'),
      content: const Text('本当にログアウトしますか？'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('キャンセル')),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text('ログアウト'),
        ),
      ],
    ),
  ).then((result) async {
    if (result == true && context.mounted) {
      await authRepo.signOut();
    }
  });
}

// 削除確認ダイアログ
Future<bool?> confirmDeleteDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('日記削除確認'),
      content: const Text('本当に日記を削除しますか？'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('キャンセル')),
        TextButton(
          key: Key('ダイアログ削除ボタン'),
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text('削除'),
        ),
      ],
    ),
  );
}
