import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:dpfa/models/dew_point_data.dart';
import 'package:dpfa/models/remote_control_data.dart';

class DewPointRepository {
  String dewPointFanUrl = '';
  static final DewPointRepository _instance = DewPointRepository._internal();

  factory DewPointRepository() {
    return _instance;
  }

  DewPointRepository._internal() {
    dewPointFanUrl = const String.fromEnvironment('DEW_POINT_FAN_URL', defaultValue: 'localhost:8080');
  }

  Stream<DewPointData> dewPoints() async* {
    while (true) {
      var dpd = await _fetchDewPoint();
      if (dpd != null) {
        debugPrint('Fetched data: ${dpd.update}');
        yield dpd;
      }
      await Future<void>.delayed(const Duration(seconds: 5));
    }
  }

  Future<DewPointData?> _fetchDewPoint() async {
    try {
      debugPrint('Fetching dew point data...');
      var url = Uri.http(dewPointFanUrl, '/info', {});
      final response = await http.get(url);
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
      final response = await http.post(
        url,
        body: body,
      );
      debugPrint('set override - status code: ${response.statusCode}');
    } catch (error) {
      debugPrint('Error posting override value: $error');
    }
  }
}
