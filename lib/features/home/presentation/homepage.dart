import 'package:ai_analysis_diary_app/features/diary/presentation/create_diary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/auth_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.watch(authRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('ホーム'),
        actions: [
          IconButton(
            onPressed: () => authRepo.signOut(),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(child: Text('ログイン済み！')),
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateDiary()),
          );
        },
        icon: Icon(Icons.create),
      ),
    );
  }
}
