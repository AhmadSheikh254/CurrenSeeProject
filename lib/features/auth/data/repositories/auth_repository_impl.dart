import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../shared/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://currensee-ce2a8-default-rtdb.firebaseio.com/',
  );

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;
      final googleAuth = await googleUser.authentication;
      final credential = fb_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final cred = await _auth.signInWithCredential(credential);
      if (cred.user != null) {
        return await _fetchUserData(cred.user!.uid, cred.user!.email ?? '');
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  @override
  Future<UserModel?> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (cred.user != null) {
        return await _fetchUserData(cred.user!.uid, cred.user!.email ?? '');
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  @override
  Future<UserModel?> signUp(String name, String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (cred.user != null) {
        final newUser = UserModel(
          id: cred.user!.uid,
          name: name,
          email: email,
          photoUrl: 'https://api.dicebear.com/7.x/lorelei/png?seed=CurrenSee',
        );
        await _database.ref('users/${cred.user!.uid}').set(newUser.toJson());
        return newUser;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      return await _fetchUserData(firebaseUser.uid, firebaseUser.email ?? '');
    }
    return null;
  }

  Future<UserModel> _fetchUserData(String uid, String fallbackEmail) async {
    final snapshot = await _database.ref('users/$uid').get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return UserModel.fromJson(data);
    } else {
      final newUser = UserModel(
        id: uid,
        name: fallbackEmail.split('@')[0],
        email: fallbackEmail,
        photoUrl: 'https://api.dicebear.com/7.x/lorelei/png?seed=CurrenSee',
      );
      await _database.ref('users/$uid').set(newUser.toJson());
      return newUser;
    }
  }

  @override
  Future<UserModel?> updateUserInfo(UserModel user) async {
    try {
      await _database.ref('users/${user.id}').update(user.toJson());
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserModel?> updatePhotoUrl(String uid, String photoUrl) async {
    try {
      await _database.ref('users/$uid').update({'photoUrl': photoUrl});
      final snapshot = await _database.ref('users/$uid').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return UserModel.fromJson(data);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    if (_auth.currentUser == null) return false;
    try {
      final email = _auth.currentUser!.email;
      if (email != null) {
        final cred = fb_auth.EmailAuthProvider.credential(email: email, password: currentPassword);
        await _auth.currentUser!.reauthenticateWithCredential(cred);
        await _auth.currentUser!.updatePassword(newPassword);
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
