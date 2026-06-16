import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:souvenir_puzzle/features/home/presentation/home_screen.dart';

void main() {
  testWidgets('Home screen shows the main call to action', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: HomeScreen())),
    );

    expect(find.text('Souvenir Puzzle'), findsOneWidget);
    expect(find.text('Créer un puzzle'), findsOneWidget);
  });
}
