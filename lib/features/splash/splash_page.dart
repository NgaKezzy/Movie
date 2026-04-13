import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:movie/core/di/di.dart';
import 'package:movie/core/gen/assets.gen.dart';
import 'package:movie/routers/app_router.dart';
import 'package:movie/features/movie/cubit/movie_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final MovieCubit movieCubit = getIt.get();
  @override
  void initState() {
    super.initState();
    movieCubit.clearData();

    Timer(const Duration(milliseconds: 1500), () {
      context.go(RouteName.homePage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0XFF024CAA), Color(0XFF013577), Color(0XFF011E44)],
          ),
        ),
        child: Center(child: SvgPicture.asset(Assets.svg.appLogo, width: 80.w)),
      ),
    );
  }
}
