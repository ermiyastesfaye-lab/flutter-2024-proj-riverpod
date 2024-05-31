// ignore_for_file: constant_identifier_names
import 'package:agri_app_2/auth/model/role.dart';
import 'package:agri_app_2/auth/data_provider/signin_data_provider.dart';
import 'package:agri_app_2/auth/repository/signin_repo.dart';
import 'package:agri_app_2/presentation/data/dummy_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define Role enum
enum Role { Admin, User, Guest }

// Define the states
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  final String errorMessage;

  LoginError(this.errorMessage);
}

// Define the notifier
class LoginNotifier extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;
  final SharedPreferences _sharedPreferences;

  LoginNotifier(this._authRepository, this._sharedPreferences)
      : super(LoginInitial());

  Future<void> login(String email, String password, Role? role) async {
    if (email.isEmpty || password.isEmpty || role == null) {
      state = LoginError('Please fill all the fields');
      return;
    }
    state = LoginLoading();
    try {
      final user = await _authRepository.login(email, password, role);
      await _sharedPreferences.setString('token', user.token);
      await _sharedPreferences.setInt('userId', user.id);
      state = LoginSuccess();
    } catch (e) {
      state = LoginError(e.toString());
    }
  }
}

class SignInData {
  final String email;
  final String password;
  final Role role;

  SignInData({
    required this.email,
    required this.password,
    required this.role,
  });
}

// Provider for the repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = Dio();
  final sharedPreferences = ref.read(sharedPreferencesProvider).value;
  final authDataProvider = AuthDataProvider(dio);
  return AuthRepository(authDataProvider, sharedPreferences!);
});

// Provider for shared preferences
final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

// Provider for the login notifier
final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final sharedPreferences = ref.watch(sharedPreferencesProvider).when(
        data: (value) => value,
        loading: () => null,
        error: (e, _) => throw Exception("SharedPreferences error"),
      );

  return LoginNotifier(authRepository, sharedPreferences!);
});

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    final sharedPreferencesAsyncValue = ref.watch(sharedPreferencesProvider);

    return sharedPreferencesAsyncValue.when(
      data: (sharedPreferences) {
        return Scaffold(
          body: loginState is LoginLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: myColor.secondary,
                            ),
                          ),
                        ),
                        Text(
                          "Welcome back you've been missed!",
                          style:
                              TextStyle(fontSize: 18, color: myColor.tertiary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 80),
                        _inputField("Email", _emailController, (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        }),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          child: DropdownButtonFormField<Role>(
                            items: Role.values.map((Role role) {
                              return DropdownMenuItem<Role>(
                                value: role,
                                child: Text(role.toString().split('.').last),
                              );
                            }).toList(),
                            onChanged: (Role? newRole) {
                              ref.read(selectedRoleProvider.notifier).state =
                                  newRole;
                            },
                            decoration: InputDecoration(
                              labelText: "Role",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _inputField("Password", _passwordController, (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        }, isPassword: true),
                        const SizedBox(height: 20),
                        Center(
                          child: SizedBox(
                            width: 370,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                final selectedRole =
                                    ref.read(selectedRoleProvider);
                                if (selectedRole != null) {
                                  ref.read(loginProvider.notifier).login(
                                        _emailController.text,
                                        _passwordController.text,
                                        selectedRole,
                                      );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please select a role'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: myColor.secondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/signUp');
                            },
                            child: Text("Don't have an account? Sign up",
                                style: TextStyle(
                                    fontSize: 18, color: myColor.tertiary)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }

  Widget _inputField(
    String label,
    TextEditingController controller,
    String? Function(String?) validator, {
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      validator: validator,
    );
  }
}

final selectedRoleProvider = StateProvider<Role?>((ref) => null);

// AuthLoginData class with the fix
class AuthLoginData {
  final String token;
  final int id;

  const AuthLoginData({required this.token, required this.id});
}
