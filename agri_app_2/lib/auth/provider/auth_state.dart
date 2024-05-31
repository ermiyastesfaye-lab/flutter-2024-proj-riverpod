import 'package:agri_app_2/auth/model/signup_model.dart';
import 'package:equatable/equatable.dart';

// Define the base state class
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Define the initial state
class AuthInitial extends AuthState {}

// Define the loading state
class AuthLoading extends AuthState {}

// Define the authenticated state
class AuthAuthenticated extends AuthState {
  final SignupData user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

// Define the error state
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// Define the registration success state
class AuthRegistrationSuccess extends AuthState {
  const AuthRegistrationSuccess();

  @override
  List<Object?> get props => [];
}
