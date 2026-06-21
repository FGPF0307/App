// Smoke test untuk FitArena.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitarena/widgets/fitarena_logo.dart';

void main() {
  testWidgets('FitArena logo renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: FitArenaLogo(size: 120)),
        ),
      ),
    );

    expect(find.byType(FitArenaLogo), findsOneWidget);
  });
}
