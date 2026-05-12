import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game/main.dart';
import 'package:get_it/get_it.dart';

void main() {
  tearDown(() async {
    await GetIt.I.reset();
  });

  testWidgets('KingdomApp builds the home screen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 600));

    await tester.pumpWidget(const KingdomApp());
    await tester.pump();

    expect(find.text('Kingdom Rebuild'), findsOneWidget);
    expect(find.text('Gold'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
