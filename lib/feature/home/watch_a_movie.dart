import 'package:app/component/loading_widget.dart';
import 'package:app/config/di.dart';
import 'package:app/feature/home/cubit/movie_cubit.dart';
import 'package:app/feature/home/cubit/movie_state.dart';
import 'package:app/feature/home/widgets/video_player_widget.dart';
import 'package:app/l10n/cubit/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class WatchAMovie extends StatefulWidget {
  const WatchAMovie({super.key, required this.slug});
  final String slug;

  @override
  State<WatchAMovie> createState() => _WatchAMovieState();
}

class _WatchAMovieState extends State<WatchAMovie> {
  final MovieCubit movieCubit = di.get();
  late LocaleCubit localeCubit;

  @override
  void initState() {
    super.initState();
    localeCubit = context.read<LocaleCubit>();
    getData();
  }

  Future<void> getData() async {
    await movieCubit.getMovieDetails(
        widget.slug, localeCubit.state.languageCode);
    movieCubit.addToWatchHistory(slug: widget.slug);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieCubit, MovieState>(
        bloc: movieCubit,
        builder: (context, state) {
          if (state.dataFilm == null) {
            return const Center(
              child: LoadingWidget(),
            );
          }

          return WillPopScope(
            onWillPop: () async {
              Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.pressTheButtonToExit,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.red,
                  fontSize: 16.0);
              return false;
            },
            child: SafeArea(
              child: Stack(
                children: [
                  Expanded(
                    child: VideoPlayerWidget(
                        // movieInformation: widget.movieInformation,
                        url: state.dataFilm?.episodes[0].server_data[0]
                                .link_m3u8 ??
                            '',
                        dataFilm: state.dataFilm),
                  ),
                  Positioned(
                      left: 20,
                      top: 20,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          'assets/icons/chevron_down.svg',
                          color: Colors.red,
                          width: 30,
                        ),
                      ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
