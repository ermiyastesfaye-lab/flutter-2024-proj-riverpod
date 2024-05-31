import 'package:agri_app_2/auth/model/auth_model.dart';
import 'package:equatable/equatable.dart';

// Define the base state class
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];

  get selectedRole => null;
}

// Define the initial state
class LoginInitial extends LoginState {}

// Define the loading state
class LoginLoading extends LoginState {}

// Define the success state
class LoginSuccess extends LoginState {
  final AuthLoginData data;

  const LoginSuccess(this.data, {required token, required userId});

  @override
  List<Object?> get props => [data];
}

// Define the error state
class LoginError extends LoginState {
  final String errorMessage;

  const LoginError(
    this.errorMessage,
  );

  @override
  List<Object?> get props => [errorMessage];
}
