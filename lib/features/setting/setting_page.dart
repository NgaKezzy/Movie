import 'dart:io';

import 'package:cupertino_native/components/switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:movie/core/colors/app_colors.dart';
import 'package:movie/core/di/di.dart';
import 'package:movie/core/gen/assets.gen.dart';
import 'package:movie/core/language/cubit/language_cubit.dart';
import 'package:movie/core/text_style/app_text_style.dart';
import 'package:movie/core/theme/cubit/theme_cubit.dart';
import 'package:movie/core/theme/cubit/theme_state.dart';
import 'package:movie/core/language/l10n/app_localizations.dart';
import 'package:movie/features/auth/cubit/auth_cubit.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

  final ThemeCubit themeCubit = getIt<ThemeCubit>();
  final LanguageCubit languageCubit = getIt<LanguageCubit>();
  final AuthCubit authCubit = getIt<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Row(
            children: [
              // Logo SVG hình tròn
              SvgPicture.asset(Assets.svg.appLogo, height: 28.h, width: 28.w),
              Gap(12.w),
              // Text cài đặt với gradient
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => LinearGradient(
                  colors: [AppColors.red1, AppColors.red5],
                ).createShader(bounds),
                child: Text(
                  language!.setting,
                  style: AppTextStyles.textStyleBold20.copyWith(
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(language.darkMode), _buildSwitch()],
                );
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(language.language),
                DropdownButton<String>(
                  value: languageCubit.state.languageCode,
                  style: AppTextStyles.textStyle10.copyWith(
                    color: AppColors.red5,
                  ),
                  underline: const SizedBox(), // Ẩn đường gạch chân
                  items: [
                    DropdownMenuItem(
                      value: 'vi',
                      child: Text(language.vietNamese),
                    ),
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(language.english),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      languageCubit.changedLanguage(newValue);
                    }
                  },
                ),
              ],
            ),

            // Gap(50),
            // TextButton(
            //   onPressed: () {
            //     showOkCancelAlertDialog(
            //       context: context,
            //       title: language.logout,
            //       message: language.logoutConfirm,

            //       onPopInvokedWithResult: (didPop, result) {
            //         if (result == OkCancelResult.ok) {
            //           authCubit.setIsLogin(false);
            //           context.go(AppRouteConstant.initial);
            //         } else if (result == OkCancelResult.cancel) {
            //           print('nhấn hủy');
            //         }
            //       },
            //     );
            //   },
            //   child: Text(language.logout),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch() {
    if (Platform.isIOS) {
      return CNSwitch(
        value: themeCubit.state.isDark,
        color: AppColors.red5,
        onChanged: (v) {
          themeCubit.toggedTheme();
        },
      );
    } else {
      return Transform.scale(
        scale: 0.7,
        child: CupertinoSwitch(
          value: themeCubit.state.isDark,
          onChanged: (value) {
            themeCubit.toggedTheme();
          },
        ),
      );
    }
  }
}
