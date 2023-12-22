class RemoteControlData {
  int override = 0;

  RemoteControlData({this.override = 0});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map.putIfAbsent('override', () => override);
    return map;
  }
}
