import 'dart:convert';


class UserModel {
  final String? userId;
  final String? name,
      password,
      email,
      userDeviceType,
      userDeviceId,
      userDeviceModel;

  UserModel(
      {this.userDeviceType,
      this.userDeviceId,
      this.userDeviceModel,
      this.userId,
      this.name,
      this.password,
      this.email});

  factory UserModel.fromjson(Map<String, dynamic> jsonData) => UserModel(
        userId: jsonData['userId'] ?? "",
        userDeviceType: jsonData['userDeviceType'] ?? "",
        userDeviceId: jsonData['userDeviceId'] ?? "",
        userDeviceModel: jsonData['userDeviceModel'] ?? "",
        password: jsonData['password'] ?? "",
        name: jsonData['name'] ?? "",
        email: jsonData['email'] ?? "",
      );

 static Map<String, dynamic> toMap(UserModel userModel) => {
        'userId': userModel.userId,
        'userDeviceType': userModel.userDeviceType,
        'userDeviceId': userModel.userDeviceId,
        'userDeviceModel': userModel.userDeviceModel,
        'name': userModel.name,
        'password': userModel.password,
        'email': userModel.email
      };

  UserModel copyWith({
    String? userId,
    String? userDeviceId,
    String? userDeviceType,
    String? userDeviceModel,
    String? name,
    String? password,
    String? email,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      userDeviceId: userDeviceId ?? this.userDeviceId,
      userDeviceType: userDeviceType ?? this.userDeviceType,
      userDeviceModel: userDeviceModel ?? this.userDeviceModel,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

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
