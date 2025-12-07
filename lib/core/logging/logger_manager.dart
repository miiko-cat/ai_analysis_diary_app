

import 'package:ai_analysis_diary_app/core/logging/sink/log_sink.dart';
import 'package:logger/logger.dart';

import 'log_printer.dart';

class LoggerManager {
  static final LoggerManager _instance = LoggerManager._internal();

  factory LoggerManager() => _instance;

  late final Logger _debugLogger;
  final List<LogSink> _sinks = [];

  LoggerManager._internal() {
    _debugLogger = Logger(printer: PrettyLogPrinter());
  }

  void addSink(LogSink sink) {
    _sinks.add(sink);
  }

  Future<void> debug(String message) async {
    _debugLogger.d(message);
    await _dispatch("debug", message);
  }

  Future<void> info(String message) async {
    _debugLogger.i(message);
    await _dispatch("info", message);
  }

  Future<void> warn(String message) async {
    _debugLogger.w(message);
    await _dispatch("warning", message);
  }

  Future<void> error(String message, {Object? error, StackTrace? stackTrace}) async {
    _debugLogger.e(message, error: error, stackTrace: stackTrace);
    await _dispatch("error", message, error: error, stackTrace: stackTrace);
  }

  Future<void> fatal(String message, {Object? error, StackTrace? stackTrace}) async {
    _debugLogger.f(message, error: error, stackTrace: stackTrace);
    await _dispatch("fatal", message, error: error, stackTrace: stackTrace);
  }


  Future<void> _dispatch(
    String level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) async {
    for (final sink in _sinks) {
      await sink.log(level, message, error: error, stackTrace: stackTrace);
    }
  }
}
