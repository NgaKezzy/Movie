import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/core/di/di.dart';
import 'package:movie/features/movie/cubit/movie_cubit.dart';
import 'package:movie/features/setting/movie_history_page.dart';

class MovieHistoryProvider extends StatelessWidget {
  const MovieHistoryProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final MovieCubit movieCubit = getIt.get();
    return BlocProvider.value(
     value: movieCubit, 
      child: const MovieHistoryPage(),
    );
  }
}
