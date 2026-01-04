class AuthState {
  // 画面のパラメータ
  final String email;
  final String password;

  // 読み込み中
  final bool isLoading;

  // エラーメッセージ
  final String? emailError;
  final String? passwordError;
  final String? errorMessage;

  const AuthState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.emailError,
    this.passwordError,
    this.errorMessage,
  });

  AuthState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    String? emailError,
    String? passwordError,
    String? errorMessage,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      emailError: emailError,
      passwordError: passwordError,
      errorMessage: errorMessage,
    );
  }
}