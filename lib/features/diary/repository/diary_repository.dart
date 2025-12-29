import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/diary.dart';
import '../model/diary_with_analysis.dart';

class DiaryRepository {
  final SupabaseClient supabase;

  DiaryRepository(this.supabase);

  Future<Diary> insertDiary(Diary diary) async {
    final response = await supabase
        .from('diary')
        .insert(diary.toJson())
        .select()
        .single();
    return Diary.fromJson(response);
  }

  Future<dynamic> analyzeDiary(String userId, String postId) async {
    final response = await supabase.functions.invoke(
      'analyze-diary',
      body: {'userId': userId, 'postId': postId},
    );
    return response.data;
  }

  Future<List<DiaryWithAnalysis>> fetchDiariesWithAnalysis({
    required String userId,
    String? sentiment,
    required bool isDesc,
  }) async {
    // 範囲指定
    // final start = limit * (page - 1);
    // final end = start + limit - 1;

    var query = supabase
        .from('diary_with_analysis')
        .select()
        .eq('user_id', userId);
        // .range(start, end)

    // 感情でフィルターを掛ける
    if (sentiment != null) {
      query = query.eq('sentiment', sentiment);
    }

    // 投稿日順でソート（昇順、降順選択可）
    final diaries = await query.order('date', ascending: !isDesc);
    return diaries.map((diary) => DiaryWithAnalysis.fromJson(diary)).toList();
  }
}
