import 'package:ai_analysis_diary_app/features/diary/model/diary_with_analysis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';

import '../../../core/logging/logger_manager.dart';
import '../../../core/utils/widget/app_loading_overlay.dart';
import '../../../core/utils/widget/keyboard_dismiss.dart';
import '../../auth/repository/auth_providers.dart';
import '../model/diary.dart';
import '../repository/diary_providers.dart';

class DiaryForm extends ConsumerStatefulWidget {
  final DiaryWithAnalysis? diary;

  const DiaryForm({super.key, this.diary});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DiaryFormState();
}

class _DiaryFormState extends ConsumerState<DiaryForm> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _titleController = TextEditingController();
  final _desController = TextEditingController();
  final _titleFocus = FocusNode();
  final _desFocus = FocusNode();

  // 読み込み中
  bool _isLoading = false;

  // 日付変換フォーマット
  final dateformat = DateFormat('yyyy/MM/dd');

  // 内部日付情報
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.diary == null) {
      // 新規作成モード
      _setDate();
    } else {
      // 編集モード
      _selectedDate = widget.diary!.date;
      _dateController.text = dateformat.format(_selectedDate!);
      _titleController.text = widget.diary!.title;
      _desController.text = widget.diary!.description;
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _titleController.dispose();
    _desController.dispose();
    _titleFocus.dispose();
    _desFocus.dispose();
    super.dispose();
  }

  void _setDate() {
    // 本日の日付を取得
    final now = DateTime.now();
    _selectedDate = now;
    _dateController.text = dateformat.format(now);
  }

  Future<void> _selectDate(BuildContext context) async {
    // 本日の日付を取得
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      _selectedDate = picked;
      setState(() {
        _dateController.text = dateformat.format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ログイン中のユーザを取得
    final currentUser = ref.watch(currentUserProvider);
    // 日記のRepositoryを取得
    final diaryRepository = ref.watch(diaryRepositoryProvider);
    // ローディング状態管理
    late final StateController<bool> loadingController = ref.read(loadingProvider.notifier);

    return AppLoadingOverlay(
      child: Scaffold(
        appBar: AppBar(title: Text(widget.diary == null ? '日記作成' : '日記編集')),
        body: KeyboardDismiss(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.diary == null ? '日記を作成しましょう' : '日記を編集しましょう',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: '日付',
                          suffixIcon:
                              widget.diary ==
                                  null // 新規作成時のみアイコンを表示
                              ? IconButton(onPressed: () => _selectDate(context), icon: Icon(Icons.calendar_today))
                              : null, // 編集時はアイコンを表示しない
                        ),
                        onTap: widget.diary == null ? () => _selectDate(context) : null,
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _titleController,
                        focusNode: _titleFocus,
                        onTap: () => _scrollToField(_titleFocus),
                        keyboardType: TextInputType.text,
                        maxLength: 20,
                        decoration: InputDecoration(labelText: 'タイトル'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'タイトルを入力してください';
                          }
                          if (value.length > 20) {
                            return 'タイトルは20文字以内で入力してください';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        height: 240,
                        child: TextFormField(
                          controller: _desController,
                          focusNode: _desFocus,
                          onTap: () => _scrollToField(_desFocus),
                          expands: true,
                          maxLines: null,
                          maxLength: 2000,
                          keyboardType: TextInputType.multiline,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            labelText: '本文',
                            hintText: '今日あったことを自由に書いてください',
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(12),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '本文を入力してください';
                            }
                            if (value.length > 2000) {
                              return '本文は2000文字以内で入力してください';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  // ヴァリデーションが失敗しているなら何もしない
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  // 読み込み中
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  loadingController.state = true;

                                  try {
                                    // 日記をDBに登録
                                    final diary = Diary(
                                      date: _selectedDate!.toUtc(),
                                      title: _titleController.text,
                                      description: _desController.text,
                                      userId: currentUser!.id,
                                    );

                                    late final Diary response;
                                    if (widget.diary == null) {
                                      // 新規作成モード
                                      response = await diaryRepository.insertDiary(diary);
                                    } else {
                                      // 編集モード
                                      response = await diaryRepository.updateDiary(
                                        postId: widget.diary!.postId!,
                                        title: diary.title,
                                        description: diary.description,
                                        updatedDate: DateTime.now().toUtc(),
                                      );
                                    }

                                    // 日記をAIに分析させる
                                    await diaryRepository.analyzeDiary(response.userId, response.postId!);

                                    // 感情に応じたアドバイスを生成
                                    await diaryRepository.generateAdvice(response.userId, response.postId!);

                                    // 日記投稿完了
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("日記投稿完了！"), duration: Duration(seconds: 2)),
                                      );
                                      Navigator.pop(context);
                                    }
                                  } catch (error, stack) {
                                    LoggerManager().error("日記作成時にエラーが発生しました", error: error, stackTrace: stack);

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('投稿に失敗しました')));
                                    }
                                  } finally {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    loadingController.state = false;
                                  }
                                },
                          child: Text('投稿'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToField(FocusNode node) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!node.hasFocus) return;

      Scrollable.ensureVisible(
        node.context!,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        alignment: 0.2, // 上寄せ
      );
    });
  }
}
