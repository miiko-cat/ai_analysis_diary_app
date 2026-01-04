class AuthFailure implements Exception {
  final String message;

  AuthFailure(this.message);

  @override
  String toString() => message;

  factory AuthFailure.invalidCredential() =>
      AuthFailure('メールアドレスまたはパスワードが違います');

  factory AuthFailure.network() => AuthFailure('通信エラーが発生しました');

  factory AuthFailure.unknown(String message) => AuthFailure(message);
}
