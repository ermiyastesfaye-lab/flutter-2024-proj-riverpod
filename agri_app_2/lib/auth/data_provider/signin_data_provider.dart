import 'package:agri_app_2/auth/model/signin_model.dart';
import 'package:dio/dio.dart';

class AuthDataProvider {
  final Dio dio;

  AuthDataProvider(this.dio);

  Future<LoginData> login(String email, String password, Role role) async {
    try {
      final response = await dio.post(
        'http://localhost:3000/auth/signIn',
        data: {
          'email': email,
          'password': password,
          'role': role.toString().split('.').last,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final token = data['access_token'];
        final userId = data['userId'];
        final userRole = data['role'];

        if (token != null && userId != null && userRole != null) {
          return LoginData(
            token: token,
            userId: userId,
            email: email,
            password: password,
            role: Role.values.firstWhere(
              (element) => element.toString().split('.').last == userRole,
              orElse: () => Role.FARMER,
            ),
          );
        } else {
          throw Exception('Token, UserId, or Role is missing');
        }
      } else {
        final errorMessage = response.data['message'];
        throw Exception('Login failed: $errorMessage');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<LoginData> signUp(
      String email, String password, String confirmPassword, Role role) async {
    try {
      final response = await dio.post(
        'http://localhost:3000/auth/signUp',
        data: {
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'role': role.toString().split('.').last,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // Add any other required headers here
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final token = data['access_token'];
        final userId = data['userId'];
        final userRole = data['role'];

        if (token != null && userId != null && userRole != null) {
          return LoginData(
            token: token,
            userId: userId,
            email: email,
            password: password,
            role: Role.values.firstWhere(
              (element) => element.toString().split('.').last == userRole,
              orElse: () => Role.FARMER,
            ),
          );
        } else {
          throw Exception('Token, UserId, or Role is missing');
        }
      } else {
        final errorMessage = response.data['message'];
        throw Exception('Signup failed: $errorMessage');
      }
    } catch (error) {
      print('Signup error: $error'); // Log the error for debugging
      rethrow;
    }
  }
}
