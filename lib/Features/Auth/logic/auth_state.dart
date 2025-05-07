import 'package:equatable/equatable.dart';
import 'package:carepulse/Features/Auth/Data/Model/user_model.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error, registered }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  // Initial state
  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);

  // Loading state
  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);

  // Authenticated state
  factory AuthState.authenticated(UserModel user) => AuthState(
        status: AuthStatus.authenticated,
        user: user,
      );

  // Unauthenticated state
  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);

  // Error state
  factory AuthState.error(String message) => AuthState(
        status: AuthStatus.error,
        errorMessage: message,
      );

  // Copy with method
  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
