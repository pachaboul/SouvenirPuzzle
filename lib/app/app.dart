import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/settings_providers.dart';
import '../features/splash/presentation/splash_screen.dart';
import 'app_constants.dart';
import 'theme.dart';

/// Root widget of the Souvenir Puzzle application.
class SouvenirPuzzleApp extends ConsumerWidget {
  const SouvenirPuzzleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(settingsControllerProvider).asData?.value.themeMode ??
        ThemeMode.light;
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}
