import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/Auth/AuthModel/user_model.dart';

class UserRepository {
  Future<List<UserModel>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    List<UserModel> userData = [];

    final String? user = prefs.getString('userData');

    if (user != null) {
      userData = UserModel.decode(user);
      return userData;
    } else {
      throw Exception("Error fetching user");
    }
  }

  Future<List<UserModel>> getLoginUserDetail() async {
    final prefs = await SharedPreferences.getInstance();
    List<UserModel> loginData = [];

    final String? userLogin = prefs.getString('loginData');

    if (userLogin != null) {
      loginData = UserModel.decode(userLogin);
      return loginData;
    } else {
      throw Exception("Error fetching login user");
    }
  }
}