import 'dart:io';
import 'dart:ui';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';

import 'package:dpfa/application.dart';
import 'package:dpfa/components/custom_themes.dart';
import 'package:dpfa/specific_localization_delegate.dart';
import 'package:dpfa/views/main_page.dart';

void main() {
  runApp(const ProviderScope(child: DewPointFanApp()));
}

class DewPointFanApp extends ConsumerStatefulWidget {
  const DewPointFanApp({super.key});

  @override
  ConsumerState<DewPointFanApp> createState() => _DewPointFanAppState();
}

class _DewPointFanAppState extends ConsumerState<DewPointFanApp> {
  late SpecificLocalizationDelegate _localeOverrideDelegate;

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
            home: const MainPage(),
          );
        }),
      ),
    );
  }
}
