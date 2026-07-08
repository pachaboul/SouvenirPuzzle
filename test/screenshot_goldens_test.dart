import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souvenir_puzzle/data/models/app_settings.dart';
import 'package:souvenir_puzzle/features/difficulty/presentation/difficulty_screen.dart';
import 'package:souvenir_puzzle/features/get_started/presentation/get_started_screen.dart';
import 'package:souvenir_puzzle/features/home/presentation/home_screen.dart';
import 'package:souvenir_puzzle/features/memories/presentation/memories_screen.dart';
import 'package:souvenir_puzzle/features/puzzle/domain/puzzle_difficulty.dart';
import 'package:souvenir_puzzle/features/puzzle/presentation/puzzle_screen.dart';
import 'package:souvenir_puzzle/features/puzzle/presentation/victory_screen.dart';
import 'package:souvenir_puzzle/features/settings/presentation/settings_screen.dart';
import 'package:souvenir_puzzle/features/splash/presentation/splash_screen.dart';
import 'package:souvenir_puzzle/features/stats/presentation/stats_screen.dart';

import 'fixtures/screenshot_demo_data.dart';
import 'fixtures/screenshot_harness.dart';

void main() {
  late String demoImagePath;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    demoImagePath = await copyDemoImageToTemp();
  });

  group('screenshots FR light', () {
    const prefix = '../screenshots/fr/light';

    testWidgets('01_splash', (tester) async {
      await pumpScreenshotApp(
        tester,
        home: const SplashScreen(),
        imagePath: demoImagePath,
      );
      await tester.pump(const Duration(milliseconds: 600));
      await expectScreenshot(tester, '$prefix/01_splash.png');
    });

    testWidgets('02_home', (tester) async {
      await pumpScreenshotApp(
        tester,
        home: const HomeScreen(),
        imagePath: demoImagePath,
      );
      await expectScreenshot(tester, '$prefix/02_home.png');
    });

    testWidgets('03_memories', (tester) async {
      await pumpScreenshotApp(
        tester,
        home: const MemoriesScreen(),
        imagePath: demoImagePath,
      );
      await expectScreenshot(tester, '$prefix/03_memories.png');
    });

    testWidgets('04_stats', (tester) async {
      await pumpScreenshotApp(
        tester,
        home: const StatsScreen(),
        imagePath: demoImagePath,
      );
      await expectScreenshot(tester, '$prefix/04_stats.png');
    });

    testWidgets('05_settings', (tester) async {
      await pumpScreenshotApp(
        tester,
        home: const SettingsScreen(),
        imagePath: demoImagePath,
      );
      await expectScreenshot(tester, '$prefix/05_settings.png');
    });

    testWidgets('06_get_started', (tester) async {
      await pumpScreenshotApp(
        tester,
        home: const GetStartedScreen(),
        imagePath: demoImagePath,
      );
      await expectScreenshot(tester, '$prefix/06_get_started.png');
    });

    testWidgets('07_difficulty', (tester) async {
      await pumpScreenshotApp(
        tester,
        home: DifficultyScreen(image: File(demoImagePath)),
        imagePath: demoImagePath,
      );
      await expectScreenshot(tester, '$prefix/07_difficulty.png');
    });

    testWidgets('08_puzzle', (tester) async {
      final session = ScreenshotDemoData.memorySession(demoImagePath);
      await pumpScreenshotApp(
        tester,
        home: PuzzleScreen(
          session: session,
          difficulty: PuzzleDifficulty.medium,
        ),
        imagePath: demoImagePath,
        settle: false,
      );
      await tester.pump(const Duration(milliseconds: 1200));
      await expectScreenshot(tester, '$prefix/08_puzzle.png');
    });

    testWidgets('09_victory', (tester) async {
      final session = ScreenshotDemoData.memorySession(demoImagePath);
      await pumpScreenshotApp(
        tester,
        home: VictoryScreen(
          session: session,
          difficulty: PuzzleDifficulty.medium,
          seconds: 142,
          moves: 38,
        ),
        imagePath: demoImagePath,
      );
      await expectScreenshot(tester, '$prefix/09_victory.png');
    });
  });

  group('screenshots FR dark', () {
    const prefix = '../screenshots/fr/dark';

    testWidgets('02_home', (tester) async {
      await pumpScreenshotApp(
        tester,
        home: const HomeScreen(),
        imagePath: demoImagePath,
        themeMode: ThemeMode.dark,
      );
      await expectScreenshot(tester, '$prefix/02_home.png');
    });

    testWidgets('08_puzzle', (tester) async {
      final session = ScreenshotDemoData.memorySession(demoImagePath);
      await pumpScreenshotApp(
        tester,
        home: PuzzleScreen(
          session: session,
          difficulty: PuzzleDifficulty.medium,
        ),
        imagePath: demoImagePath,
        themeMode: ThemeMode.dark,
        settle: false,
      );
      await tester.pump(const Duration(milliseconds: 1200));
      await expectScreenshot(tester, '$prefix/08_puzzle.png');
    });
  });

  group('screenshots EN light', () {
    const prefix = '../screenshots/en/light';

    testWidgets('02_home', (tester) async {
      await pumpScreenshotApp(
        tester,
        home: const HomeScreen(),
        imagePath: demoImagePath,
        locale: const Locale('en'),
      );
      await expectScreenshot(tester, '$prefix/02_home.png');
    });
  });
}
