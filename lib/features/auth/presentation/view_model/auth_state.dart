class AuthState {
  // 画面のパラメータ
  final String email;
  final String password;

  // エラーメッセージ
  final String? errorMessage;

  const AuthState({
    this.email = '',
    this.password = '',
    this.errorMessage,
  });

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
      errorMessage: errorMessage,
    );
  }
}
