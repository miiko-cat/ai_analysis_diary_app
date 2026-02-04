import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app_config.dart';

Future<AppConfig> loadAppConfig() async {
  if (kIsWeb) {
    // Web: dart-define
    const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
    const supabaseKey = String.fromEnvironment('SUPABASE_API_KEY');
    const sentryDsn = String.fromEnvironment('SENTRY_FLUTTER_DNS');
    const sentryEnv = String.fromEnvironment('SENTRY_ENVIRONMENT');

    // 引数チェック
    if (supabaseUrl.isEmpty || supabaseKey.isEmpty) {
      throw StateError('Web env is not defined by dart-define');
    }

    return const AppConfig(
      supabaseUrl: supabaseUrl,
      supabaseKey: supabaseKey,
      sentryDsn: sentryDsn,
      sentryEnv: sentryEnv,
    );
  } else {
    // Mobile: dotenv
    const envFile = String.fromEnvironment('env');
    await dotenv.load(fileName: envFile);

    return AppConfig(
      supabaseUrl: dotenv.env['SUPABASE_URL']!,
      supabaseKey: dotenv.env['SUPABASE_API_KEY']!,
      sentryDsn: dotenv.env['SENTRY_FLUTTER_DNS']!,
      sentryEnv: dotenv.env['SENTRY_ENVIRONMENT']!,
    );
  }
}
