import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String formatEYMD([String localeName = 'en']) {
    return DateFormat('yMd', localeName).format(this);
  }

  String formatDateTime([String localeName = 'en']) {
    return DateFormat.yMd(localeName).add_Hms().format(this);
  }

  String formatEYMDshort([String localeName = 'en']) {
    return DateFormat('MEd', localeName).format(this);
  }

  String formatHourMinute() {
    final minutes = '$minute'.padLeft(2, '0');
    return '$hour:$minutes';
  }

  String formatHourMinuteSecond() {
    final minutes = '$minute'.padLeft(2, '0');
    final seconds = '$second'.padLeft(2, '0');
    return '$hour:$minutes:$seconds';
  }

  String formatYMD([String localeName = 'en']) {
    return DateFormat('yMd', localeName).format(this);
  }
}