import 'package:dpfa/bloc/selected_override_bloc.dart';
import 'package:dpfa/bloc/selected_override_event.dart';
import 'package:dpfa/models/dew_point_data.dart';
import 'package:dpfa/repository/dew_point_repository.dart';
import 'package:dpfa/src/generated/l10n/app_localizations.dart';
import 'package:dpfa/widgets/action_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Serves one snapshot with [remoteOverride] and records the overrides sent.
class _StubRepository extends DewPointRepository {
  _StubRepository(this.remoteOverride);

  final int remoteOverride;
  final overrides = <int>[];

  @override
  Stream<DewPointData> dewPoints() =>
      Stream.value(DewPointData(update: DateTime(2026), remoteOverride: remoteOverride));

  @override
  Future<void> setOverride(int value) async => overrides.add(value);
}

void main() {
  Future<_StubRepository> pumpChoice(WidgetTester tester, {int remoteOverride = 0}) async {
    final repo = _StubRepository(remoteOverride);
    await tester.pumpWidget(RepositoryProvider<DewPointRepository>.value(
      value: repo,
      child: BlocProvider(
        create: (_) => SelectedOverrideBloc(repo: repo)..add(const SelectedOverrideNewData()),
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: ActionChoice()),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    return repo;
  }

  SemanticsNode segment(WidgetTester tester, String label) {
    return tester.getSemantics(find.ancestor(of: find.text(label), matching: find.byType(Semantics)).first);
  }

  testWidgets('sends the tapped override', (tester) async {
    final repo = await pumpChoice(tester);

    await tester.tap(find.text('force on'));
    await tester.pump();

    expect(repo.overrides, equals([1]));
  });

  testWidgets('ignores further taps until new data arrives', (tester) async {
    final repo = await pumpChoice(tester);

    await tester.tap(find.text('force on'));
    await tester.pump();
    await tester.tap(find.text('force off'));
    await tester.pump();

    expect(repo.overrides, equals([1]));
  });

  testWidgets('does not resend the selected override', (tester) async {
    final repo = await pumpChoice(tester, remoteOverride: 2);

    await tester.tap(find.text('force off'));
    await tester.pump();

    expect(repo.overrides, isEmpty);
  });

  testWidgets('reports the selected segment as selected and enabled', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpChoice(tester, remoteOverride: 1);

    expect(segment(tester, 'force on'), isSemantics(isButton: true, isSelected: true, isEnabled: true));
    expect(segment(tester, 'automatic'), isSemantics(isButton: true, isSelected: false, isEnabled: true));
    handle.dispose();
  });
}
