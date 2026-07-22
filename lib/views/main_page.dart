import 'package:dpfa/application.dart';
import 'package:dpfa/bloc/dew_point_bloc.dart';
import 'package:dpfa/bloc/dew_point_state.dart';
import 'package:dpfa/components/i18n_util.dart';
import 'package:dpfa/components/settings_dialog.dart';
import 'package:dpfa/repository/dew_point_repository.dart';
import 'package:dpfa/widgets/action_choice.dart';
import 'package:dpfa/widgets/sensor_card.dart';
import 'package:dpfa/widgets/status_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(i18n(context).title),
        backgroundColor: Theme.of(context).useMaterial3 ? Theme.of(context).colorScheme.inversePrimary : null,
        actions: [
          PopupMenuButton<_MenuAction>(
            onSelected: (action) {
              switch (action) {
                case _MenuAction.changeTheme:
                  ThemeProvider.controllerOf(context).nextTheme();
                  break;
                case _MenuAction.changeLanguage:
                  if ((Intl.defaultLocale ?? '').contains('de')) {
                    Intl.defaultLocale = 'en';
                    APPLIC().onLocaleChanged(const Locale('en', ''));
                  } else {
                    Intl.defaultLocale = 'de';
                    APPLIC().onLocaleChanged(const Locale('de', ''));
                  }
                  break;
                case _MenuAction.settings:
                  showSettingsDialog(context, context.read<DewPointRepository>());
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _MenuAction.changeTheme,
                child: ListTile(
                  leading: const Icon(Icons.color_lens),
                  title: Text(i18n(context).com_change_theme),
                ),
              ),
              PopupMenuItem(
                value: _MenuAction.changeLanguage,
                child: ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(i18n(context).com_change_language),
                ),
              ),
              PopupMenuItem(
                value: _MenuAction.settings,
                child: ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(i18n(context).com_settings),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: Theme.of(context).useMaterial3
            ? null
            : BoxDecoration(
                color: const Color.fromARGB(255, 200, 200, 200).withValues(alpha: 0.9),
              ),
        child: BlocBuilder<DewPointBloc, DewPointState>(
          builder: (context, state) {
            return Column(
              children: [
                if (state.data.update == null)
                  Container(
                    width: double.infinity,
                    color: Colors.red.shade100,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_off, color: Colors.red.shade700, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          i18n(context).disconnected,
                          style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                StatusCard(dewPointData: state.data),
                if (state.data.sensors.isNotEmpty) SensorCard(sensorData: state.data.sensors[0]),
                if (state.data.sensors.length > 1) SensorCard(sensorData: state.data.sensors[1]),
                const SizedBox(
                  height: 16,
                ),
                const ActionChoice(),
              ],
            );
          },
        ),
      ),
    );
  }
}

enum _MenuAction { changeTheme, changeLanguage, settings }
