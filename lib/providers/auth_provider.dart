import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
  });
}

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  // Mock user database (in-memory storage)
  static final Map<String, User> _registeredUsers = {};

  // Mock Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (email.isNotEmpty && password.length >= 6) {
      // Check if user exists in our mock database
      if (_registeredUsers.containsKey(email)) {
        _user = _registeredUsers[email];
      } else {
        // Create a default user if not found (for backward compatibility)
        _user = User(
          id: email.hashCode.toString(),
          name: email.split('@')[0], // Use email prefix as name
          email: email,
          photoUrl: 'https://i.pravatar.cc/150?img=11',
        );
        _registeredUsers[email] = _user!;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Mock Signup
  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (name.isNotEmpty && email.isNotEmpty && password.length >= 6) {
      // Create and store the new user
      _user = User(
        id: email.hashCode.toString(),
        name: name,
        email: email,
        photoUrl: 'https://i.pravatar.cc/150?img=11',
      );
      _registeredUsers[email] = _user!;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  // Update user information
  void updateUserInfo(String name, String email) {
    if (_user != null) {
      final oldEmail = _user!.email;
      
      // Update the user object
      _user = User(
        id: _user!.id,
        name: name,
        email: email,
        photoUrl: _user!.photoUrl,
      );
      
      // Update in the registered users map
      if (oldEmail != email) {
        _registeredUsers.remove(oldEmail);
      }
      _registeredUsers[email] = _user!;
      
      notifyListeners();
    }
  }

  // Update profile photo
  void updatePhotoUrl(String photoUrl) {
    if (_user != null) {
      _user = User(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        photoUrl: photoUrl,
      );
      
      // Update in the registered users map
      _registeredUsers[_user!.email] = _user!;
      
      notifyListeners();
    }
  }
}
