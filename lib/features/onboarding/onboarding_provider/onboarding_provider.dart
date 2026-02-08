import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/core/di/di.dart';
import 'package:movie/features/auth/cubit/auth_cubit.dart';
import 'package:movie/features/onboarding/onboarding_page.dart';

class OnboardingProvider extends StatelessWidget {
  const OnboardingProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
     value: getIt.get<AuthCubit>(),
      child: const OnboardingPage(),
    );
  }
}
