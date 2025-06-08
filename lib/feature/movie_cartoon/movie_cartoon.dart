import 'package:app/config/di.dart';
import 'package:flutter/material.dart';
import 'package:app/feature/home/cubit/movie_cubit.dart';
import 'package:app/feature/home/cubit/movie_state.dart';
import 'package:app/feature/home/widgets/item_grid_and_title.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MovieCartoon extends StatefulWidget {
  const MovieCartoon({super.key});

  @override
  State<MovieCartoon> createState() => _MovieCartoonState();
}

class _MovieCartoonState extends State<MovieCartoon> {
  final MovieCubit movieCubit = di.get();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (movieCubit.state.cartoon.isEmpty) {
      movieCubit.getTheListOfCartoons();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final app = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(app?.seriesMovie ?? ''),
      ),
      body: BlocBuilder<MovieCubit, MovieState>(
        builder: (context, state) {
          return ItemGridAndTitle(
            itemFilms: state.cartoon,
            title: app?.cartoon ?? '',
          );
        },
      ),
    );
  }
}
