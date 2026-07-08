import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souvenir_puzzle/app/theme.dart';
import 'package:souvenir_puzzle/data/models/app_settings.dart';
import 'package:souvenir_puzzle/l10n/app_localizations.dart';

import 'screenshot_providers.dart';

/// Typical Android phone logical size (Pixel-class).
const kScreenshotSize = Size(412, 915);

/// iPhone 6,7" App Store — 430×932 pt @3x → 1290×2796 px.
const kAppStore67LogicalSize = Size(430, 932);
const double kAppStore67DevicePixelRatio = 3.0;

class ScreenshotViewport {
  const ScreenshotViewport({
    required this.logicalSize,
    required this.devicePixelRatio,
  });

  final Size logicalSize;
  final double devicePixelRatio;

  static const phone = ScreenshotViewport(
    logicalSize: kScreenshotSize,
    devicePixelRatio: 1.0,
  );

  static const appStore67 = ScreenshotViewport(
    logicalSize: kAppStore67LogicalSize,
    devicePixelRatio: kAppStore67DevicePixelRatio,
  );
}

Future<String> copyDemoImageToTemp() async {
  final bytes = await rootBundle.load('assets/images/logo-souvenirpuzzle.png');
  final file = File(
    '${Directory.systemTemp.path}/souvenir_puzzle_screenshot_demo.png',
  );
  await file.writeAsBytes(
    bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
  );
  return file.path;
}

void configureScreenshotSurface(
  WidgetTester tester, [
  ScreenshotViewport viewport = ScreenshotViewport.phone,
]) {
  final view = tester.view;
  view.devicePixelRatio = viewport.devicePixelRatio;
  view.physicalSize = Size(
    viewport.logicalSize.width * viewport.devicePixelRatio,
    viewport.logicalSize.height * viewport.devicePixelRatio,
  );
}

Future<void> pumpScreenshotApp(
  WidgetTester tester, {
  required Widget home,
  required String imagePath,
  Locale locale = const Locale('fr'),
  ThemeMode themeMode = ThemeMode.light,
  bool settle = true,
  ScreenshotViewport viewport = ScreenshotViewport.phone,
}) async {
  configureScreenshotSurface(tester, viewport);
  await tester.pumpWidget(
    ProviderScope(
      overrides: screenshotOverrides(
        imagePath: imagePath,
        settings: AppSettings(
          language: locale.languageCode == 'fr'
              ? AppLanguage.french
              : AppLanguage.english,
          themeMode: themeMode,
        ),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: locale,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: themeMode,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
      ),
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

Future<void> expectScreenshot(
  WidgetTester tester,
  String goldenPath,
) async {
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile(goldenPath),
  );
}
