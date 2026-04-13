import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:movie/common/domain/entities/response/user_data.dart';
import 'package:movie/common/widgets/text_field/default_textfield.dart';
import 'package:movie/core/colors/app_colors.dart';
import 'package:movie/core/di/di.dart';
import 'package:movie/routers/app_router.dart';
import 'package:movie/features/auth/cubit/auth_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final registerKey = GlobalKey<FormState>();
  bool isErrorName = false;
  bool isErrorUsername = false;
  bool isErrorEmail = false;
  bool isErrorPass = false;

  final AuthCubit authCubit = getIt.get();

  void validateForm() {
    setState(() {
      isErrorUsername = _usernameController.text.trim().isEmpty;
      isErrorPass = _passwordController.text.trim().isEmpty;
      isErrorName = _nameController.text.trim().isEmpty;
      isErrorEmail = _emailController.text.trim().isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().screenHeight,
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20.h),
              IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
              Gap(40.h),

              Text(
                'AlphaFin',
                style: textStyle.bodyLarge?.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gap(8.h),
              Text(
                'Bắt đầu hành trình đầu tư của bạn chỉ với một \$. ',
                style: textStyle.bodyLarge?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
              ),
              Gap(30.h),
              AppTextField(
                controller: _nameController,
                isError: isErrorName,
                heightContainer: 56,
                fillColor: Colors.transparent,
                textInputAction: TextInputAction.next,

                filled: true,
                maxLines: 1,
                borderRadius: 16,
                hintText: 'Họ và tên',
                errorText: 'Vui lòng nhập họ và tên',
              ),
              Gap(16.h),
              AppTextField(
                controller: _usernameController,
                isError: isErrorUsername,
                heightContainer: 56,
                fillColor: Colors.transparent,
                textInputAction: TextInputAction.next,

                filled: true,
                maxLines: 1,
                borderRadius: 16,
                hintText: 'Tài khoản',
                errorText: 'Vui lòng nhập tài khoản',
              ),
              Gap(16.h),
              AppTextField(
                controller: _emailController,
                isError: isErrorEmail,
                heightContainer: 56,
                fillColor: Colors.transparent,
                textInputAction: TextInputAction.next,

                filled: true,
                maxLines: 1,
                borderRadius: 16,
                hintText: 'Email',
                errorText: 'Vui lòng nhập email',
              ),
              Gap(16.h),
              AppTextField(
                controller: _passwordController,
                isError: isErrorPass,
                heightContainer: 56,
                fillColor: Colors.transparent,
                textInputAction: TextInputAction.done,
                filled: true,
                maxLines: 1,
                borderRadius: 16,
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
                    if (!isErrorEmail &&
                        !isErrorName &&
                        !isErrorUsername &&
                        !isErrorPass) {
                      final bool response = await authCubit.register(
                        UserData(
                          name: _nameController.text.trim(),
                          username: _usernameController.text.trim(),
                          email: _emailController.text.trim(),
                          pass: _passwordController.text.trim(),
                        ),
                      );
                      if (response) {
                        showOkAlertDialog(
                          context: context,
                          title: 'Thành công',
                          message: 'Đăng ký thành công!',
                          onPopInvokedWithResult: (didPop, result) {
                            Future.microtask(() {
                              context.go(AppRouteConstant.loginScreen);
                            });
                          },
                        );
                      } else {
                        showOkAlertDialog(
                          context: context,
                          title: 'Thất bại',
                          message: 'Đăng ký thất bại!',
                          canPop: false,
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
                    'Đăng ký',
                    style: textStyle.bodyMedium?.copyWith(
                      color: AppColors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Gap(30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Đã có tài khoản?',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.go(AppRouteConstant.loginScreen);
                    },
                    child: Text(
                      ' Đăng nhập',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hinText,
    required TextEditingController textEditingController,
    VoidCallback? onTap,
    TextInputAction? textInputAction,
    bool isPassWord = false,
    bool isShowPass = false,
  }) {
    return TextFormField(
      controller: textEditingController,
      textInputAction: textInputAction,
      obscureText: isShowPass,
      validator: validate,
      style: isPassWord ? const TextStyle(letterSpacing: 5) : null,
      decoration: InputDecoration(
        hintText: hinText,
        hintStyle: TextStyle(fontSize: 14.sp, letterSpacing: 1),
        suffixIcon: isPassWord
            ? IconButton(
                onPressed: () {
                  onTap?.call();
                },
                icon: Icon(
                  isShowPass ? Icons.visibility : Icons.visibility_off,
                  size: 20.w,
                ),
              )
            : null,
        fillColor: AppColors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(16),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(16),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.red5, width: 1.0),
          borderRadius: BorderRadius.circular(16),
        ),
        errorStyle: const TextStyle(color: AppColors.red5),
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
