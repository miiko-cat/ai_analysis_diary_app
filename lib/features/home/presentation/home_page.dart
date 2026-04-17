import 'package:ai_analysis_diary_app/features/diary/presentation/create_diary.dart';
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
    // 日記関連のRepositoryを取得
    final diaryRepository = ref.watch(diaryRepositoryProvider);
    // ログイン中のユーザを取得
    final currentUser = ref.watch(currentUserProvider);
    // 最終ログアウト確認を実装
    // TODO 後でViewModel化
    final dialogService = ref.read(dialogServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('日記一覧'),
        actions: [
          IconButton(
            onPressed: () => dialogService.show(
              DialogRequest(type: DialogType.confirmLogout),
            ),
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
            child: FutureBuilder(
              future: diaryRepository.fetchDiariesWithAnalysis(
                userId: currentUser!.id,
                sentiment: _selectedSentiment,
                isDesc: _isDesc,
              ),
              builder: (context, snapshot) {
                // 読み込み中
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                // エラー発生
                if (snapshot.hasError) {
                  return Center(child: Text('エラー: ${snapshot.error}'));
                }

                final diaries = snapshot.data!;
                if (diaries.isEmpty) {
                  return const Center(child: Text('日記がまだありません'));
                }
                return DisplayList(
                  diaries: diaries,
                  navigateToDetail: (diary) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DetailDiary(diary: diary),
                      ),
                    );
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateDiary()),
            );
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
