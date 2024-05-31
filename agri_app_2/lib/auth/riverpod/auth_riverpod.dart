import 'package:agri_app_2/auth/data_provider/signin_data_provider.dart';
import 'package:agri_app_2/auth/model/signup_model.dart';
import 'package:agri_app_2/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the event class
class SignupEvent {
  final String email;
  final String password;
  final role;

  SignupEvent(
      {required this.email, required this.password, required this.role});
}

// Define the state class
enum AuthStatus { initial, loading, authenticated, error }

class AuthState {
  final AuthStatus status;
  final String? error;
  final SignupData? registeredUser;

  AuthState({
    required this.status,
    this.error,
    this.registeredUser,
  });
}

// Define the provider
final authRegProvider = StateNotifierProvider<AuthRegNotifier, AuthState>(
  (ref) => AuthRegNotifier(ref.watch(authRegRepositoryProvider)),
);

// Define the notifier class
class AuthRegNotifier extends StateNotifier<AuthState> {
  final AuthRegRepository _authRepository;

  AuthRegNotifier(this._authRepository)
      : super(AuthState(status: AuthStatus.initial));

  Future<void> register(SignupEvent event) async {
    state = AuthState(status: AuthStatus.loading);
    try {
      final registeredUser = await _authRepository.register(SignupData(
        email: event.email,
        password: event.password,
        role: event.role,
      ));
      state = AuthState(
          status: AuthStatus.authenticated, registeredUser: registeredUser);
    } catch (error) {
      state = AuthState(status: AuthStatus.error, error: error.toString());
    }
  }
}

// Define the repository provider
final authRegRepositoryProvider = Provider<AuthRegRepository>((ref) {
  final dataProvider = ref.watch(authDataProviderProvider);
  return AuthRegRepository(dataProvider: dataProvider);
});

class AuthRegRepository {
  final AuthDataProvider _dataProvider;

  AuthRegRepository({required AuthDataProvider dataProvider})
      : _dataProvider = dataProvider;

  Future<SignupData> register(SignupData signupData) async {
    try {
      final response = await _dataProvider.register(
          signupData.email, signupData.password, signupData.role);
      // Assuming the response contains the registered user data
      return SignupData.fromJson(response);
    } catch (error) {
      rethrow;
    }
  }
}
