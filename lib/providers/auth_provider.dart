import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

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
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    photoUrl: json['photoUrl'],
    phoneNumber: json['phoneNumber'],
  );
}

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://currensee-ce2a8-default-rtdb.firebaseio.com/',
  );

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  // Initialize and listen to auth state
  Future<void> init() async {
    _auth.authStateChanges().listen((fb_auth.User? firebaseUser) async {
      if (firebaseUser != null) {
        await _fetchUserData(firebaseUser);
      } else {
        _user = null;
        notifyListeners();
      }
    });
  }

  // Fetch user data from Realtime Database
  Future<void> _fetchUserData(fb_auth.User firebaseUser) async {
    try {
      final snapshot = await _database.ref('users/${firebaseUser.uid}').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        _user = User.fromJson(data);
      } else {
        // User exists in Auth but not Database
        final newUser = User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? firebaseUser.email?.split('@')[0] ?? 'User',
          email: firebaseUser.email ?? '',
          photoUrl: firebaseUser.photoURL ?? 'https://i.pravatar.cc/150?img=11',
        );
        
        await _database.ref('users/${firebaseUser.uid}').set(newUser.toJson());
        _user = newUser;
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      _user = User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? firebaseUser.email?.split('@')[0] ?? 'User',
          email: firebaseUser.email ?? '',
          photoUrl: firebaseUser.photoURL ?? 'https://i.pravatar.cc/150?img=11',
      );
      notifyListeners();
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      fb_auth.UserCredential cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      if (cred.user != null) {
        await _fetchUserData(cred.user!);
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } on fb_auth.FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Login error: ${e.message}");
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Login error: $e");
      return false;
    }
  }

  // Google Sign In
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final fb_auth.AuthCredential credential = fb_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      fb_auth.UserCredential cred = await _auth.signInWithCredential(credential);
      
      if (cred.user != null) {
        await _fetchUserData(cred.user!);
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Google Sign-In error: $e");
      return false;
    }
  }

  // Signup
  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      fb_auth.UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      if (cred.user != null) {
        final newUser = User(
          id: cred.user!.uid,
          name: name,
          email: email,
          photoUrl: 'https://i.pravatar.cc/150?img=11',
        );

        await _database.ref('users/${cred.user!.uid}').set(newUser.toJson());
        
        _user = newUser;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      return false;
    } on fb_auth.FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Signup error: ${e.message}");
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Signup error: $e");
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await _auth.signOut();
    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  // Update user information
  Future<void> updateUserInfo(String name, String email, {String? phoneNumber}) async {
    if (_user != null) {
      try {
        final updatedUser = User(
          id: _user!.id,
          name: name,
          email: email,
          photoUrl: _user!.photoUrl,
          phoneNumber: phoneNumber ?? _user!.phoneNumber,
        );

        await _database.ref('users/${_user!.id}').update(updatedUser.toJson());
        _user = updatedUser;
        notifyListeners();
      } catch (e) {
        debugPrint("Error updating user info: $e");
      }
    }
  }

  // Update profile photo
  Future<void> updatePhotoUrl(String photoUrl) async {
    if (_user != null) {
      try {
        await _database.ref('users/${_user!.id}').update({'photoUrl': photoUrl});
        
        _user = User(
          id: _user!.id,
          name: _user!.name,
          email: _user!.email,
          photoUrl: photoUrl,
          phoneNumber: _user!.phoneNumber,
        );
        notifyListeners();
      } catch (e) {
        debugPrint("Error updating photo: $e");
      }
    }
  }

  // Change Password
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
      return false;
    } catch (e) {
      debugPrint("Error changing password: $e");
      return false;
    }
  }
}
