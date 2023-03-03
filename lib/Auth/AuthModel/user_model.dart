import 'dart:convert';

class UserModel {
  final String? userId;
  final String? name, password, email;

  UserModel({this.userId, this.name, this.password, this.email});

  factory UserModel.fromjson(Map<String, dynamic> jsonData) {
    return UserModel(
        password: jsonData['password'],
        name: jsonData['name'],
        email: jsonData['email'],
        userId: jsonData['userId']);
  }

  static Map<String, dynamic> toMap(UserModel userModel) => {
        'userId': userModel.userId,
        'name': userModel.name,
        'password': userModel.password,
        'email': userModel.email
      };

  static String encode(List<UserModel> userModel) => json.encode(
        userModel
            .map<Map<String, dynamic>>((user) => UserModel.toMap(user))
            .toList(),
      );

  static List<UserModel> decode(String userModel) =>
      (json.decode(userModel) as List<dynamic>)
          .map<UserModel>((item) => UserModel.fromjson(item))
          .toList();
}
