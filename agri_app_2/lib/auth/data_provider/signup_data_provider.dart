// signup_data_provider.dart
import 'package:agri_app_2/auth/provider/auth_event.dart';
import 'package:dio/dio.dart';
import 'package:agri_app_2/auth/model/signup_model.dart';
import 'dart:convert';

class AuthRegDataProvider {
  final Dio dio;

  AuthRegDataProvider(this.dio);

  Future<SignupData> registerUser(SignupEvent event) async {
    final response = await dio.post(
      'http://localhost:3000/auth/signUp',
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ),
      data: jsonEncode(event.toJson()),
    );

    if (response.statusCode == 200) {
      return SignupData.fromJson(response.data);
    } else {
      throw Exception('Failed to register user');
    }
  }
}
