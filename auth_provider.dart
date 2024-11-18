import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  bool login(String email, String password) {
    // Dummy login logic
    if (email == "user@example.com" && password == "password123") {
      _isAuthenticated = true;
      notifyListeners();
      return true; // Login successful
    }
    return false; // Login failed
  }

  void signup(String email, String password) {
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
