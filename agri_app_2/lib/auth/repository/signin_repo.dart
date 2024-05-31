import 'package:agri_app_2/auth/data_provider/signin_data_provider.dart';
import 'package:agri_app_2/auth/model/auth_model.dart';
import 'package:agri_app_2/auth/model/signin_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final AuthDataProvider dataProvider;
  final SharedPreferences sharedPreferences;

  AuthRepository(this.dataProvider, this.sharedPreferences);

  Future<AuthLoginData> login(String email, String password, Role role) async {
    try {
      final LoginData data = await dataProvider.login(email, password, role);

      await sharedPreferences.setString('token', data.token);
      await sharedPreferences.setInt('userId', data.userId);

      return AuthLoginData(
        token: data.token,
        id: data.userId,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<AuthLoginData> signUp(
      String email, String password, String confirmPassword, Role role) async {
    try {
      final LoginData data =
          await dataProvider.signUp(email, password, confirmPassword, role);

      await sharedPreferences.setString('token', data.token);
      await sharedPreferences.setInt('userId', data.userId);

      return AuthLoginData(
        token: data.token,
        id: data.userId,
      );
    } catch (error) {
      rethrow;
    }
  }
}
