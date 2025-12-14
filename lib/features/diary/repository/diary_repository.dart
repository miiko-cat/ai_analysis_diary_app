import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/diary.dart';

class DiaryRepository {
  final SupabaseClient supabase;

  DiaryRepository(this.supabase);

  Future<Diary> insertDiary(Diary diary) async {
    final response = await supabase.from('diary').insert(diary.toJson()).select().single();
    return Diary.fromJson(response);
  }
}