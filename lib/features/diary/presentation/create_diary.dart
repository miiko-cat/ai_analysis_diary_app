import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../auth/data/auth_providers.dart';
import '../model/diary.dart';
import '../repository/diary_providers.dart';

class CreateDiary extends ConsumerStatefulWidget {
  const CreateDiary({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateDiaryState();
}

class _CreateDiaryState extends ConsumerState<CreateDiary> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _titleController = TextEditingController();
  final _desController = TextEditingController();

  // 日付変換フォーマット
  final dateformat = DateFormat('yyyy/MM/dd');

  // 内部日付情報
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _setDate();
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

    return Scaffold(
      appBar: AppBar(title: Text('日記作成')),
      body: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '今日の日記を作成しましょう',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: '日付',
                      suffixIcon: IconButton(
                        onPressed: () => _selectDate(context),
                        icon: Icon(Icons.calendar_today),
                      ),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: 'タイトル'),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _desController,
                    decoration: InputDecoration(labelText: '本文'),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final diary = Diary(
                          date: _selectedDate!,
                          title: _titleController.text,
                          description: _desController.text,
                          userId: currentUser!.id,
                        );
                        final response = await diaryRepository.insertDiary(
                          diary,
                        );

                        print(response);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("日記投稿完了！"),
                              duration: Duration(seconds: 2),
                            ),
                          );
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
    );
  }
}
