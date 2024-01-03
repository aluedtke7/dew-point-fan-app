import 'dart:io';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';

import 'package:dpfa/application.dart';
import 'package:dpfa/bloc/dew_point_bloc.dart';
import 'package:dpfa/bloc/dew_point_event.dart';
import 'package:dpfa/bloc/selected_override_bloc.dart';
import 'package:dpfa/bloc/selected_override_event.dart';
import 'package:dpfa/components/custom_themes.dart';
import 'package:dpfa/dew_point_observer.dart';
import 'package:dpfa/repository/dew_point_repository.dart';
import 'package:dpfa/specific_localization_delegate.dart';
import 'package:dpfa/views/main_page.dart';

void main() {
  Bloc.observer = const DewPointObserver();
  runApp(const DewPointFanApp());
}

class DewPointFanApp extends StatefulWidget {
  const DewPointFanApp({super.key});

  @override
  State<DewPointFanApp> createState() => _DewPointFanAppState();
}

class _DewPointFanAppState extends State<DewPointFanApp> {
  late SpecificLocalizationDelegate _localeOverrideDelegate;
  final dewPointRepo = DewPointRepository();

  @override
  void initState() {
    super.initState();
    final String initialLanguage;
    if (kIsWeb) {
      initialLanguage = PlatformDispatcher.instance.locale.languageCode;
    } else {
      initialLanguage = Platform.localeName.substring(0, 2);
    }
    _localeOverrideDelegate = SpecificLocalizationDelegate(Locale(initialLanguage));
    Intl.defaultLocale = initialLanguage;

    /// Let's save a pointer to this method, should the user wants to change its language
    /// We would then call: applic.onLocaleChanged(new Locale('en',''));
    APPLIC().onLocaleChanged = onLocaleChange;
  }

  onLocaleChange(Locale locale) {
    setState(() {
      _localeOverrideDelegate = SpecificLocalizationDelegate(locale);
    });
    debugPrint('Locale changed: $locale');
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      onThemeChanged: (oldTheme, newTheme) {
        debugPrint('Theme: ${newTheme.id}');
      },
      loadThemeOnInit: true,
      saveThemesOnChange: true,
      themes: customThemes,
      child: ThemeConsumer(
        child: Builder(builder: (themeCtx) {
          return MaterialApp(
            title: 'Dew Point Fan App',
            theme: ThemeProvider.themeOf(themeCtx).data,
            localizationsDelegates: [
              _localeOverrideDelegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: APPLIC().supportedLocales(),
            home: BlocProvider(
              create: (BuildContext ctx) {
                var bloc = DewPointBloc(repo: dewPointRepo);
                bloc.add(const DewPointNewData());
                return bloc;
              },
              child: BlocProvider(
                  create: (BuildContext ctx) {
                    var bloc = SelectedOverrideBloc(repo: dewPointRepo);
                    bloc.add(const SelectedOverrideNewData());
                    return bloc;
                  },
                  child: const MainPage()),
            ),
          );
        }),
      ),
    );
  }
}
