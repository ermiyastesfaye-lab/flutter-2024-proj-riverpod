import 'dart:convert';
import 'package:agri_app_2/auth/model/signin_model.dart';
import 'package:agri_app_2/presentation/screens/login.dart';
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
      context.go('/logIn');
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
    return await dataProvider.registerUser(event);
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

// Signup Widget
class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    final authRegNotifier = ref.watch(authRegProvider.notifier);
    final authState = ref.watch(authRegProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.green, // Adjust color as needed
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  items: ["FARMER", "BUYER"].map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "Role",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a role';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          // Create a SignupEvent object with the user's information
                          final signupEvent = SignupEvent(
                            email: emailController.text,
                            password: passwordController.text,
                            role: selectedRole == "FARMER"
                                ? Role.FARMER
                                : Role.BUYER,
                          );

                          // Trigger the registration process in the AuthRegNotifier
                          await authRegNotifier.register(signupEvent, context);

                          // Handle success or error based on authState
                          if (authState.status == AuthStatus.success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Signup successful!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else if (authState.status == AuthStatus.error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Signup failed: ${authState.error}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Signup failed: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Define GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SignUp(),
    ),
    GoRoute(
      path: '/logIn',
      builder: (context, state) =>
          const LoginPage(), // Replace with your login widget
    ),
  ],
);
