// signup_repo.dart
import 'package:agri_app_2/auth/presentation/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:agri_app_2/auth/model/signup_model.dart';

class AuthRegRepository {
  final AuthRegDataProvider dataProvider;
  final SharedPreferences sharedPreferences;

  AuthRegRepository(this.dataProvider, this.sharedPreferences);

  Future<SignupData> registerUser(SignupEvent event) async {
    return await dataProvider.registerUser(event);
  }
}
