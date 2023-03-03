import 'package:equatable/equatable.dart';
import 'package:untitled3/Auth/AuthModel/user_model.dart';

abstract class UserState extends Equatable {}

class UserLoadingState extends UserState {
  @override
  List<Object> get props => [];
}
class UserLoadedState extends UserState {
  UserLoadedState({this.userLogin = const [], this.userData = const []});

  final List<UserModel> userData;
  final List<UserModel> userLogin;

  @override
  List<Object> get props => [userData, userLogin];
}

class UserErrorState extends UserState {
  final String error;

  UserErrorState(this.error);

  @override
  List<Object> get props => [error];
}