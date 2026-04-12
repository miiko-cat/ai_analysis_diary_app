enum AuthMode { login, signup }

class AuthPageArgs {
  // ログイン、サインアップどちらか
  final AuthMode mode;
  // サインアップ成功後、ログイン画面に渡すEメールとパスワード
  final String initialEmail;
  final String initialPassword;

  const AuthPageArgs({
    required this.mode,
    this.initialEmail = '',
    this.initialPassword = '',
  });

  @override
  bool operator ==(Object other) =>
      other is AuthPageArgs &&
      other.mode == mode &&
      other.initialEmail == initialEmail &&
      other.initialPassword == initialPassword;

  @override
  int get hashCode => Object.hash(mode, initialEmail, initialPassword);
}