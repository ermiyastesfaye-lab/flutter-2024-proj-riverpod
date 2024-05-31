import 'package:equatable/equatable.dart';

// Define the base event class
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Define the signup event class
class SignupEvent extends AuthEvent {
  final String email;
  final String password;

  const SignupEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];

  // ignore: body_might_complete_normally_nullable
  Object? toJson() {}
}
