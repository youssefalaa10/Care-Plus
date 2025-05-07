import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carepulse/Features/Auth/Data/Model/user_model.dart';

class AuthRepo {
  final FirebaseAuth _firebaseAuth;

  AuthRepo({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // Get current user
  UserModel? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName,
      phoneNumber: user.phoneNumber,
      photoUrl: user.photoURL,
    );
  }

  // Stream of authentication state changes
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;

      return UserModel(
        uid: user.uid,
        email: user.email ?? '',
        name: user.displayName,
        phoneNumber: user.phoneNumber,
        photoUrl: user.photoURL,
      );
    });
  }

  // Sign in with email and password
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

      return UserModel(
        uid: user.uid,
        email: user.email ?? '',
        name: user.displayName,
        phoneNumber: user.phoneNumber,
        photoUrl: user.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  // Register with email and password
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

      // Update user profile with name
      await user.updateDisplayName(name);

      // Create user document in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'name': name,
        'phoneNumber': user.phoneNumber,
        'photoUrl': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return UserModel(
        uid: user.uid,
        email: user.email ?? '',
        name: name,
        phoneNumber: user.phoneNumber,
        photoUrl: user.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Handle Firebase Auth exceptions
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
