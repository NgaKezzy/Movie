import 'package:dartz/dartz.dart';
import 'package:movie/common/domain/entities/request/keyword.dart';
import 'package:movie/common/domain/entities/request/limit_movie.dart';
import 'package:movie/common/domain/entities/request/page.dart';
import 'package:movie/common/domain/entities/response/failure.dart';
import 'package:movie/common/domain/entities/response/movie_data.dart';
import 'package:movie/common/domain/entities/response/movie_info.dart';
import 'package:movie/common/domain/entities/response/movie_response.dart';
import 'package:movie/common/domain/entities/response/movie_search.dart';

abstract class MovieRepository {
  Future<Either<Failure, MovieData>> getNewMovieUpdate(PageMovie param);
  Future<Either<Failure, MovieInfo>> getMovieInfo(String slug);
  Future<Either<Failure, MovieSearch>> getMovieSearch(Keyword param);
  Future<Either<Failure, MovieResponse>> getOneEpisodeMovie(LimitMovie param);
  Future<Either<Failure, MovieResponse>> getSeriesMovie(LimitMovie param);
  Future<Either<Failure, MovieResponse>> getCartoonMovie(LimitMovie param);


}
