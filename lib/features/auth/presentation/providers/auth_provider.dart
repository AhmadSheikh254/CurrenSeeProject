import 'package:flutter/material.dart';
import '../../../../shared/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepositoryImpl();
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    _user = await _repository.getCurrentUser();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await _repository.login(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await _repository.signUp(name, email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await _repository.signInWithGoogle();
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await _repository.logout();
    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUserInfo(String name, String email, {String? phoneNumber}) async {
    if (_user != null) {
      final updatedUser = UserModel(
        id: _user!.id,
        name: name,
        email: email,
        photoUrl: _user!.photoUrl,
        phoneNumber: phoneNumber ?? _user!.phoneNumber,
      );
      final result = await _repository.updateUserInfo(updatedUser);
      if (result != null) {
        _user = result;
        notifyListeners();
      }
    }
  }

  Future<void> updatePhotoUrl(String photoUrl) async {
    if (_user != null) {
      final result = await _repository.updatePhotoUrl(_user!.id, photoUrl);
      if (result != null) {
        _user = result;
        notifyListeners();
      }
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    return await _repository.changePassword(currentPassword, newPassword);
  }
}
