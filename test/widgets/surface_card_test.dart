import 'package:dpfa/components/custom_themes.dart';
import 'package:dpfa/widgets/surface_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final theme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal));

  Future<Card> pumpCard(WidgetTester tester, SurfaceCard card) async {
    await tester.pumpWidget(MaterialApp(theme: theme, home: Scaffold(body: card)));
    return tester.widget<Card>(find.byType(Card));
  }

  testWidgets('uses the card background and outline of the theme', (tester) async {
    final card = await pumpCard(tester, const SurfaceCard(child: Text('content')));

    expect(find.text('content'), findsOneWidget);
    expect(card.color, equals(theme.colorScheme.cardBackground));
    final shape = card.shape! as RoundedRectangleBorder;
    expect(shape.side.color, equals(theme.colorScheme.outlineVariant));
    expect(shape.borderRadius, equals(BorderRadius.circular(20)));
  });

  testWidgets('applies a custom fill, outline and radius', (tester) async {
    final card = await pumpCard(
      tester,
      const SurfaceCard(color: Colors.red, borderColor: Colors.blue, radius: 8, child: SizedBox()),
    );

    expect(card.color, equals(Colors.red));
    final shape = card.shape! as RoundedRectangleBorder;
    expect(shape.side.color, equals(Colors.blue));
    expect(shape.borderRadius, equals(BorderRadius.circular(8)));
  });
}
