import 'package:agri_app_2/auth/data_provider/signin_data_provider.dart';
import 'package:agri_app_2/auth/model/auth_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final AuthDataProvider dataProvider;
  final SharedPreferences sharedPreferences;

  AuthRepository(this.dataProvider, this.sharedPreferences);

  Future<AuthLoginData> login(
    String email,
    String password,
    Role role,
  ) async {
    try {
      final LoginData data = await dataProvider.login(email, password, role);

      // Store the token and userId in SharedPreferences
      await sharedPreferences.setString('token', data.token);
      await sharedPreferences.setInt('userId', data.userId);

      // Create and return AuthLoginData
      return AuthLoginData(
        token: data.token,
        id: data.userId,
      );
    } catch (error) {
      // Consider adding more specific error handling here
      rethrow; // Rethrow the caught error
    }
  }

  void update(
      void Function(dynamic state)
          param0) {} // Update method with void return type
}

enum Role { FARMER, BUYER }

class LoginData {
  final String email;
  final String password;
  final Role role;
  final String token;
  final int userId;

  LoginData({
    required this.email,
    required this.password,
    required this.role,
    required this.token,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'role': role.toString().split('.').last, // Convert enum to string
    };
  }

  static LoginData fromJson(Map<String, dynamic> LoginDataJson) {
    return LoginData(
      email: LoginDataJson['email'],
      password: LoginDataJson['password'],
      role: LoginDataJson['role'] == 'FARMER' ? Role.FARMER : Role.BUYER,
      token: LoginDataJson['token'],
      userId: LoginDataJson['userId'],
    );
  }
}
