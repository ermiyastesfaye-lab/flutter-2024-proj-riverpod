import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:agri_app_2/auth/data_provider/signin_data_provider.dart';
import 'package:agri_app_2/auth/repository/signin_repo.dart';
import 'package:agri_app_2/presentation/screens/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          AuthRepository(
            AuthDataProvider(Dio()),
            sharedPreferences,
          ),
        ),
      ],
      child: const MySignup(),
    ),
  );
}

class MySignup extends StatelessWidget {
  const MySignup({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SignUp(),
    );
  }
}

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => throw UnimplementedError());
