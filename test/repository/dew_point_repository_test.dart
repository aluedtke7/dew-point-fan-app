import 'dart:convert';
import 'package:dpfa/repository/dew_point_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DewPointRepository', () {
    late DewPointRepository repository;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      repository = DewPointRepository();
    });

    test('dewPoints() returns a broadcast stream', () {
      final stream = repository.dewPoints();
      expect(stream.isBroadcast, isTrue);
    });

    test('dewPoints() returns the same stream instance on multiple calls', () {
      final stream1 = repository.dewPoints();
      final stream2 = repository.dewPoints();
      expect(stream1, same(stream2));
    });

    test('setUrl updates the URL and saves to SharedPreferences', () async {
      const testUrl = '192.168.1.100:8080';
      await repository.setUrl(testUrl);
      expect(repository.dewPointFanUrl, equals(testUrl));
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('DEW_POINT_FAN_URL'), equals(testUrl));
    });

    test('setUrl cleans up http prefix', () async {
      await repository.setUrl('http://192.168.1.100');
      expect(repository.dewPointFanUrl, equals('192.168.1.100'));

      await repository.setUrl('https://api.example.com');
      expect(repository.dewPointFanUrl, equals('api.example.com'));
    });

    test('init loads URL from SharedPreferences', () async {
      const savedUrl = 'saved.local:9000';
      SharedPreferences.setMockInitialValues({'DEW_POINT_FAN_URL': savedUrl});
      
      final newRepo = DewPointRepository();
      await newRepo.init();
      
      expect(newRepo.dewPointFanUrl, equals(savedUrl));
    });

    test('setOverride uses the client to post data', () async {
      int callCount = 0;
      final mockClient = MockClient((request) async {
        callCount++;
        expect(request.method, equals('POST'));
        expect(request.url.path, equals('/override'));
        final body = json.decode(request.body);
        expect(body['override'], equals(1));
        return http.Response('', 200);
      });

      final repo = DewPointRepository(client: mockClient);
      await repo.setOverride(1);
      expect(callCount, equals(1));
    });

    test('dewPoints stream emits data from server', () async {
      final mockData = {
        'update': '2023-10-27T10:00:00Z',
        'sensors': [],
        'reason': 1,
        'venting': true,
        'override': false,
        'remote_override': 0,
        'diff_min': 5,
        'hysteresis': 2
      };

      final mockClient = MockClient((request) async {
        return http.Response(json.encode(mockData), 200);
      });

      final repo = DewPointRepository(client: mockClient);
      
      // Take the first event and verify it
      final data = await repo.dewPoints().first;
      
      expect(data.venting, isTrue);
      expect(data.reason, equals(1));
    });

    test('dewPoints stream emits empty data on error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Error', 500);
      });

      final repo = DewPointRepository(client: mockClient);
      
      final data = await repo.dewPoints().first;
      
      // When fetch returns null, it yields DewPointData()
      expect(data.update, isNull);
      expect(data.sensors, isEmpty);
    });
  });
}
