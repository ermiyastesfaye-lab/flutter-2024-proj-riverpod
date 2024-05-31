import 'package:agri_app_2/auth/data_provider/signin_data_provider.dart';
import 'package:agri_app_2/auth/model/auth_model.dart';
import 'package:agri_app_2/auth/model/signin_model.dart';
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
      final data = await dataProvider.login(email, password, role);
      final token = data['token'];
      final userId = data['userId'];

      await sharedPreferences.setString('token', token);
      await sharedPreferences.setInt('userId', userId);

      return AuthLoginData(
        token: token,
        id: userId,
      );
    } catch (error) {
      rethrow;
    }
  }

  void update(AuthRepository Function(dynamic state) param0) {}
}
