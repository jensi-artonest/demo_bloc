import 'package:bloc/bloc.dart';
import 'package:untitled3/Auth/HomeSection/home_event.dart';

import 'home_state.dart';
import 'user_repo.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc(this._userRepository) : super(UserLoadingState()) {
    on<LoadUserEvent>(_getUserData);
  }

  Future<void> _getUserData(event, emit) async {
    emit(UserLoadingState());

    try {
      final users = await _userRepository.getUsers();
      final loginUser = await _userRepository.getLoginUserDetail();
      emit(UserLoadedState(userData: users, userLogin: loginUser));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }
}