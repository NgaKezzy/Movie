import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:movie/common/widgets/text_field/default_textfield.dart';
import 'package:movie/core/di/di.dart';
import 'package:movie/routers/app_router.dart';
import 'package:movie/core/text_style/app_text_style.dart';
import 'package:movie/features/auth/cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isHidePassWord = true;
  bool isErrorUsername = false;
  bool isErrorPass = false;
  final AuthCubit authCubit = getIt.get();
  final loginKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  void validateForm() {
    setState(() {
      isErrorUsername = _usernameController.text.trim().isEmpty;
      isErrorPass = _passwordController.text.trim().isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(20.h),

                Gap(40.h),

                Gap(16.h),
                Text(
                  'Chào bạn 👋',
                  style: AppTextStyles.textStyle20.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gap(8.h),
                Text(
                  'Chào mừng trở lại, hãy đăng nhập vào tài khoản của bạn.',
                  style: AppTextStyles.textStyle14,
                ),
                Gap(30.h),
                AppTextField(
                  controller: _usernameController,
                  isError: isErrorUsername,
                  heightContainer: 56,
                  fillColor: Colors.transparent,
                  filled: true,
                  textInputAction: TextInputAction.next,
                  maxLines: 1,
                  borderRadius: 16,
                  hintText: 'Tài khoản',
                  errorText: 'Vui lòng nhập tài khoản',
                ),
                Gap(16.h),
                AppTextField(
                  controller: _passwordController,
                  isError: isErrorPass,
                  heightContainer: 56,
                  fillColor: Colors.transparent,
                  filled: true,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  borderRadius: 16,
                  maxLines: 1,
                  hintText: 'Mật khẩu',
                  errorText: 'Vui lòng nhập mật khẩu',
                ),
                Gap(24.h),
                SizedBox(
                  width: ScreenUtil().screenWidth,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      validateForm();
                      if (!isErrorUsername && !isErrorPass) {
                        final bool response = await authCubit.login(
                          _usernameController.text.trim(),
                          _passwordController.text.trim(),
                        );
                        if (response) {
                          authCubit.setIsLogin(true);
                          context.go(RouteName.myHomePage);
                        } else {
                          showOkAlertDialog(
                            context: context,
                            title: 'Thất bại',
                            message: 'Tài khoản hoặc mật khẩu không chính xác!',
                            onPopInvokedWithResult: (didPop, result) {},
                          );
                        }
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        theme.colorScheme.primary,
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                    ),
                    child: Text(
                      'Đăng nhập',
                      style: AppTextStyles.textStyle14.copyWith(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Gap(24.h),

                Gap(50.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bạn chưa có tài khoản?',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push(RouteName.register);
                      },
                      child: Text(
                        ' Đăng ký',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập dữ liệu';
    }

    return null;
  }
}
