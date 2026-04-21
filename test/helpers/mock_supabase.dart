import 'package:ai_analysis_diary_app/core/utils/dialog_service.dart';
import 'package:ai_analysis_diary_app/features/auth/repository/auth_repository.dart';
import 'package:ai_analysis_diary_app/features/diary/repository/diary_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseAuth extends Mock implements GoTrueClient {}

// Supabaseの中間オブジェクトをMock化
class MockPostgrestQueryBuilder extends Mock implements SupabaseQueryBuilder {}
class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder<Map<String, dynamic>?> {}
class MockPostgrestTransformBuilder extends Mock implements PostgrestTransformBuilder<PostgrestList> {}

class MockAuthResponse extends Mock implements AuthResponse {}

class MockUser extends Mock implements User {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockDiaryRepository extends Mock implements DiaryRepository {}

class MockDialogService extends Mock implements DialogService {}