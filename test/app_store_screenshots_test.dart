import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souvenir_puzzle/features/difficulty/presentation/difficulty_screen.dart';
import 'package:souvenir_puzzle/features/home/presentation/home_screen.dart';
import 'package:souvenir_puzzle/features/memories/presentation/memories_screen.dart';
import 'package:souvenir_puzzle/features/puzzle/domain/puzzle_difficulty.dart';
import 'package:souvenir_puzzle/features/puzzle/presentation/puzzle_screen.dart';
import 'package:souvenir_puzzle/features/puzzle/presentation/victory_screen.dart';
import 'package:souvenir_puzzle/features/stats/presentation/stats_screen.dart';

import 'fixtures/screenshot_demo_data.dart';
import 'fixtures/screenshot_harness.dart';

/// App Store 6,7" screenshots — 1290×2796 px (iPhone 14/15 Pro Max class).
void main() {
  late String demoImagePath;
  const viewport = ScreenshotViewport.appStore67;
  const prefix = '../screenshots/app-store/6.7-inch/fr';

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    demoImagePath = await copyDemoImageToTemp();
  });

  group('App Store 6.7-inch FR light', () {
    testWidgets('01_home', (tester) async {
      await pumpScreenshotApp(
        tester,
        home: const HomeScreen(),
        imagePath: demoImagePath,
        viewport: viewport,
      );
      await expectScreenshot(tester, '$prefix/01_home.png');
    });

    testWidgets('02_memories', (tester) async {
      await pumpScreenshotApp(
        tester,
        home: const MemoriesScreen(),
        imagePath: demoImagePath,
        viewport: viewport,
      );
      await expectScreenshot(tester, '$prefix/02_memories.png');
    });

    testWidgets('03_stats', (tester) async {
      await pumpScreenshotApp(
        tester,
        home: const StatsScreen(),
        imagePath: demoImagePath,
        viewport: viewport,
      );
      await expectScreenshot(tester, '$prefix/03_stats.png');
    });

    testWidgets('04_difficulty', (tester) async {
      await pumpScreenshotApp(
        tester,
        home: DifficultyScreen(image: File(demoImagePath)),
        imagePath: demoImagePath,
        viewport: viewport,
      );
      await expectScreenshot(tester, '$prefix/04_difficulty.png');
    });

    testWidgets('05_puzzle', (tester) async {
      final session = ScreenshotDemoData.memorySession(demoImagePath);
      await pumpScreenshotApp(
        tester,
        home: PuzzleScreen(
          session: session,
          difficulty: PuzzleDifficulty.medium,
        ),
        imagePath: demoImagePath,
        viewport: viewport,
        settle: false,
      );
      await tester.pump(const Duration(milliseconds: 1200));
      await expectScreenshot(tester, '$prefix/05_puzzle.png');
    });

    testWidgets('06_victory', (tester) async {
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
        viewport: viewport,
      );
      await expectScreenshot(tester, '$prefix/06_victory.png');
    });
  });
}
