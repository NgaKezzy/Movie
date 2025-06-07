import 'package:app/config/print_color.dart';
import 'package:app/feature/login/cubit/auth_state.dart';
import 'package:app/feature/login/models/user_info.dart';
import 'package:app/routers/router.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class AuthCubit extends HydratedCubit<AuthState> {
  AuthCubit() : super(AuthState());

  Future<void> login(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final user = await googleSignIn.signIn();
      if (user != null) {
        printCyan(user.toString());

        emit(state.copyWith(
          isLogin: true,
          userInfo: UserInfo(
            name: user.displayName.toString(),
            email: user.email.toString(),
            photoUrl: user.photoUrl.toString(),
            id: user.id.toString(),
            isPremium: false,
          ),
        ));
        context.go(AppRouteConstant.myHomeApp);

        // Thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập thành công: ${user.displayName}')),
        );
      } else {
        // Hủy đăng nhập
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hủy đăng nhập')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi đăng nhập: $error')),
      );
    }
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
