import 'dart:convert';
import 'package:agri_app_2/auth/model/signin_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:agri_app_2/auth/model/signup_model.dart';

// Define the event class
class SignupEvent {
  final String email;
  final String password;
  final Role role;

  SignupEvent({
    required this.email,
    required this.password,
    required this.role,
  });

  // Convert SignupEvent to JSON format
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'role': role.toString(),
    };
  }
}

// Define the state class
enum AuthStatus { initial, loading, authenticated, error, success }

class AuthState {
  final AuthStatus status;
  final String? error;
  final SignupData? registeredUser;
  final String? successMessage;

  AuthState({
    required this.status,
    this.error,
    this.registeredUser,
    this.successMessage,
  });
}

// Provider for managing registration state
final authRegProvider = StateNotifierProvider<AuthRegNotifier, AuthState>(
  (ref) => AuthRegNotifier(ref.read(authRegRepositoryProvider)),
);

// Notifier class for registration
class AuthRegNotifier extends StateNotifier<AuthState> {
  final AuthRegRepository _authRepository;

  AuthRegNotifier(this._authRepository)
      : super(AuthState(status: AuthStatus.initial));

  Future<void> register(SignupEvent event, BuildContext context) async {
    state = AuthState(status: AuthStatus.loading);
    try {
      final registeredUser = await _authRepository.registerUser(event);
      state = AuthState(
        status: AuthStatus.success,
        registeredUser: registeredUser,
        successMessage: "Registration successful!",
      );
      // Navigate to login page after successful registration
      context.go('/login');
    } catch (error) {
      state = AuthState(
        status: AuthStatus.error,
        error: error.toString(),
      );
    }
  }
}

// Provider for AuthRegRepository
final authRegRepositoryProvider = Provider<AuthRegRepository>((ref) =>
    AuthRegRepository(dataProvider: ref.read(authRegDataProviderProvider)));

// Class handling the registration API calls
class AuthRegRepository {
  final AuthRegDataProvider dataProvider;

  AuthRegRepository({required this.dataProvider});

  Future<SignupData> registerUser(SignupEvent event) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/auth/signUp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(event.toJson()),
    );

    if (response.statusCode == 200) {
      return SignupData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register user');
    }
  }
}

// Provider for AuthRegDataProvider
final authRegDataProviderProvider =
    Provider<AuthRegDataProvider>((ref) => AuthRegDataProvider());

// Class handling the registration API calls
class AuthRegDataProvider {
  Future<SignupData> registerUser(SignupEvent event) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/auth/signUp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(event.toJson()),
    );

    if (response.statusCode == 200) {
      return SignupData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register user');
    }
  }
}
