import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:souvenir_puzzle/features/home/presentation/home_screen.dart';
import 'package:souvenir_puzzle/l10n/app_localizations.dart';

void main() {
  testWidgets('Home screen shows the main call to action (FR)', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomeScreen(),
        ),
      ),
    );

    expect(find.text('Souvenir Puzzle'), findsOneWidget);
    expect(find.text('Créer un puzzle'), findsOneWidget);
  });

  testWidgets('Home screen shows the main call to action (EN)', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomeScreen(),
        ),
      ),
    );

    expect(find.text('Create a puzzle'), findsOneWidget);
  });
}
