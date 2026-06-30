import '../../../../shared/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> login(String email, String password);
  Future<UserModel?> signUp(String name, String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<UserModel?> signInWithGoogle();
  Future<UserModel?> updateUserInfo(UserModel user);
  Future<UserModel?> updatePhotoUrl(String uid, String photoUrl);
  Future<bool> changePassword(String currentPassword, String newPassword);
}
