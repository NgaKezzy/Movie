import 'package:app/config/di.dart';
import 'package:app/feature/home/cubit/movie_cubit.dart';
import 'package:app/feature/movie_cartoon/movie_cartoon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieCartoonProvider extends StatelessWidget {
  const MovieCartoonProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.get<MovieCubit>(),
      child: const MovieCartoon(),
    );
  }
}
