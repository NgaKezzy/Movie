import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';  
import 'package:movie/core/di/di.dart';
import 'package:movie/features/home/view/home_page.dart';
import 'package:movie/features/movie/cubit/movie_cubit.dart';

class HomeProvider extends StatelessWidget {
  const HomeProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<MovieCubit>()),
      ],
      child: const HomePage(),
    );
  }
}
