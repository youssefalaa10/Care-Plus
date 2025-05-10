import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:careplus/Features/Auth/Data/Model/user_model.dart';

import '../../../../Core/service/shared_prefs_service.dart';

class AuthRepo {
  final FirebaseAuth _firebaseAuth;
  final SharedPrefsService _sharedPrefsService;

  AuthRepo({
    FirebaseAuth? firebaseAuth,
    required SharedPrefsService sharedPrefsService,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _sharedPrefsService = sharedPrefsService;
  final _firestore = FirebaseFirestore.instance;

  Future<UserModel?> get currentUser async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists || doc.data() == null) return null;

      return UserModel.fromJson(doc.data()!);
    } catch (e, stacktrace) {
      print('Error fetching current user: $e\n$stacktrace');
      return null;
    }
  }

  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (!doc.exists || doc.data() == null) return null;

        return UserModel.fromJson(doc.data()!);
      } catch (e, stacktrace) {
        print('Error in authStateChanges stream: $e\n$stacktrace');
        return null;
      }
    });
  }

  Future<UserModel?> getUserFromPrefs() async {
    return _sharedPrefsService.getUserData();
  }

  Future<void> saveUserToPrefs(UserModel user) async {
    await _sharedPrefsService.saveUserData(user);

    if (_firebaseAuth.currentUser != null) {
      final idToken = await _firebaseAuth.currentUser!.getIdToken();
      await _sharedPrefsService.saveAuthToken(idToken!);
    }
  }

  Future<void> clearUserFromPrefs() async {
    await _sharedPrefsService.clearSession();
  }

  bool isLoggedIn() {
    return _sharedPrefsService.isLoggedIn();
  }

  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('User not found');
      }

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        throw Exception('User profile not found in Firestore');
      }

      final userModel = UserModel.fromJson(doc.data()!);

      await saveUserToPrefs(userModel);

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Failed to create user');
      }

      await user.updateDisplayName(name);

      final newUser = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        name: name,
        phoneNumber: user.phoneNumber,
        photoUrl: user.photoURL,
        appointments: [],
      );

      await _firestore.collection('users').doc(user.uid).set(newUser.toJson());

      return newUser;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  Future<void> signOut() async {
    await clearUserFromPrefs();
    await _firebaseAuth.signOut();
  }

  Exception _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found with this email');
      case 'wrong-password':
        return Exception('Wrong password');
      case 'email-already-in-use':
        return Exception('Email is already in use');
      case 'weak-password':
        return Exception('The password is too weak');
      case 'invalid-email':
        return Exception('Invalid email address');
      default:
        return Exception('Authentication failed: ${e.message}');
    }
  }
}
