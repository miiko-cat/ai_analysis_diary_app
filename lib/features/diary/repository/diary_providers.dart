// 日記Repository
import 'package:ai_analysis_diary_app/features/diary/repository/diary_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/provider/core_providers.dart';

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  return DiaryRepository(ref.watch(supabaseProvider));
});