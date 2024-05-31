// login_main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:agri_app_2/auth/data_provider/signin_data_provider.dart';
import 'package:agri_app_2/auth/repository/signin_repo.dart';
import 'package:agri_app_2/presentation/screens/login.dart';

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
      child: const MyLogin(),
    ),
  );
}

class MyLogin extends StatelessWidget {
  const MyLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const LoginPage(),
    );
  }
}

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => throw UnimplementedError());
