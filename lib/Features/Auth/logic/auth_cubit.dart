import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:careplus/Features/Auth/Data/Repo/auth_repo.dart';
import 'package:careplus/Features/Auth/logic/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;
  StreamSubscription? _authStateSubscription;

  AuthCubit({required AuthRepo authRepo})
      : _authRepo = authRepo,
        super(AuthState.initial()) {
    // Listen to auth state changes
    _authStateSubscription = _authRepo.authStateChanges.listen(
      (user) {
        if (user != null) {
         if(!isClosed) emit(AuthState.authenticated(user));
        } else {
         if(!isClosed) emit(AuthState.unauthenticated());
        }
      },
      onError: (error) {
       if(!isClosed) emit(AuthState.error(error.toString()));
      },
    );
  }

  // Check current authentication status
  void checkAuthStatus() {
    final user = _authRepo.currentUser;
    if (user != null) {
     if(!isClosed) emit(AuthState.authenticated(user));
    } else {
     if(!isClosed) emit(AuthState.unauthenticated());
    }
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
     if(!isClosed) emit(AuthState.loading());
      final user = await _authRepo.signInWithEmailAndPassword(email, password);
     if(!isClosed) emit(AuthState.authenticated(user));
    } catch (e) {
     if(!isClosed) emit(AuthState.error(e.toString()));
    }
  }

  // Register with email and password
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
     if(!isClosed) emit(AuthState.loading());
      final user = await _authRepo.registerWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );
     if(!isClosed) emit(AuthState.authenticated(user));
    } catch (e) {
     if(!isClosed) emit(AuthState.error(e.toString()));
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
     if(!isClosed) emit(AuthState.loading());
      await _authRepo.signOut();
     if(!isClosed) emit(AuthState.unauthenticated());
    } catch (e) {
     if(!isClosed) emit(AuthState.error(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
