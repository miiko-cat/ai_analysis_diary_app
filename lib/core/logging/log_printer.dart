import 'package:logger/logger.dart';

class PrettyLogPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    final emoji =
        {
          Level.debug: '🐛',
          Level.info: 'ℹ️',
          Level.warning: '⚠️',
          Level.error: '❌',
          Level.fatal: '💥',
        }[event.level] ??
        '';

    return [
      "$emoji [${event.level.toString().toUpperCase()}] ${event.message}",
    ];
  }
}
