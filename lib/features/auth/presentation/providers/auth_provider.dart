import 'package:flutter/material.dart';
import '../../../../shared/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepositoryImpl();
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _parseError(dynamic e) {
    final errStr = e.toString();
    if (errStr.contains('user-not-found')) {
      return 'No user account found with this email.';
    } else if (errStr.contains('wrong-password')) {
      return 'Incorrect password. Please try again.';
    } else if (errStr.contains('invalid-email')) {
      return 'The email address is invalid.';
    } else if (errStr.contains('email-already-in-use')) {
      return 'An account already exists with this email address.';
    } else if (errStr.contains('weak-password')) {
      return 'The password is too weak. Must be at least 6 characters.';
    } else if (errStr.contains('network-request-failed')) {
      return 'Network connection failed. Please check your internet.';
    } else if (errStr.contains('user-disabled')) {
      return 'This user account has been disabled.';
    }
    // Remove the prefix "FirebaseAuthException: " or "Exception: " if present
    return errStr.replaceAll(RegExp(r'^.*?Exception:\s*'), '');
  }

  Future<void> init() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await _repository.getCurrentUser();
    } catch (e) {
      _errorMessage = _parseError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await _repository.login(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _parseError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await _repository.signUp(name, email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _parseError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await _repository.signInWithGoogle();
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _errorMessage = _parseError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _repository.logout();
      _user = null;
    } catch (e) {
      _errorMessage = _parseError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserInfo(String name, String email, {String? phoneNumber}) async {
    if (_user != null) {
      _errorMessage = null;
      final updatedUser = UserModel(
        id: _user!.id,
        name: name,
        email: email,
        photoUrl: _user!.photoUrl,
        phoneNumber: phoneNumber ?? _user!.phoneNumber,
      );
      try {
        final result = await _repository.updateUserInfo(updatedUser);
        if (result != null) {
          _user = result;
          notifyListeners();
        }
      } catch (e) {
        _errorMessage = _parseError(e);
        notifyListeners();
      }
    }
  }

  Future<void> updatePhotoUrl(String photoUrl) async {
    if (_user != null) {
      _errorMessage = null;
      try {
        final result = await _repository.updatePhotoUrl(_user!.id, photoUrl);
        if (result != null) {
          _user = result;
          notifyListeners();
        }
      } catch (e) {
        _errorMessage = _parseError(e);
        notifyListeners();
      }
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    _errorMessage = null;
    try {
      final success = await _repository.changePassword(currentPassword, newPassword);
      if (!success) {
        _errorMessage = 'Password update failed. Verify your current password.';
      }
      return success;
    } catch (e) {
      _errorMessage = _parseError(e);
      return false;
    }
  }
}
