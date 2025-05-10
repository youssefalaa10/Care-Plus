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
    _authStateSubscription = _authRepo.authStateChanges.listen(
      (user) {
        if (isClosed) return;
        emit(user != null ? AuthState.authenticated(user) : AuthState.unauthenticated());
      },
      onError: (error) {
        if (isClosed) return;
        emit(AuthState.error(error.toString()));
      },
    );
  }

  Future<void> checkAuthStatus() async {
    try {
      final prefsUser = await _authRepo.getUserFromPrefs();
      if (prefsUser != null && !isClosed) {
        emit(AuthState.authenticated(prefsUser));
      }
      
      final user = await _authRepo.currentUser;
      if (isClosed) return;
      
      if (user != null) {
        await _authRepo.saveUserToPrefs(user);
        emit(AuthState.authenticated(user));
      } else {
        emit(AuthState.unauthenticated());
      }
    } catch (e, stacktrace) {
      if (isClosed) return;
      emit(AuthState.error(e.toString()));
      print('Error in checkAuthStatus: $e\n$stacktrace');
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      if (isClosed) return;
      emit(AuthState.loading());
      final user = await _authRepo.signInWithEmailAndPassword(email, password);
      if (isClosed) return;
      emit(AuthState.authenticated(user));
    } catch (e, stacktrace) {
      if (isClosed) return;
      emit(AuthState.error(e.toString()));
      print('Error in signInWithEmailAndPassword: $e\n$stacktrace');
    }
  }

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      if (isClosed) return;
      emit(AuthState.loading());
      final user = await _authRepo.registerWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );
      await _authRepo.saveUserToPrefs(user);
      if (isClosed) return;
      emit(AuthState.authenticated(user));
    } catch (e, stacktrace) {
      if (isClosed) return;
      emit(AuthState.error(e.toString()));
      print('Error in registerWithEmailAndPassword: $e\n$stacktrace');
    }
  }

  Future<void> signOut() async {
    try {
      if (isClosed) return;
      emit(AuthState.loading());
      await _authRepo.signOut();
      if (isClosed) return;
      emit(AuthState.unauthenticated());
    } catch (e, stacktrace) {
      if (isClosed) return;
      emit(AuthState.error(e.toString()));
      print('Error in signOut: $e\n$stacktrace');
    }
  }

  @override
  Future<void> close() async {
    await _authStateSubscription?.cancel();
    return super.close();
  }
}