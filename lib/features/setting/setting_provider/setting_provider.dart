import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/core/di/di.dart';
import 'package:movie/features/auth/cubit/auth_cubit.dart';
import 'package:movie/features/setting/setting_page.dart';

class SettingProvider extends StatelessWidget {
  const SettingProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: getIt.get<AuthCubit>())],
      child: SettingPage(),
    );
  }
}
