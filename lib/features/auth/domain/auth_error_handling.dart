import 'package:supabase_flutter/supabase_flutter.dart';

String? authErrorHandling(AuthApiException exception) {
  switch(exception.code) {
    case "invalid_credentials":
      return "ログイン情報が間違っています";
    case "email_not_confirmed":
      return "Eメールアドレスが認証されていません";
    case "over_email_send_rate_limit":
      return "同じメールアドレスに複数メールが送られました。\nしばらく経ってから、サインアップしてください";
    default:
      return exception.toString();
  }
}