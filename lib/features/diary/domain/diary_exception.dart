class DiaryException {
  final String message;
  final DiaryErrorCode? code;

  DiaryException({required this.message, this.code});

  @override
  String toString() {
    return 'DiaryException: [$code] $message';
  }
}

enum DiaryErrorCode {
  invalidPostId,    // IDがnull
  notFound,         // データが見つからない
  multipleRows,     // 重複データがある
  unknown,          // その他
}