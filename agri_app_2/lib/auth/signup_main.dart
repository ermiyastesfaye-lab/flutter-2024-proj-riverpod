import 'package:agri_app_2/auth/data_provider/signup_data_provider.dart';
import 'package:agri_app_2/auth/login_main.dart';
import 'package:agri_app_2/auth/presentation/signup.dart';
import 'package:agri_app_2/auth/repository/signup_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyLogin()));
}

class MySignup extends StatelessWidget {
  const MySignup({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        authRegRepositoryProvider.overrideWithValue(
          AuthRegRepository(dataProvider: AuthRegDataProvider()),
        ),
      ],
      child: SignUp(),
    );
  }
}

// Define the repository provider
final authRegRepositoryProvider =
    Provider<AuthRegRepository>((ref) => throw UnimplementedError());
