import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/web.dart';
import 'package:movie/common/data/data_source/repository/movie_repository_iplm.dart';
import 'package:movie/common/domain/entities/request/keyword.dart';
import 'package:movie/common/domain/entities/request/limit_movie.dart';
import 'package:movie/common/domain/entities/request/page.dart';
import 'package:movie/common/domain/entities/response/movie_data.dart';
import 'package:movie/core/di/di.dart';
import 'package:movie/routers/app_router.dart';
import 'package:movie/features/movie/cubit/movie_state.dart';

class MovieCubit extends HydratedCubit<MovieState> {
  final MovieRepositoryImpl movieRepositoryImpl;
  MovieCubit({required this.movieRepositoryImpl}) : super(MovieState());

  final Logger logger = getIt.get();

  Future<void> clearData() async {
    emit(
      state.copyWith(
        movieCartoon: [],
        newMovieList: [],
        movieSeries: [],
        movieSingle: [],
      ),
    );
  }

  Future<void> initDataMovie() async {
    // Loading.showLoading();
    getSingleMovie();
    getNewMovieUpdate();
    getCartoonMovie();
    getSeriesMovie();
  }

  Future<void> clearSearchMovie() async {
    emit(state.copyWith(movieSearchList: []));
  }

  Future<bool> getNewMovieUpdate() async {
    final response = await movieRepositoryImpl.getNewMovieUpdate(
      PageMovie(page: 0),
    );

    response.fold((l) {}, (r) {
      emit(state.copyWith(newMovieList: r.items ?? []));
    });
    return true;
  }

  Future<void> getMovieInfo(String slug) async {
    emit(state.copyWith(movieInfo: null));
    // Loading.showLoading();

    final response = await movieRepositoryImpl.getMovieInfo(slug);
    // Loading.hideLoading();

    response.fold((l) {}, (r) {
      emit(state.copyWith(movieInfo: r));
    });
  }

  Future<void> getMovieSearch(String keyword) async {
    // Loading.showLoading();

    final response = await movieRepositoryImpl.getMovieSearch(
      Keyword(keyword: keyword),
    );
    // Loading.hideLoading();

    response.fold((l) {}, (r) {
      emit(state.copyWith(movieSearchList: r.data?.items ?? []));
    });
  }

  Future<bool> getSingleMovie() async {
    final response = await movieRepositoryImpl.getOneEpisodeMovie(
      LimitMovie(limit: 50),
    );
    // Loading.hideLoading();

    response.fold((l) {}, (r) {
      emit(state.copyWith(movieSingle: r.data.items));
    });
    return true;
  }

  Future<bool> getCartoonMovie() async {
    final response = await movieRepositoryImpl.getCartoonMovie(
      LimitMovie(limit: 50),
    );
    // Loading.hideLoading();

    response.fold((l) {}, (r) {
      emit(state.copyWith(movieCartoon: r.data.items));
    });
    return true;
  }

  Future<bool> getSeriesMovie() async {
    final response = await movieRepositoryImpl.getSeriesMovie(
      LimitMovie(limit: 50),
    );
    // Loading.hideLoading();

    response.fold((l) {}, (r) {
      emit(state.copyWith(movieSeries: r.data.items));
    });
    return true;
  }

  Future<void> playMovie({
    required Movie movie,
    required BuildContext context,
  }) async {
    // await addToHistory(movie);

    for (var element in state.movieHistory) {
      if (element.slug == movie.slug) {
        movie = movie.copyWith(
          episodeCurrentlyWatching: element.episodeCurrentlyWatching,
          duration: element.duration,
        );
        break;
      }
    }
    await addToHistory(movie);
    context.push(RouteName.watchMovie, extra: movie);
  }

  Future<void> addToHistory(Movie movie) async {
    List<Movie> newHistory = List.from(state.movieHistory);

    // Nếu đã có trong lịch sử thì xóa để đẩy lên cuối danh sách
    newHistory.removeWhere((element) => (element.slug ?? '') == movie.slug);

    // Thêm vào đầu mảng
    newHistory.insert(0, movie);

    emit(state.copyWith(movieHistory: newHistory));
    logger.i(state.movieHistory.length);
  }

  Future<void> saveMovieInformation({
    required int index,
    required Duration duration,
  }) async {
    final List<Movie> movies = List.from(state.movieHistory);
    Movie movie = state.movieHistory.first;

    // Gán lại kết quả copyWith vào biến movie
    movie = movie.copyWith(episodeCurrentlyWatching: index, duration: duration);

    movies.first = movie;
    emit(state.copyWith(movieHistory: movies));

    print(movies.first.duration?.inSeconds);
  }

  @override
  MovieState? fromJson(Map<String, dynamic> json) {
    try {
      return MovieState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(MovieState state) {
    try {
      return state.toJson();
    } catch (_) {
      return null;
    }
  }
}
