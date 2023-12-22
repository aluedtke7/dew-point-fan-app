import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

const bool useMaterial3 = true;

var customThemes = [
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
