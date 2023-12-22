import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';

import 'package:dpfa/application.dart';
import 'package:dpfa/components/i18n_util.dart';
import 'package:dpfa/provider/dew_point_provider.dart';
import 'package:dpfa/widgets/action_choice.dart';
import 'package:dpfa/widgets/sensor_card.dart';
import 'package:dpfa/widgets/status_card.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  static const routeName = '/';

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  late Timer updateTimer;

  @override
  void initState() {
    super.initState();
    updateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      ref.read(dewPointDataProvider.notifier).fetchDewPoint();
    });
    ref.read(dewPointDataProvider.notifier).fetchDewPoint();
  }

  @override
  Widget build(BuildContext context) {
    final dewPointDataRef = ref.watch(dewPointDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n(context).title),
        backgroundColor: Theme.of(context).useMaterial3 ? Theme.of(context).colorScheme.inversePrimary : null,
        actions: [
          IconButton(
            onPressed: () {
              ThemeProvider.controllerOf(context).nextTheme();
            },
            icon: const Icon(Icons.color_lens),
            tooltip: i18n(context).com_change_theme,
          ),
          IconButton(
            onPressed: () {
              if ((Intl.defaultLocale ?? '').contains('de')) {
                Intl.defaultLocale = 'en';
                APPLIC().onLocaleChanged(const Locale('en', ''));
              } else {
                Intl.defaultLocale = 'de';
                APPLIC().onLocaleChanged(const Locale('de', ''));
              }
            },
            icon: const Icon(Icons.language),
            tooltip: i18n(context).com_change_language,
          )
        ],
      ),
      body: Container(
        decoration: Theme.of(context).useMaterial3
            ? null
            : BoxDecoration(
                color: const Color.fromARGB(255, 200, 200, 200).withOpacity(0.9),
              ),
        child: Column(
          children: [
            StatusCard(dewPointData: dewPointDataRef),
            if (dewPointDataRef.sensors.isNotEmpty) SensorCard(sensorData: dewPointDataRef.sensors[0]),
            if (dewPointDataRef.sensors.length > 1) SensorCard(sensorData: dewPointDataRef.sensors[1]),
            const SizedBox(
              height: 16,
            ),
            const ActionChoice(),
          ],
        ),
      ),
    );
  }
}
