import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie/common/domain/entities/response/movie_data.dart';
import 'package:movie/common/domain/entities/response/movie_info.dart';

part 'movie_state.g.dart';

@CopyWith()
@JsonSerializable()
class MovieState extends Equatable {
  const MovieState({
    this.newMovieList = const [],
    this.movieInfo,
    this.movieSearchList = const [],
    this.movieHistory = const [],
    this.movieSeries = const [],
    this.movieSingle = const [],
    this.movieCartoon = const [],

  });

  final List<Movie> newMovieList;
  final MovieInfo? movieInfo;
  final List<Movie> movieSearchList;
  final List<Movie> movieHistory;
  final List<Movie> movieSingle;
  final List<Movie> movieSeries;
  final List<Movie> movieCartoon;


  @override
  List<Object?> get props => [
    newMovieList,
    movieInfo,
    movieSearchList,
    movieHistory,
    movieSeries,
    movieSingle,
    movieCartoon
  ];

  factory MovieState.fromJson(Map<String, dynamic> json) =>
      _$MovieStateFromJson(json);
  Map<String, dynamic> toJson() => _$MovieStateToJson(this);
}
