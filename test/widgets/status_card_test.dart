import 'package:dpfa/models/dew_point_data.dart';
import 'package:dpfa/src/generated/l10n/app_localizations.dart';
import 'package:dpfa/widgets/status_card.dart';
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

  final update = DateTime(2026, 10, 23, 14, 32);

  double turns(WidgetTester tester) {
    final icon = find.descendant(of: find.byType(StatusCard), matching: find.byType(RotationTransition));
    return tester.widget<RotationTransition>(icon).turns.value;
  }

  testWidgets('shows a running fan with its reason and override mode', (tester) async {
    await tester.pumpWidget(wrap(StatusCard(
      dewPointData: DewPointData(update: update, venting: true, reason: 3, remoteOverride: 0),
    )));

    expect(find.text('Running'), findsOneWidget);
    expect(find.text('Dewpoint > hysteresis'), findsOneWidget);
    expect(find.text('Remote override is automatic'), findsOneWidget);
  });

  testWidgets('shows a stopped fan in German', (tester) async {
    await tester.pumpWidget(wrap(
      StatusCard(dewPointData: DewPointData(update: update, venting: false, reason: 4, remoteOverride: 2)),
      locale: const Locale('de'),
    ));

    expect(find.text('Aus'), findsOneWidget);
    expect(find.text('Taupunkt < Hysterese'), findsOneWidget);
    expect(find.text('Übersteuerung ist AUS'), findsOneWidget);
  });

  testWidgets('turns the fan icon only while venting', (tester) async {
    await tester.pumpWidget(wrap(StatusCard(dewPointData: DewPointData(update: update, venting: true))));
    await tester.pump(const Duration(milliseconds: 400));
    expect(turns(tester), greaterThan(0));

    await tester.pumpWidget(wrap(StatusCard(dewPointData: DewPointData(update: update, venting: false))));
    final stopped = turns(tester);
    await tester.pump(const Duration(milliseconds: 400));
    expect(turns(tester), equals(stopped));
  });

  testWidgets('keeps the fan icon still when animations are disabled', (tester) async {
    await tester.pumpWidget(wrap(MediaQuery(
      data: const MediaQueryData(disableAnimations: true),
      child: StatusCard(dewPointData: DewPointData(update: update, venting: true)),
    )));
    await tester.pump(const Duration(milliseconds: 400));

    expect(turns(tester), equals(0));
  });

  testWidgets('shows an unknown fan state without data', (tester) async {
    await tester.pumpWidget(wrap(StatusCard(dewPointData: DewPointData(venting: true))));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Unknown'), findsOneWidget);
    expect(find.text('No data'), findsOneWidget);
    expect(find.textContaining('Remote override'), findsNothing);
    expect(turns(tester), equals(0));
  });

  testWidgets('names an override only once', (tester) async {
    await tester.pumpWidget(wrap(
      StatusCard(dewPointData: DewPointData(update: update, venting: false, reason: 10, remoteOverride: 2)),
      locale: const Locale('de'),
    ));

    expect(find.text('Übersteuerung ist AUS'), findsOneWidget);
  });
}
