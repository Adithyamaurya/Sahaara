import 'dart:async';

class MockEmergencyService {
  static final MockEmergencyService _instance = MockEmergencyService._internal();
  factory MockEmergencyService() => _instance;

  MockEmergencyService._internal();

  Future<void> triggerSos() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<Map<String, dynamic>> getMockLocation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'lat': 12.9716,
      'lng': 77.5946,
      'address': 'Bangalore, Karnataka',
    };
  }

  Future<double> getThreatLevel() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return 0.35; // Low threat
  }

  Future<bool> isPoliceWordDetected() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return false;
  }
}
