import 'package:sentry_flutter/sentry_flutter.dart';

import 'log_sink.dart';

class SentryLogSink implements LogSink {
  // ログレベル → SentryLevel のマッピング
  static const _levelMap = {
    'debug': SentryLevel.debug,
    'info': SentryLevel.info,
    'warning': SentryLevel.warning,
    'error': SentryLevel.error,
    'fatal': SentryLevel.fatal,
  };

  @override
  Future<void> log(String level, String message,
      {Object? error, StackTrace? stackTrace}) async {
    final sentryLevel = _levelMap[level];

    if (sentryLevel == null) return;

    // --- エラーまたは致命的ログの場合 ---
    if (level == 'error' || level == 'fatal') {
      if (error != null) {
        // 例外とスタックトレースを送信
        await Sentry.captureException(
          error,
          stackTrace: stackTrace,
        );
      } else {
        // メッセージを送信
        await Sentry.captureMessage(
          message,
          level: sentryLevel,
        );
      }
      return;
    }
  }
}