import 'package:supabase_flutter/supabase_flutter.dart';

import 'log_sink.dart';

class SupabaseLogSink implements LogSink {
  final SupabaseClient client;

  SupabaseLogSink(this.client);

  @override
  Future<void> log(String level, String message, {Object? error, StackTrace? stackTrace}) async {
    await client.from("app_logs").insert({
      "level": level,
      "message": message,
      "error": error?.toString(),
      "stack_trace": stackTrace?.toString(),
    });
  }
}