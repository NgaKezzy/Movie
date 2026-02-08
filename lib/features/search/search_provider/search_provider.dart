import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/core/di/di.dart';
import 'package:movie/features/movie/cubit/movie_cubit.dart';
import 'package:movie/features/search/search_page.dart';

class SearchProvider extends StatelessWidget {
  const SearchProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt.get<MovieCubit>(),
      child: const SearchPage(),
    );
  }
}
