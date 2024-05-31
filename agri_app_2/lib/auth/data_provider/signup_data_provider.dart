import 'dart:convert';
import 'package:agri_app_2/auth/model/signup_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// Define the provider for the AuthRegDataProvider
final authRegDataProviderProvider =
    Provider<AuthRegDataProvider>((ref) => AuthRegDataProvider());

// Define the class for the AuthRegDataProvider
class AuthRegDataProvider {
  Future<Map<String, dynamic>> registerUser(SignupData user) async {
    try {
      final response = await http.post(
          Uri.parse('http://localhost:3000/auth/signUp'),
          body: json.encode(user.toJson()),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Registration failed with status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
