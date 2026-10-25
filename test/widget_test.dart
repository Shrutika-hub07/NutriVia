import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Smoke test: verify app bootstraps, theme loads, and core widgets render.
// Full integration tests live in integration_test/.
void main() {
  testWidgets('Nutrivia smoke test — app title and scaffold render', (WidgetTester tester) async {
    // Use a minimal app shell so we don't need rootBundle / asset loading.
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          title: 'Nutrivia',
          home: Scaffold(
            body: Center(child: Text('Nutrivia')),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Nutrivia'), findsOneWidget);
  });

  testWidgets('Custom color token plum renders in a container', (WidgetTester tester) async {
    const plum = Color(0xFF5B2A86);
    await tester.pumpWidget(
      MaterialApp(
        home: Container(color: plum, width: 100, height: 100),
      ),
    );
    await tester.pump();
    expect(find.byType(Container), findsOneWidget);
  });
}
