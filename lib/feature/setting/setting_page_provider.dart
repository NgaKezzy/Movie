import 'dart:ffi';

import 'package:app/config/di.dart';
import 'package:app/feature/home/cubit/movie_cubit.dart';
import 'package:app/feature/login/cubit/auth_cubit.dart';
import 'package:app/feature/setting/setting_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPageProvider extends StatelessWidget {
  const SettingPageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieCubit movieCubit = di.get();
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: movieCubit,
        ),
        BlocProvider.value(
          value: di.get<AuthCubit>(),
        ),
      ],
      child: SettingsPage(),
    );
  }
}
