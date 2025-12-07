import 'package:ai_analysis_diary_app/core/logging/logger_manager.dart';
import 'package:ai_analysis_diary_app/core/logging/sink/sentry_log_sink.dart';
import 'package:ai_analysis_diary_app/core/logging/sink/supabase_log_sink.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/core_providers.dart';
import 'sink/file_log_sink.dart';

final loggerProvider = Provider<LoggerManager>((ref) {
  final logger = LoggerManager();

  // Sink登録
  logger.addSink(SentryLogSink());
  logger.addSink(FileLogSink());
  logger.addSink(SupabaseLogSink(ref.watch(supabaseProvider)));

  return logger;
});
