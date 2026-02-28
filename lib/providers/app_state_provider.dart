import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _hasSeenOnboarding = false;
  bool _isSosActive = false;
  bool _isTripleClickEnabled = true;
  bool _isAutoAudioEnabled = true;
  bool _isAutoLocationEnabled = true;
  bool _isDarkMode = false;
  bool _isPoliceAlertActive = false;
  double _threatLevel = 0.0;

  bool get isLoggedIn => _isLoggedIn;
  bool get hasSeenOnboarding => _hasSeenOnboarding;
  bool get isSosActive => _isSosActive;
  bool get isTripleClickEnabled => _isTripleClickEnabled;
  bool get isAutoAudioEnabled => _isAutoAudioEnabled;
  bool get isAutoLocationEnabled => _isAutoLocationEnabled;
  bool get isDarkMode => _isDarkMode;
  bool get isPoliceAlertActive => _isPoliceAlertActive;
  double get threatLevel => _threatLevel;

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  void setOnboardingComplete(bool value) {
    _hasSeenOnboarding = value;
    notifyListeners();
  }

  void setSosActive(bool value) {
    _isSosActive = value;
    notifyListeners();
  }

  void toggleTripleClick() {
    _isTripleClickEnabled = !_isTripleClickEnabled;
    notifyListeners();
  }

  void toggleAutoAudio() {
    _isAutoAudioEnabled = !_isAutoAudioEnabled;
    notifyListeners();
  }

  void toggleAutoLocation() {
    _isAutoLocationEnabled = !_isAutoLocationEnabled;
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setPoliceAlert(bool value) {
    _isPoliceAlertActive = value;
    notifyListeners();
  }

  void setThreatLevel(double value) {
    _threatLevel = value;
    notifyListeners();
  }
}
