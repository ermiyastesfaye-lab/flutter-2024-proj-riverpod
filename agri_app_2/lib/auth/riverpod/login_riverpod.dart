import 'package:agri_app_2/auth/data_provider/signin_data_provider.dart';
import 'package:agri_app_2/auth/model/signin_model.dart';
import 'package:agri_app_2/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the event classes
class LoginRequested {
  final String email;
  final String password;
  final Role role;

  LoginRequested(
      {required this.email, required this.password, required this.role});
}

// Define the state classes
enum LoginStatus { initial, loading, success, error }

class LoginState {
  final LoginStatus status;
  final String? error;
  final SigninData? data;

  LoginState({
    required this.status,
    this.error,
    this.data,
  });
}

// Define the provider
final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(ref.watch(authRepositoryProvider)),
);

// Define the notifier class
class LoginNotifier extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;

  LoginNotifier(this._authRepository)
      : super(LoginState(status: LoginStatus.initial));

  Future<void> login(LoginRequested event) async {
    state = LoginState(status: LoginStatus.loading);
    try {
      final loginData = await _authRepository.login(
        event.email,
        event.password,
        event.role,
      );
      state = LoginState(status: LoginStatus.success, data: loginData);
    } catch (error) {
      state = LoginState(status: LoginStatus.error, error: error.toString());
    }
  }
}

// Define the repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataProvider = ref.watch(authDataProviderProvider);
  return AuthRepository(dataProvider: dataProvider);
});

class AuthRepository {
  final AuthDataProvider _dataProvider;

  AuthRepository({required AuthDataProvider dataProvider})
      : _dataProvider = dataProvider;

  Future<SigninData> login(String email, String password, Role role) async {
    try {
      final response = await _dataProvider.login(email, password, role);
      // Assuming the response contains the login data
      return SigninData.fromJson(response);
    } catch (error) {
      rethrow;
    }
  }
}

class SigninData {
  final String token;
  final int userId;

  SigninData({required this.token, required this.userId});

  factory SigninData.fromJson(Map<String, dynamic> json) {
    return SigninData(
      token: json['token'],
      userId: json['userId'],
    );
  }
}
