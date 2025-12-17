import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? phoneNumber;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.phoneNumber,
  });

  // Convert User to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'photoUrl': photoUrl,
    'phoneNumber': phoneNumber,
  };

  // Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    photoUrl: json['photoUrl'],
    phoneNumber: json['phoneNumber'],
  );
}

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  // Mock user database (in-memory storage)
  static final Map<String, User> _registeredUsers = {};
  static final Map<String, String> _userPasswords = {}; // Store passwords

  // Initialize and load saved data
  Future<void> init() async {
    await _loadUserData();
    await _loadRegisteredUsers();
  }

  // Load saved user data
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');
    if (userJson != null) {
      _user = User.fromJson(json.decode(userJson));
      notifyListeners();
    }
  }

  // Save current user data
  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_user != null) {
      await prefs.setString('current_user', json.encode(_user!.toJson()));
    } else {
      await prefs.remove('current_user');
    }
  }

  // Load registered users
  Future<void> _loadRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('registered_users');
    final passwordsJson = prefs.getString('user_passwords');
    
    if (usersJson != null) {
      final Map<String, dynamic> usersMap = json.decode(usersJson);
      _registeredUsers.clear();
      usersMap.forEach((email, userData) {
        _registeredUsers[email] = User.fromJson(userData);
      });
    }
    
    if (passwordsJson != null) {
      final Map<String, dynamic> passwordsMap = json.decode(passwordsJson);
      _userPasswords.clear();
      passwordsMap.forEach((email, password) {
        _userPasswords[email] = password;
      });
    }
  }

  // Save registered users
  Future<void> _saveRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    
    final usersMap = <String, dynamic>{};
    _registeredUsers.forEach((email, user) {
      usersMap[email] = user.toJson();
    });
    await prefs.setString('registered_users', json.encode(usersMap));
    
    await prefs.setString('user_passwords', json.encode(_userPasswords));
  }

  // Mock Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (email.isNotEmpty && password.length >= 6) {
      // Check if user exists and password matches
      if (_registeredUsers.containsKey(email) && _userPasswords[email] == password) {
        _user = _registeredUsers[email];
        await _saveUserData();
        _isLoading = false;
        notifyListeners();
        return true;
      } else if (!_registeredUsers.containsKey(email)) {
        // Create a default user if not found (for backward compatibility)
        _user = User(
          id: email.hashCode.toString(),
          name: email.split('@')[0],
          email: email,
          photoUrl: 'https://i.pravatar.cc/150?img=11',
        );
        _registeredUsers[email] = _user!;
        _userPasswords[email] = password;
        await _saveRegisteredUsers();
        await _saveUserData();
        _isLoading = false;
        notifyListeners();
        return true;
      }
    }
    
    _isLoading = false;
    notifyListeners();
    return false;
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
      _userPasswords[email] = password;
      await _saveRegisteredUsers();
      await _saveUserData();
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
    await _saveUserData();
    _isLoading = false;
    notifyListeners();
  }

  // Update user information
  void updateUserInfo(String name, String email, {String? phoneNumber}) async {
    if (_user != null) {
      final oldEmail = _user!.email;
      
      // Update the user object
      _user = User(
        id: _user!.id,
        name: name,
        email: email,
        photoUrl: _user!.photoUrl,
        phoneNumber: phoneNumber ?? _user!.phoneNumber,
      );
      
      // Update in the registered users map
      if (oldEmail != email) {
        _registeredUsers.remove(oldEmail);
        final password = _userPasswords[oldEmail];
        if (password != null) {
          _userPasswords.remove(oldEmail);
          _userPasswords[email] = password;
        }
      }
      _registeredUsers[email] = _user!;
      
      await _saveRegisteredUsers();
      await _saveUserData();
      notifyListeners();
    }
  }

  // Update profile photo
  void updatePhotoUrl(String photoUrl) async {
    if (_user != null) {
      _user = User(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        photoUrl: photoUrl,
        phoneNumber: _user!.phoneNumber,
      );
      
      // Update in the registered users map
      _registeredUsers[_user!.email] = _user!;
      
      await _saveRegisteredUsers();
      await _saveUserData();
      notifyListeners();
    }
  }

  // Change Password
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    if (_user == null) return false;
    
    final email = _user!.email;
    // Check if the current password matches
    if (_userPasswords[email] == currentPassword) {
      // Update the password
      _userPasswords[email] = newPassword;
      await _saveRegisteredUsers();
      return true;
    }
    return false;
  }
}
