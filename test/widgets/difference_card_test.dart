import 'package:dpfa/src/generated/l10n/app_localizations.dart';
import 'package:dpfa/widgets/difference_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child, {Locale locale = const Locale('en')}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  double fillFactor(WidgetTester tester) {
    return tester.widget<FractionallySizedBox>(find.byType(FractionallySizedBox)).widthFactor!;
  }

  testWidgets('shows the difference and the thresholds', (tester) async {
    await tester.pumpWidget(wrap(const DifferenceCard(difference: 7.06, diffMin: 5, hysteresis: 1)));

    expect(find.text('Dew point difference'), findsOneWidget);
    expect(find.text('7.1 K'), findsOneWidget);
    expect(find.text('Min. difference 5 K · hysteresis 1 K'), findsOneWidget);
  });

  testWidgets('uses the German decimal separator', (tester) async {
    await tester.pumpWidget(wrap(
      const DifferenceCard(difference: 7.06, diffMin: 5, hysteresis: 1),
      locale: const Locale('de'),
    ));

    expect(find.text('7,1 K'), findsOneWidget);
  });

  testWidgets('scales the bar to twice the venting threshold', (tester) async {
    await tester.pumpWidget(wrap(const DifferenceCard(difference: 3, diffMin: 5, hysteresis: 1)));

    expect(fillFactor(tester), closeTo(0.25, 1e-9));
  });

  testWidgets('paints the fill at the full bar height', (tester) async {
    await tester.pumpWidget(wrap(const DifferenceCard(difference: 2.3, diffMin: 3, hysteresis: 1)));

    final fill = find.descendant(of: find.byType(FractionallySizedBox), matching: find.byType(DecoratedBox));
    final bar = find.ancestor(of: find.byType(FractionallySizedBox), matching: find.byType(Container)).first;
    final size = tester.getSize(fill);
    expect(size.height, equals(10));
    expect(size.width, closeTo(tester.getSize(bar).width * 2.3 / 8, 0.5));
  });

  testWidgets('fills the bar for a difference above the scale', (tester) async {
    await tester.pumpWidget(wrap(const DifferenceCard(difference: 20, diffMin: 5, hysteresis: 1)));

    expect(fillFactor(tester), equals(1));
  });

  testWidgets('leaves the bar empty for a negative difference', (tester) async {
    await tester.pumpWidget(wrap(const DifferenceCard(difference: -2.5, diffMin: 5, hysteresis: 1)));

    expect(fillFactor(tester), equals(0));
  });
}
