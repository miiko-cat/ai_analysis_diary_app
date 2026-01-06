String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'メールアドレスを入力してください';
  }
  if (!RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$').hasMatch(value)) {
    return 'メールアドレスの形式が正しくありません';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'パスワードを入力してください';
  }
  if (value.length < 8) {
    return '8文字以上にしてください';
  }
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return '大文字を1つ以上含めてください';
  }
  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return '小文字を1つ以上含めてください';
  }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return '数字を1つ以上含めてください';
  }
  if (!RegExp("[$escapedSymbols]").hasMatch(value)) {
    return '記号を1つ以上含めてください';
  }
  return null;
}

final escapedSymbols = passwordSymbolList.map(escapeForCharClass).join();

String escapeForCharClass(String char) {
  const specialChars = r'\-[]^';
  if (specialChars.contains(char)) {
    return r'\' + char;
  }
  return char;
}

List<String> passwordSymbolList = [
  '!',
  '@',
  '#',
  r'$',
  '%',
  '^',
  '&',
  '*',
  '(',
  ')',
  '_',
  '+',
  '-',
  '=',
  '[',
  ']',
  '{',
  '}',
  ';',
  ':',
  "'",
  '"',
  r'\',
  '|',
  '<',
  '>',
  '?',
  ',',
  '.',
  '/',
  '`',
  '~',
];
