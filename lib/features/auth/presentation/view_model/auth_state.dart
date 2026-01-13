class AuthState {
  // 画面のパラメータ
  final String email;
  final String password;

  // エラーメッセージ
  final String? emailError;
  final String? passwordError;
  final String? errorMessage;

  const AuthState({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.errorMessage,
  });

  // バリデーションチェック
  bool get isValid =>
      emailError == null &&
      passwordError == null &&
      email.isNotEmpty &&
      password.isNotEmpty;

  AuthState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    String? errorMessage,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError,
      passwordError: passwordError,
      errorMessage: errorMessage,
    );
  }
}
