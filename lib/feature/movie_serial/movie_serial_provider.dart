import 'package:app/config/di.dart';
import 'package:app/feature/home/cubit/movie_cubit.dart';
import 'package:app/feature/movie_serial/movie_serial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieSerialProvider extends StatelessWidget {
  const MovieSerialProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.get<MovieCubit>(),
      child: const MovieSerial(),
    );
  }
}
