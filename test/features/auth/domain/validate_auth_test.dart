import 'package:ai_analysis_diary_app/features/auth/domain/validate_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Eメールバリデーション検証', () {
    test('メールアドレスがNull', (){
      expect(validateEmail(null), 'メールアドレスを入力してください');
    });
    test('メールアドレスが空文字', (){
      expect(validateEmail(''), 'メールアドレスを入力してください');
    });
    test('メールアドレスにドメインなし', (){
      expect(validateEmail('example'), 'メールアドレスの形式が正しくありません');
    });
    test('メールアドレスにホスト名なし', (){
      expect(validateEmail('@test.com'), 'メールアドレスの形式が正しくありません');
    });
  });

  group('パスワードバリデーション検証', () {
    test('パスワードがNull', (){
      expect(validatePassword(null), 'パスワードを入力してください');
    });
    test('パスワードが空文字', (){
      expect(validatePassword(''), 'パスワードを入力してください');
    });
    test('パスワードが8文字未満', (){
      expect(validatePassword('1234567'), '8文字以上にしてください');
    });
    test('パスワードに大文字なし', (){
      expect(validatePassword('example1!'), '大文字を1つ以上含めてください');
    });
    test('パスワードに小文字なし', (){
      expect(validatePassword('EXAMPLE1!'), '小文字を1つ以上含めてください');
    });
    test('パスワードに数字なし', (){
      expect(validatePassword('Example!'), '数字を1つ以上含めてください');
    });
    test('パスワードに記号なし', (){
      expect(validatePassword('Example1'), '記号を1つ以上含めてください');
    });
  });
}