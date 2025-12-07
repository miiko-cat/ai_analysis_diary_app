import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'log_sink.dart';

class FileLogSink implements LogSink {
  late final File _logFile;

  FileLogSink() {
    _init();
  }

  Future<void> _init() async {
    final dir = await getApplicationDocumentsDirectory();
    _logFile = File('${dir.path}/app.log');
  }

  @override
  Future<void> log(
    String level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) async {
    final timestamp = DateTime.now().toIso8601String();
    await _logFile.writeAsString(
      '$timestamp [$level] $message $error \n$stackTrace\n',
      mode: FileMode.append,
    );
  }
}
