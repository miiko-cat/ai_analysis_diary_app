import 'package:ai_analysis_diary_app/features/auth/presentation/auth_page.dart';
import 'package:ai_analysis_diary_app/features/auth/repository/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/utils/widget/app_dialog_listener.dart';
import 'features/auth/presentation/auth_mode.dart';
import 'features/home/presentation/home_page.dart';

class AiAnalysisDiaryApp extends StatelessWidget {
  const AiAnalysisDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIセラピー日記',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('ja'), Locale('en')],
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'NotoSansJP',
      ),
      home: AppDialogListener(child: const AuthGate()),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (state) {
        final session = state.session;
        if (session == null) {
          return const AuthPage(mode: AuthMode.login);
        }
        return const HomePage();
      },
      error: (e, _) => Scaffold(body: Center(child: Text('エラー: $e'))),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
