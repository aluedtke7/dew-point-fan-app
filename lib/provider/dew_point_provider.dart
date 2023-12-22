import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:dpfa/models/remote_control_data.dart';
import 'package:dpfa/models/dew_point_data.dart';

class SelectedOverrideNotifier extends StateNotifier<int> {
  SelectedOverrideNotifier() : super(0);

  void setOverride(int newValue){
    state = newValue;
  }
}

final selectedOverrideProvider = StateNotifierProvider<SelectedOverrideNotifier, int>((ref) => SelectedOverrideNotifier());


class DewPointNotifier extends StateNotifier<DewPointData> {
  DewPointNotifier(this.ref) : super(DewPointData()) {
    dewPointFanUrl = const String.fromEnvironment('DEW_POINT_FAN_URL', defaultValue: 'localhost:8080');
  }
  final Ref ref;
  String dewPointFanUrl = '';

  void setDewPointData(DewPointData newData) {
    state = newData;
  }

  Future<void> fetchDewPoint() async {
    try {
      var url = Uri.http(dewPointFanUrl, '/info', {});
      final response = await http.get(url);
      final obj = json.decode(response.body);
      if (obj != null) {
        final dpd = DewPointData.fromJson(obj);
        setDewPointData(dpd);
        ref.read(selectedOverrideProvider.notifier).setOverride(dpd.remoteOverride);
      }
    } catch (error) {
      debugPrint('Error fetching dew point data: $error');
    }
  }

  Future<void> setOverride(int value) async {
    ref.read(selectedOverrideProvider.notifier).setOverride(value);
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

final dewPointDataProvider = StateNotifierProvider<DewPointNotifier, DewPointData>((ref) => DewPointNotifier(ref));
