import 'package:agri_app_2/auth/model/signin_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/login_main.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  Role _selectedRole = Role.FARMER; // Default role is FARMER

  Future<void> _signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signUp(
          email, password, confirmPassword, _selectedRole);
      Navigator.pushReplacementNamed(context, '/logIn');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up failed: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            DropdownButton<Role>(
              value: _selectedRole,
              onChanged: (Role? newValue) {
                setState(() {
                  _selectedRole = newValue!;
                });
              },
              items: Role.values.map<DropdownMenuItem<Role>>((Role role) {
                return DropdownMenuItem<Role>(
                  value: role,
                  child: Text(role.toString().split('.').last),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _signUp,
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
