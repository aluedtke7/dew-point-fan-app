import 'package:dpfa/models/sensor_data.dart';
import 'package:dpfa/src/generated/l10n/app_localizations.dart';
import 'package:dpfa/widgets/sensor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final sensor = SensorData(
    name: 'Outside',
    temperature: 12.3,
    humidity: 78.0,
    dewPoint: 8.5,
    batLevel: 2.8,
    rssi: -88,
    upTime: 86400,
    scanned: DateTime(2026, 7, 27, 17, 23, 48),
  );

  Widget wrap(Widget child, {Locale locale = const Locale('en')}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  testWidgets('shows the stale hint with the gap in minutes and seconds', (tester) async {
    await tester.pumpWidget(wrap(SensorCard(
      sensorData: sensor,
      staleBy: const Duration(minutes: 7, seconds: 12),
    )));

    expect(find.text('Stale – 7 min 12 s older'), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber), findsOneWidget);
  });

  testWidgets('shows the localized stale hint in German', (tester) async {
    await tester.pumpWidget(wrap(
      SensorCard(
        sensorData: sensor,
        staleBy: const Duration(minutes: 7, seconds: 12),
      ),
      locale: const Locale('de'),
    ));

    expect(find.text('Veraltet – 7 Min 12 s älter'), findsOneWidget);
  });

  testWidgets('shows no stale hint without a gap', (tester) async {
    await tester.pumpWidget(wrap(SensorCard(sensorData: sensor)));

    expect(find.byIcon(Icons.warning_amber), findsNothing);
    expect(find.textContaining('Stale'), findsNothing);
  });

  testWidgets('shows the no-data message for a sensor without a reading', (tester) async {
    await tester.pumpWidget(wrap(SensorCard(sensorData: SensorData())));

    expect(find.text('No sensor data received'), findsOneWidget);
    expect(find.byIcon(Icons.sensors_off), findsOneWidget);
  });

  testWidgets('shows the localized no-data message in German', (tester) async {
    await tester.pumpWidget(wrap(
      SensorCard(sensorData: SensorData()),
      locale: const Locale('de'),
    ));

    expect(find.text('Keine Sensordaten empfangen'), findsOneWidget);
  });

  testWidgets('shows no no-data message for a sensor with a reading', (tester) async {
    await tester.pumpWidget(wrap(SensorCard(sensorData: sensor)));

    expect(find.byIcon(Icons.sensors_off), findsNothing);
  });
}
