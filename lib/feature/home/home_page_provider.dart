import 'package:app/config/di.dart';
import 'package:app/feature/home/cubit/movie_cubit.dart';
import 'package:app/feature/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageProvider extends StatelessWidget {
  const HomePageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieCubit movieCubit = di.get();
    return BlocProvider.value(
      value:movieCubit,
      child: const HomePage(),
    );
  }
}
