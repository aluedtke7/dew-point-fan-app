import 'package:dpfa/bloc/dew_point_bloc.dart';
import 'package:dpfa/bloc/dew_point_event.dart';
import 'package:dpfa/bloc/selected_override_bloc.dart';
import 'package:dpfa/bloc/selected_override_event.dart';
import 'package:dpfa/models/dew_point_data.dart';
import 'package:dpfa/repository/dew_point_repository.dart';
import 'package:dpfa/src/generated/l10n/app_localizations.dart';
import 'package:dpfa/views/main_page.dart';
import 'package:dpfa/widgets/sensor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Serves a single snapshot instead of the polling loop of
/// [DewPointRepository.dewPoints], so no timers outlive the test.
class _StubRepository extends DewPointRepository {
  _StubRepository(this.data);

  final DewPointData data;

  @override
  Stream<DewPointData> dewPoints() => Stream.value(data);
}

void main() {
  Map<String, dynamic> sensor(String name, String scanned) {
    return {
      'name': name,
      'temperature': 12.3,
      'humidity': 78.0,
      'dew_point': 8.5,
      'bat_level': 2.8,
      'rssi': -88,
      'up_time_in_sec': 86400,
      'scanned': scanned,
    };
  }

  /// The shape a server reports for a sensor that was never seen.
  Map<String, dynamic> emptySensor() {
    return {
      'name': '',
      'temperature': 0,
      'humidity': 0,
      'dew_point': 0,
      'bat_level': 0,
      'rssi': 0,
      'up_time_in_sec': 0,
      'scanned': '',
    };
  }

  DewPointData info(List<Map<String, dynamic>> sensors) {
    return DewPointData.fromJson({
      'update': '2026-07-27 17:31:00',
      'sensors': sensors,
      'reason': 2,
      'venting': false,
      'override': false,
      'remote_override': 0,
      'diff_min': 5,
      'hysteresis': 2,
    });
  }

  Future<void> pumpMainPage(WidgetTester tester, DewPointData data) async {
    final repo = _StubRepository(data);
    await tester.pumpWidget(RepositoryProvider<DewPointRepository>.value(
      value: repo,
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => DewPointBloc(repo: repo)..add(const DewPointNewData())),
            BlocProvider(
              create: (_) => SelectedOverrideBloc(repo: repo)..add(const SelectedOverrideNewData()),
            ),
          ],
          child: const MainPage(),
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('marks only the older sensor as stale', (tester) async {
    await pumpMainPage(
      tester,
      info([
        sensor('Inside', '2026-07-27 17:31:00'),
        sensor('Outside', '2026-07-27 17:23:48'),
      ]),
    );

    final cards = tester.widgetList<SensorCard>(find.byType(SensorCard)).toList();
    expect(cards, hasLength(2));
    expect(cards[0].staleBy, isNull);
    expect(cards[1].staleBy, equals(const Duration(minutes: 7, seconds: 12)));
    expect(find.text('Stale – 7 min 12 s older'), findsOneWidget);
  });

  testWidgets('marks the first sensor when it is the older one', (tester) async {
    await pumpMainPage(
      tester,
      info([
        sensor('Inside', '2026-07-27 17:20:00'),
        sensor('Outside', '2026-07-27 17:31:05'),
      ]),
    );

    final cards = tester.widgetList<SensorCard>(find.byType(SensorCard)).toList();
    expect(cards[0].staleBy, equals(const Duration(minutes: 11, seconds: 5)));
    expect(cards[1].staleBy, isNull);
    expect(find.text('Stale – 11 min 5 s older'), findsOneWidget);
  });

  testWidgets('shows no marker within the 5 minute threshold', (tester) async {
    await pumpMainPage(
      tester,
      info([
        sensor('Inside', '2026-07-27 17:31:00'),
        sensor('Outside', '2026-07-27 17:30:00'),
      ]),
    );

    expect(find.byIcon(Icons.warning_amber), findsNothing);
    expect(find.byIcon(Icons.sensors_off), findsNothing);
  });

  testWidgets('shows no marker for a payload without scanned values', (tester) async {
    await pumpMainPage(
      tester,
      info([
        sensor('Inside', '')..remove('scanned'),
        sensor('Outside', '')..remove('scanned'),
      ]),
    );

    expect(find.byType(SensorCard), findsNWidgets(2));
    expect(find.byIcon(Icons.warning_amber), findsNothing);
    expect(find.byIcon(Icons.sensors_off), findsNothing);
  });

  testWidgets('reports an empty sensor object on its own card only', (tester) async {
    await pumpMainPage(
      tester,
      info([
        sensor('Inside', '2026-07-27 17:31:00'),
        emptySensor(),
      ]),
    );

    expect(find.text('No sensor data received'), findsOneWidget);
    expect(find.byIcon(Icons.sensors_off), findsOneWidget);
    // No scan time to compare against, so no stale hint either.
    expect(find.byIcon(Icons.warning_amber), findsNothing);
  });

  testWidgets('reports both sensors when neither was ever seen', (tester) async {
    await pumpMainPage(tester, info([emptySensor(), emptySensor()]));

    expect(find.text('No sensor data received'), findsNWidgets(2));
  });

  testWidgets('shows no sensor message when the server is unreachable', (tester) async {
    await pumpMainPage(tester, DewPointData());

    expect(find.text('Server unreachable'), findsOneWidget);
    expect(find.byType(SensorCard), findsNothing);
    expect(find.text('No sensor data received'), findsNothing);
    expect(find.byIcon(Icons.sensors_off), findsNothing);
  });
}
