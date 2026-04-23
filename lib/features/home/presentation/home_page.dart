import 'package:ai_analysis_diary_app/features/diary/presentation/diary_form.dart';
import 'package:ai_analysis_diary_app/features/diary/presentation/detail_diary.dart';
import 'package:ai_analysis_diary_app/features/home/presentation/widgets/sort_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/dialog_service.dart';
import '../../auth/repository/auth_providers.dart';
import '../../diary/repository/diary_providers.dart';
import 'widgets/display_list.dart';
import 'widgets/filter_bar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  String? _selectedSentiment; // null = 全件
  bool _isDesc = true; // true = 新しい順

  @override
  Widget build(BuildContext context) {
    // ログイン中のユーザを取得
    final currentUser = ref.watch(currentUserProvider);
    // 最終ログアウト確認を実装
    // TODO 後でViewModel化
    final dialogService = ref.read(dialogServiceProvider);

    // FutureProviderで日記一覧を取得
    final diariesAsync = ref.watch(
      diariesProvider((userId: currentUser!.id, sentiment: _selectedSentiment, isDesc: _isDesc)),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('日記一覧'),
        actions: [
          IconButton(
            onPressed: () => dialogService.show(DialogRequest(type: DialogType.confirmLogout)),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          FilterBar(
            selectedSentiment: _selectedSentiment,
            onChanged: (sentiment) {
              setState(() {
                _selectedSentiment = sentiment;
              });
            },
          ),
          SortBar(
            isDesc: _isDesc,
            onToggle: () {
              setState(() {
                _isDesc = !_isDesc;
              });
            },
          ),
          Expanded(
            child: diariesAsync.when(
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('エラー: $e')),
              data: (diaries) {
                if (diaries.isEmpty) {
                  return const Center(child: Text('日記がまだありません'));
                }
                return DisplayList(
                  diaries: diaries,
                  navigateToDetail: (diary) async {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => DetailDiary(diary: diary)));
                    // 詳細画面から戻ってきたら再取得
                    ref.invalidate(diariesProvider);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) => DiaryForm()));
            // 投稿画面から戻ってきたら再取得
            ref.invalidate(diariesProvider);
          },
          label: Text('日記を書く'),
          icon: Icon(Icons.create),
          tooltip: '新しい日記を作成',
          elevation: 4,
        ),
      ),
    );
  }
}
