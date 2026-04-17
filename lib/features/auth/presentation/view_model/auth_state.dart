class AuthViewState {
  // 画面のパラメータ
  final String email;
  final String password;

  // エラーメッセージ
  final String? errorMessage;

  const AuthViewState({
    this.email = '',
    this.password = '',
    this.errorMessage,
  });

  AuthViewState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    String? errorMessage,
  }) {
    return AuthViewState(
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage,
    );
  }
}
