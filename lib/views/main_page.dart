import 'package:dpfa/application.dart';
import 'package:dpfa/bloc/dew_point_bloc.dart';
import 'package:dpfa/bloc/dew_point_state.dart';
import 'package:dpfa/components/custom_themes.dart';
import 'package:dpfa/components/i18n_util.dart';
import 'package:dpfa/components/settings_dialog.dart';
import 'package:dpfa/models/extensions.dart';
import 'package:dpfa/repository/dew_point_repository.dart';
import 'package:dpfa/widgets/action_choice.dart';
import 'package:dpfa/widgets/difference_card.dart';
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
    final theme = Theme.of(context);
    final pageBackground = theme.useMaterial3 ? theme.colorScheme.pageBackground : null;
    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        toolbarHeight: 72,
        title: const _Title(),
        backgroundColor: pageBackground,
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
            final staleIndex = state.data.staleSensorIndex;
            final staleBy = state.data.scanGap;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 12,
                      children: [
                        if (state.data.update == null) const _DisconnectedBanner(),
                        StatusCard(dewPointData: state.data),
                        if (state.data.sensors.length > 1)
                          DifferenceCard(
                            difference: state.data.sensors[0].dewPoint - state.data.sensors[1].dewPoint,
                            diffMin: state.data.diffMin,
                            hysteresis: state.data.hysteresis,
                          ),
                        if (state.data.sensors.isNotEmpty)
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              spacing: 12,
                              children: [
                                for (var i = 0; i < state.data.sensors.length && i < 2; i++)
                                  Expanded(
                                    child: SensorCard(
                                      sensorData: state.data.sensors[i],
                                      staleBy: staleIndex == i ? staleBy : null,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SafeArea(
                  top: false,
                  minimum: EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: ActionChoice(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// App title with the time of the last update and a dot showing the
/// connection state below it.
class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return BlocBuilder<DewPointBloc, DewPointState>(
      builder: (context, state) {
        final update = state.data.update;
        final Color dotColor;
        if (update == null) {
          dotColor = scheme.error;
        } else if (state.data.staleSensorIndex != null) {
          dotColor = scheme.warning;
        } else {
          // A Material 2 app bar is filled with the primary color itself.
          dotColor = theme.useMaterial3 ? scheme.primary : scheme.onPrimary;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(i18n(context).title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    i18n(context).update(update == null ? '---' : update.formatDateTime(i18n(context).localeName)),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _DisconnectedBanner extends StatelessWidget {
  const _DisconnectedBanner();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.cloud_off, color: scheme.onErrorContainer, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              i18n(context).disconnected,
              style: TextStyle(color: scheme.onErrorContainer, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

enum _MenuAction { changeTheme, changeLanguage, settings }
