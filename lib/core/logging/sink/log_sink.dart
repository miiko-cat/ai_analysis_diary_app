abstract class LogSink {
  Future<void> log(
      String level,
      String message, {
        Object? error,
        StackTrace? stackTrace,
      });
}