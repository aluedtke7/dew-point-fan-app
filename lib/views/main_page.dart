import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';

import 'package:dpfa/application.dart';
import 'package:dpfa/bloc/dew_point_bloc.dart';
import 'package:dpfa/components/i18n_util.dart';
import 'package:dpfa/repository/dew_point_repository.dart';
import 'package:dpfa/widgets/action_choice.dart';
import 'package:dpfa/widgets/sensor_card.dart';
import 'package:dpfa/widgets/status_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static const routeName = '/';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final dewPointRepo = DewPointRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            StatusCard(dewPointData: BlocProvider.of<DewPointBloc>(context, listen: true).state.data),
            if (BlocProvider.of<DewPointBloc>(context, listen: true).state.data.sensors.isNotEmpty)
              SensorCard(sensorData: BlocProvider.of<DewPointBloc>(context, listen: true).state.data.sensors[0]),
            if (BlocProvider.of<DewPointBloc>(context, listen: true).state.data.sensors.length > 1)
              SensorCard(sensorData: BlocProvider.of<DewPointBloc>(context, listen: true).state.data.sensors[1]),
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
