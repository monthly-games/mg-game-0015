import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game/main.dart';

void main() {
  testWidgets('Kingdom Rebuild app builds', (WidgetTester tester) async {
    await tester.pumpWidget(const KingdomRebuildApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('KINGDOM REBUILD'), findsOneWidget);
  });
}
