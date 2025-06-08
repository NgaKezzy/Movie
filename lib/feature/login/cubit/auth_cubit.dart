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

  Future<void> login(BuildContext context, String titleSuccess, String titleCancel,) async {
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
          diamond: 100,
        );

        // Không cần gọi initializeDb nữa
        await addUserInfo(userInfo);

        emit(state.copyWith(isLogin: true, userInfo: userInfo));
        context.go(AppRouteConstant.myHomeApp);

        // Thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${titleSuccess}: ${user.displayName}')),
        );
      } else {
        // Hủy đăng nhập
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(titleCancel)),
        );
      }
    } catch (error) {
      printRed(error.toString());
    }
  }

  Future<void> logout(BuildContext context, String titleError) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signOut();
      emit(state.copyWith(isLogin: false, userInfo: null));
      context.go(AppRouteConstant.login);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${titleError}: $error')),
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

  Future<void> registerPremium(int day, int price) async {
    UserInfo user = state.userInfo!;

    // Kiểm tra xem người dùng đã có gói premium chưa
    if (user.isPremium && user.premiumTerm != null) {
      // Nếu đã có premium, cộng thêm ngày vào thời hạn hiện tại
      user.premiumTerm = user.premiumTerm!.add(Duration(days: day));
    } else {
      // Nếu chưa có premium, đặt thời hạn mới từ ngày hiện tại
      user.isPremium = true;
      user.premiumTerm = DateTime.now().add(Duration(days: day));
    }

    // Trừ kim cương
    user.diamond = state.userInfo!.diamond - price;

    try {
      // Sử dụng getter db thay vì FirebaseDatabase.instance
      if (Firebase.apps.isEmpty) return;

      // Lấy tham chiếu đến danh sách users
      final usersRef = db.ref("users");

      // Tìm user hiện tại trong database
      final snapshot = await usersRef.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        // Tìm key của user hiện tại
        String? userKey;
        for (final entry in data.entries) {
          final userData = entry.value;
          if (userData['id'] == user.id) {
            userKey = entry.key;
            break;
          }
        }

        // Nếu tìm thấy user, cập nhật thông tin
        if (userKey != null) {
          final userRef = db.ref("users/$userKey");
          await userRef.update(user.toJson());
          emit(state.copyWith(userInfo: user));
          print('User updated successfully');
        } else {
          print('User not found in database');
        }
      }
    } catch (e) {
      printRed(e.toString());
    }
  }

  Future<void> checkPremium() async {
    UserInfo user = state.userInfo!;
    if (user.isPremium && user.premiumTerm != null) {
      if (user.premiumTerm!.isBefore(DateTime.now())) {
        user.isPremium = false;
        user.premiumTerm = null;
        emit(state.copyWith(userInfo: user));
      }
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
