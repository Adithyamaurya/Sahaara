import 'dart:async';

class MockAuthService {
  static final MockAuthService _instance = MockAuthService._internal();
  factory MockAuthService() => _instance;

  MockAuthService._internal();

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }

  Future<bool> signUp(String email, String password, String confirmPassword) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }
}
