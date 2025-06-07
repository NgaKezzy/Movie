import 'package:app/config/print_color.dart';
import 'package:app/feature/login/cubit/auth_state.dart';
import 'package:app/feature/login/models/user_info.dart';
import 'package:app/routers/router.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class AuthCubit extends HydratedCubit<AuthState> {
  AuthCubit() : super(AuthState());

  // Thay đổi từ late final thành nullable
  FirebaseDatabase? _db;

  // Khởi tạo db khi cần sử dụng
  FirebaseDatabase get db {
    if (_db == null) {
      if (Firebase.apps.isNotEmpty) {
        _db = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              'https://my-film-af367-default-rtdb.asia-southeast1.firebasedatabase.app',
        );
      }
    }
    return _db!;
  }

  Future<void> login(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final user = await googleSignIn.signIn();
      if (user != null) {
        final UserInfo userInfo = UserInfo(
          name: user.displayName.toString(),
          email: user.email.toString(),
          photoUrl: user.photoUrl.toString(),
          id: user.id.toString(),
          isPremium: false,
          diamond: 1000,
        );

        // Không cần gọi initializeDb nữa
        await addUserInfo(userInfo);

        emit(state.copyWith(isLogin: true, userInfo: userInfo));
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
      printRed(error.toString());
    }
  }

  Future<void> logout(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signOut();
      emit(state.copyWith(isLogin: false, userInfo: null));
      context.go(AppRouteConstant.login);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi đăng xuất: $error')),
      );
    }
  }

  Future<void> addUserInfo(UserInfo userInfo) async {
    try {
      // Sử dụng getter db thay vì FirebaseDatabase.instance
      if (Firebase.apps.isEmpty) return;

      final ref = db.ref("users");

      // 1. Lấy dữ liệu hiện tại
      final snapshot = await ref.get();

      bool userExists = false;

      // 2. Duyệt qua danh sách user hiện có
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        for (final entry in data.entries) {
          final user = entry.value;
          if (user['id'] == userInfo.id) {
            userExists = true;
            break;
          }
        }
      }

      // 3. Nếu chưa có user thì thêm
      if (!userExists) {
        await ref.push().set(userInfo.toJson());
        print('User added');
      } else {
        print('User already exists');
      }
    } catch (e) {
      printRed(e.toString());
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
