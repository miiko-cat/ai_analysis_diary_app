import 'dart:async';
import 'package:ai_analysis_diary_app/core/utils/dialog_service.dart';
import 'package:mocktail/mocktail.dart';
import 'mock_supabase.dart';

// DialogをMock化するためのヘルパー関数
void setupMockDialogService(MockDialogService mock, StreamController<DialogRequest> controller) {
  when(() => mock.stream).thenAnswer((_) => controller.stream);
  when(() => mock.show(any())).thenAnswer((inv) => controller.add(inv.positionalArguments[0]));
}