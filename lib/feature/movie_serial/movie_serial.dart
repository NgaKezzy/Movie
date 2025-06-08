import 'package:app/config/di.dart';
import 'package:app/feature/home/cubit/movie_cubit.dart';
import 'package:app/feature/home/cubit/movie_state.dart';
import 'package:app/feature/home/widgets/item_grid_and_title.dart';
import 'package:app/l10n/cubit/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MovieSerial extends StatefulWidget {
  const MovieSerial({super.key});

  @override
  State<MovieSerial> createState() => _MovieSerialState();
}

class _MovieSerialState extends State<MovieSerial> {
  final MovieCubit movieCubit = di.get();
  late LocaleCubit localeCubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localeCubit = context.read<LocaleCubit>();
    if (movieCubit.state.seriesMovies.isEmpty) {
      movieCubit.getTheListOfMoviesAndSeries(localeCubit.state.languageCode);
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
            itemFilms: state.seriesMovies,
            title: app?.seriesMovie ?? '',
          );
        },
      ),
    );
  }
}
