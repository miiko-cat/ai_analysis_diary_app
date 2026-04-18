// 日記Repository
import 'package:ai_analysis_diary_app/features/diary/model/diary_with_analysis.dart';
import 'package:ai_analysis_diary_app/features/diary/repository/diary_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/provider/core_providers.dart';

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  return DiaryRepository(ref.watch(supabaseProvider));
});

// 日記一覧取得Provider
final diariesProvider = FutureProvider.autoDispose
    .family<List<DiaryWithAnalysis>, ({String userId, String? sentiment, bool isDesc})>((ref, args) {
      final repository = ref.watch(diaryRepositoryProvider);
      return repository.fetchDiariesWithAnalysis(userId: args.userId, sentiment: args.sentiment, isDesc: args.isDesc);
    });
