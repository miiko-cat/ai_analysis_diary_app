import 'package:ai_analysis_diary_app/features/diary/domain/diary_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/diary.dart';
import '../model/diary_with_analysis.dart';

class DiaryRepository {
  final SupabaseClient supabase;

  DiaryRepository(this.supabase);

  // 日記作成
  Future<Diary> insertDiary(Diary diary) async {
    final response = await supabase.from('diary').insert(diary.toJson()).select().single();
    return Diary.fromJson(response);
  }

  // 日記編集
  Future<Diary> updateDiary({
    required String postId,
    required String title,
    required String description,
    required String updatedDate,
  }) async {
    final response = await supabase
        .from('diary')
        .update({'title': title, 'description': description, 'updated_date': updatedDate})
        .eq('post_id', postId)
        .select()
        .maybeSingle();

    // 対象のデータが更新出来なかった時はエラーを投げる
    if (response == null) {
      throw DiaryException(message: 'データが見つからないため、更新されませんでした', code: DiaryErrorCode.notFound);
    }

    return Diary.fromJson(response);
  }

  // 日記削除
  Future<void> delete(String? postId) async {
    // postId が null の可能性を考慮してガード
    if (postId == null) {
      throw DiaryException(message: '削除対象のポストIDがありません', code: DiaryErrorCode.invalidPostId);
    }

    final response = await supabase.from('diary').delete().eq('post_id', postId).select().maybeSingle();

    // データが見つからなかった（既に削除された）
    if (response == null) {
      throw DiaryException(message: 'データが見つからないため、削除されませんでした', code: DiaryErrorCode.notFound);
    }
  }

  // 日記分析
  Future<dynamic> analyzeDiary(String userId, String postId) async {
    final response = await supabase.functions.invoke('analyze-diary', body: {'userId': userId, 'postId': postId});
    return response.data;
  }

  // AIアドバイス生成
  Future<dynamic> generateAdvice(String userId, String postId) async {
    final response = await supabase.functions.invoke('generate-advice', body: {'userId': userId, 'postId': postId});
    return response.data;
  }

  // 日記を全て取得
  Future<List<DiaryWithAnalysis>> fetchDiariesWithAnalysis({
    required String userId,
    String? sentiment,
    required bool isDesc,
  }) async {
    // 範囲指定
    // final start = limit * (page - 1);
    // final end = start + limit - 1;

    var query = supabase.from('diary_with_analysis').select().eq('user_id', userId);
    // .range(start, end)

    // 感情でフィルターを掛ける
    if (sentiment != null) {
      query = query.eq('sentiment', sentiment);
    }

    // 投稿日順でソート（昇順、降順選択可）
    final diaries = await query.order('date', ascending: !isDesc);
    return diaries.map((diary) => DiaryWithAnalysis.fromJson(diary)).toList();
  }

  // 対象の日記を1件取得
  Future<DiaryWithAnalysis> fetchDiaryWithAnaylysis({required String userId, required String postId}) async {
    final response = await supabase.from('diary_with_analysis').select().eq('post_id', postId).eq('user_id', userId).maybeSingle();

    // 対象のデータが取得出来なかった時はエラーを投げる
    if (response == null) {
      throw DiaryException(message: 'データが見つかりませんでした', code: DiaryErrorCode.notFound);
    }

    return DiaryWithAnalysis.fromJson(response);
  }
}
