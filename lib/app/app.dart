import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/settings_providers.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../l10n/app_localizations.dart';
import 'app_constants.dart';
import 'theme.dart';

/// Root widget of the Souvenir Puzzle application.
class SouvenirPuzzleApp extends ConsumerWidget {
  const SouvenirPuzzleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsControllerProvider);
    final themeMode = settingsAsync.value?.themeMode ?? ThemeMode.light;

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: settingsAsync.value?.language.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SplashScreen(),
    );
  }
}
