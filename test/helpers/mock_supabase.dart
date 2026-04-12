import 'package:ai_analysis_diary_app/features/auth/repository/auth_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseAuth extends Mock implements GoTrueClient {}

class MockAuthResponse extends Mock implements AuthResponse {}

class MockUser extends Mock implements User {}

class MockAuthRepository extends Mock implements AuthRepository {}