import 'package:agri_app_2/auth/model/auth_model.dart';
import 'package:agri_app_2/auth/model/signin_model.dart';
import 'package:equatable/equatable.dart';

// Define the base event class
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

// Define the login requested event class
class LoginRequested extends LoginEvent {
  final String email;
  final String password;
  final Role role;

  const LoginRequested(
      {required this.email, required this.password, required this.role});

  @override
  List<Object?> get props => [email, password, role];
}

// Define the farmer login requested event class
class FarmerLoginRequested extends LoginEvent {
  final String email;
  final String password;
  final Role role;

  const FarmerLoginRequested(
      {required this.email, required this.password, required this.role});

  @override
  List<Object?> get props => [email, password, role];
}

// Define the login response received event class
class LoginResponseReceived extends LoginEvent {
  final bool success;
  final String? message;
  final AuthLoginData? data;

  const LoginResponseReceived(this.success, this.message, this.data);

  @override
  List<Object?> get props => [success, message, data];
}
