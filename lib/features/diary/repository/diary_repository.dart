import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/diary.dart';

class DiaryRepository {
  final SupabaseClient supabase;

  DiaryRepository(this.supabase);

  Future<Diary> insertDiary(Diary diary) async {
    final response = await supabase.from('diary').insert(diary.toJson()).select().single();
    return Diary.fromJson(response);
  }

  Future<dynamic> analyzeDiary(String userId, String postId) async {
    final response = await supabase.functions.invoke('analyze-diary', body: {'userId': userId, 'postId': postId});
    return response.data;
  }
}