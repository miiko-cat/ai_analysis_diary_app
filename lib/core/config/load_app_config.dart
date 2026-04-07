import 'app_config.dart';

Future<AppConfig> loadAppConfig() async {
  // dart-define
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseKey = String.fromEnvironment('SUPABASE_API_KEY');
  const sentryDsn = String.fromEnvironment('SENTRY_FLUTTER_DSN');
  const sentryEnv = String.fromEnvironment('SENTRY_ENVIRONMENT');

  // 引数チェック
  if (supabaseUrl.isEmpty || supabaseKey.isEmpty) {
    throw StateError('Env is not defined by dart-define');
  }

  return const AppConfig(
    supabaseUrl: supabaseUrl,
    supabaseKey: supabaseKey,
    sentryDsn: sentryDsn,
    sentryEnv: sentryEnv,
  );
}
