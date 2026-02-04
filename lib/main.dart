import 'dart:async';

import 'package:ai_analysis_diary_app/app.dart';
import 'package:ai_analysis_diary_app/core/config/load_app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/logging/logger_manager.dart';
import 'core/logging/sink/file_log_sink.dart';
import 'core/logging/sink/sentry_log_sink.dart';

Future<void> main() async {
  // Zoneが異なる場合の警告をFatalに変更
  BindingBase.debugZoneErrorsAreFatal = true;
  // Zoneを一致させるためにrunZonedGuarded内で、
  // ensureInitializedとsentryをコール
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      // 環境変数読み込み
      final config = await loadAppConfig();
      // Supabase初期化
      await Supabase.initialize(
        url: config.supabaseUrl,
        anonKey: config.supabaseKey,
        // Supabaseのdeeplinkを適用するために追記
        authOptions: FlutterAuthClientOptions(authFlowType: AuthFlowType.pkce),
      );

      // Logger初期化
      if (!kIsWeb) {
        // Webアプリケーションでないときに、FileLogを出力
        LoggerManager().addSink(FileLogSink());
      }
      LoggerManager().addSink(SentryLogSink());

      // SentryFlutter初期化
      await SentryFlutter.init((options) {
        options.dsn = config.sentryDsn;
        options.tracesSampleRate = 1.0;
        options.profilesSampleRate = 1.0;
        options.environment = config.sentryEnv;
      });
      runApp(
        SentryWidget(child: const ProviderScope(child: AiAnalysisDiaryApp())),
      );
    },
    (exception, stackTrace) async {
      await Sentry.captureException(exception, stackTrace: stackTrace);
    },
  );
}
