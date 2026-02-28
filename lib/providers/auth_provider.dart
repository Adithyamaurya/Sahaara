import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_auth_service.dart';
import 'app_state_provider.dart';

class AuthProvider extends ChangeNotifier {
  final MockAuthService _authService = MockAuthService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password, BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final success = await _authService.login(email, password);

    _isLoading = false;
    if (success) {
      if (context.mounted) {
        Provider.of<AppStateProvider>(context, listen: false).setLoggedIn(true);
      }
      notifyListeners();
      return true;
    }
    _errorMessage = 'Invalid credentials';
    notifyListeners();
    return false;
  }

  Future<bool> signUp(
    String email,
    String password,
    String confirmPassword,
    BuildContext context,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final success = await _authService.signUp(email, password, confirmPassword);

    _isLoading = false;
    if (success) {
      if (context.mounted) {
        Provider.of<AppStateProvider>(context, listen: false).setLoggedIn(true);
      }
      notifyListeners();
      return true;
    }
    _errorMessage = 'Sign up failed';
    notifyListeners();
    return false;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
