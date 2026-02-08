import 'package:movie/common/domain/entities/response/user_data.dart';
import 'package:movie/features/auth/cubit/auth_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class AuthCubit extends HydratedCubit<AuthState> {
  AuthCubit() : super(AuthState());

  Future<bool> register(UserData user) async {
    for (var element in state.users) {
      if (user.username == element.username) {
        return false;
      }
    }
    List<UserData> newUsers = List.from(state.users);
    newUsers.add(user);
    emit(state.copyWith(users: newUsers));
    return true;
  }

  Future<bool> login(String username, String pass) async {
    for (var element in state.users) {
      if (username == element.username && pass == element.pass) {
        emit(state.copyWith(user: element));
        return true;
      }
    }
    return false;
  }

  Future<void> setIsLogin(bool value) async {
    emit(state.copyWith(isLogin: value));
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      return AuthState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    try {
      return state.toJson();
    } catch (_) {
      return null;
    }
  }
}
