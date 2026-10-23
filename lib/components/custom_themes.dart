import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

const bool useMaterial3 = true;

const Color _teal = Color(0xFF0B7A84);

var customThemes = [
  AppTheme(
    id: 'light-teal',
    description: 'Light teal',
    data: ThemeData(
      useMaterial3: useMaterial3,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _teal,
        brightness: Brightness.light,
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      ),
    ),
  ),
  AppTheme(
    id: 'dark-teal',
    description: 'Dark teal',
    data: ThemeData(
      useMaterial3: useMaterial3,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _teal,
        brightness: Brightness.dark,
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      ),
    ),
  ),
  AppTheme(
    id: 'light-green',
    description: 'Light green',
    data: ThemeData(
      useMaterial3: useMaterial3,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: Brightness.light,
      ),
    ),
  ),
  AppTheme(
    id: 'light-blue',
    description: 'Light blue',
    data: ThemeData(
      useMaterial3: useMaterial3,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
    ),
  ),
  AppTheme(
    id: 'light-orange',
    description: 'Light orange',
    data: ThemeData(
      useMaterial3: useMaterial3,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.orange,
        brightness: Brightness.light,
      ),
    ),
  ),
  AppTheme(
    id: 'light-orange-m2',
    description: 'Light orange material 2',
    data: ThemeData(
      useMaterial3: false,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.deepOrange,
      ),
    ),
  ),
  AppTheme(
    id: 'dark-green',
    description: 'Dark green',
    data: ThemeData(
      useMaterial3: useMaterial3,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: Brightness.dark,
      ),
    ),
  ),
  AppTheme(
    id: 'dark-blue',
    description: 'Dark blue',
    data: ThemeData(
      useMaterial3: useMaterial3,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
    ),
  ),
  AppTheme(
    id: 'dark-orange',
    description: 'Dark orange',
    data: ThemeData(
      useMaterial3: useMaterial3,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.orange,
        brightness: Brightness.dark,
      ),
    ),
  ),
];

extension AppColors on ColorScheme {
  /// Background behind the cards of the main page.
  Color get pageBackground => brightness == Brightness.light ? surfaceContainerLow : surface;

  /// Fill of the cards, lifted off [pageBackground].
  Color get cardBackground => brightness == Brightness.light ? surfaceContainerLowest : surfaceContainerHigh;

  /// Marks stale data, readable on [cardBackground] and in the app bar.
  Color get warning => brightness == Brightness.light ? Colors.orange.shade800 : Colors.orange.shade300;
}
