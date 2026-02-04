class AppConfig {
  final String supabaseUrl;
  final String supabaseKey;
  final String sentryDsn;
  final String sentryEnv;

  const AppConfig({
    required this.supabaseUrl,
    required this.supabaseKey,
    required this.sentryDsn,
    required this.sentryEnv,
  });
}