import 'dart:convert';

import 'package:dpfa/models/dew_point_data.dart';
import 'package:dpfa/models/remote_control_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DewPointRepository {
  String dewPointFanUrl = '';
  static const String _urlKey = 'DEW_POINT_FAN_URL';
  final http.Client _client;

  DewPointRepository({http.Client? client})
      : _client = client ?? http.Client(),
        dewPointFanUrl = const String.fromEnvironment(_urlKey, defaultValue: 'localhost:8080');

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUrl = prefs.getString(_urlKey);
    if (savedUrl != null && savedUrl.isNotEmpty) {
      dewPointFanUrl = savedUrl;
    }
  }

  Future<void> setUrl(String url) async {
    // Basic cleanup: remove http:// or https:// if present
    String cleanUrl = url.trim();
    if (cleanUrl.startsWith('http://')) {
      cleanUrl = cleanUrl.substring(7);
    } else if (cleanUrl.startsWith('https://')) {
      cleanUrl = cleanUrl.substring(8);
    }

    dewPointFanUrl = cleanUrl;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_urlKey, cleanUrl);
  }

  Stream<DewPointData>? _sharedDewPointStream;

  Stream<DewPointData> dewPoints() {
    return _sharedDewPointStream ??= _dewPoints().asBroadcastStream();
  }

  Stream<DewPointData> _dewPoints() async* {
    var retryDelay = 1;
    while (true) {
      var dpd = await _fetchDewPoint();
      if (dpd != null) {
        debugPrint('Fetched data: ${dpd.update}');
        yield dpd;
        retryDelay = 1;
        await Future<void>.delayed(const Duration(seconds: 5));
      } else {
        yield DewPointData();
        await Future<void>.delayed(Duration(seconds: retryDelay));
        retryDelay = (retryDelay * 2).clamp(1, 30);
      }
    }
  }

  Future<DewPointData?> _fetchDewPoint() async {
    try {
      debugPrint('Fetching dew point data from $dewPointFanUrl...');
      var url = Uri.http(dewPointFanUrl, '/info', {});
      final response = await _client.get(url).timeout(const Duration(seconds: 3));
      if (response.statusCode != 200) {
        debugPrint('Unexpected status code: ${response.statusCode}');
        return null;
      }
      final obj = json.decode(response.body);
      if (obj != null) {
        final dpd = DewPointData.fromJson(obj);
        return dpd;
      }
    } catch (error) {
      debugPrint('Error fetching dew point data: $error');
    }
    return null;
  }

  Future<void> setOverride(int value) async {
    try {
      var url = Uri.http(dewPointFanUrl, '/override');
      final rcd = RemoteControlData(override: value);
      final body = const JsonEncoder().convert(rcd);
      final response = await _client.post(
        url,
        body: body,
      ).timeout(const Duration(seconds: 3));
      debugPrint('set override - status code: ${response.statusCode}');
    } catch (error) {
      debugPrint('Error posting override value: $error');
    }
  }
}
