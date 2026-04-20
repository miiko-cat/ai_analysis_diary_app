import 'package:ai_analysis_diary_app/core/utils/widget/app_loading_overlay.dart';
import 'package:ai_analysis_diary_app/features/diary/model/diary_with_analysis.dart';
import 'package:ai_analysis_diary_app/features/diary/presentation/view_model/detail_diary_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../model/sentiment.dart';

class DetailDiary extends ConsumerWidget {
  final DiaryWithAnalysis diary;

  const DetailDiary({super.key, required this.diary});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 前の画面から渡ってきたDiaryWithAnalysisをViewModelに設定
    final state = ref.watch(detailDiaryVMProvider(diary));
    final notifier = ref.read(detailDiaryVMProvider(diary).notifier);

    return AppLoadingOverlay(
      child: state.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(error.toString(), style: const TextStyle(color: Colors.red)),
        ),
        data: (detailDiaryState) {
          return Scaffold(
            appBar: AppBar(title: Text('日記詳細')),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header(diary: diary),
                  SizedBox(height: 16),
                  title(context, diary.title),
                  SizedBox(height: 12),
                  description(context, diary.description),
                  SizedBox(height: 24),
                  aiAnalysis(context, diary),
                ],
              ),
            ),
            bottomNavigationBar: bottomButtons(),
          );
        },
      ),
    );
  }

  // ヘッダー
  Widget header({required DiaryWithAnalysis diary}) {
    return Row(
      children: [
        Icon(diary.sentiment.icon, size: 32, color: diary.sentiment.color),
        SizedBox(width: 8),
        diary.sentiment.chip,
        Spacer(),
        Text(DateFormat('yyyy/MM/dd HH:mm:ss').format(diary.date.toLocal())),
      ],
    );
  }

  // タイトル
  Widget title(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.headlineSmall);
  }

  // 本文
  Widget description(BuildContext context, String description) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6)),
      ),
    );
  }

  // 分析結果
  Widget aiAnalysis(BuildContext context, DiaryWithAnalysis diary) {
    return Card(
      child: ExpansionTile(
        title: Text('AI分析', style: Theme.of(context).textTheme.titleMedium),
        childrenPadding: EdgeInsetsGeometry.all(16),
        children: [
          SizedBox(height: 8),
          Text('感情: ${diary.emotion ?? '-'}', style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(height: 8),
          if (diary.summary != null) ...[summarySection(context, diary.summary!), SizedBox(height: 12)],
          if (diary.advice != null) adviceSection(context, diary.advice!),
        ],
      ),
    );
  }

  // ボトムナビゲーションバー（編集、削除ボタン）
  Widget bottomButtons() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: OutlinedButton.icon(
                onPressed: () => {},
                icon: Icon(Icons.delete_outline),
                label: Text('削除'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: OutlinedButton.icon(onPressed: () => {}, icon: Icon(Icons.edit), label: Text('編集')),
            ),
          ],
        ),
      ),
    );
  }

  Widget summarySection(BuildContext context, String summary) {
    return aiInfoSection(
      context,
      icon: Icons.summarize,
      title: '要約',
      content: summary,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
    );
  }

  Widget adviceSection(BuildContext context, String advice) {
    return aiInfoSection(
      context,
      icon: Icons.lightbulb_outline,
      title: 'AIアドバイス',
      content: advice,
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
    );
  }

  Widget aiInfoSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    required Color backgroundColor,
  }) {
    final theme = Theme.of(context);

    return Card(
      color: backgroundColor,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18),
                SizedBox(width: 6),
                Text(title, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            Text(content, style: theme.textTheme.bodyMedium?.copyWith(height: 1.6)),
          ],
        ),
      ),
    );
  }
}
