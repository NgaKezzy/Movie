import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/web.dart';
import 'package:movie/common/data/data_source/remote/movie_data_source.dart';
import 'package:movie/common/domain/entities/request/keyword.dart';
import 'package:movie/common/domain/entities/request/limit_movie.dart';
import 'package:movie/common/domain/entities/request/page.dart';
import 'package:movie/common/domain/entities/response/failure.dart';
import 'package:movie/common/domain/entities/response/movie_data.dart';
import 'package:movie/common/domain/entities/response/movie_info.dart';
import 'package:movie/common/domain/entities/response/movie_response.dart';
import 'package:movie/common/domain/entities/response/movie_search.dart';
import 'package:movie/common/domain/repository/movie_repository.dart';
import 'package:movie/core/di/di.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieDataSource movieDataSource;
  final Logger logger = getIt.get();
  MovieRepositoryImpl({required this.movieDataSource});

  @override
  Future<Either<Failure, MovieData>> getNewMovieUpdate(PageMovie param) async {
    try {
      final response = await movieDataSource.getNewMovieUpdate(param);
      return Right(response);
    } on DioException catch (e) {
      logger.e(e);
      return Left(
        Failure(
          error: e.response?.data['error'],
          message: e.response?.data['message'],
        ),
      );
    } catch (e) {
      logger.e(e);
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MovieInfo>> getMovieInfo(String slug) async {
    try {
      final response = await movieDataSource.getMovieInfo(slug);
      return Right(response);
    } on DioException catch (e) {
      logger.e(e);
      return Left(
        Failure(
          error: e.response?.data['error'],
          message: e.response?.data['message'],
        ),
      );
    } catch (e) {
      logger.e(e);
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MovieSearch>> getMovieSearch(Keyword param) async {
    try {
      final response = await movieDataSource.getMovieSearch(param);
      return Right(response);
    } on DioException catch (e) {
      logger.e(e);
      return Left(
        Failure(
          error: e.response?.data['error'],
          message: e.response?.data['message'],
        ),
      );
    } catch (e) {
      logger.e(e);
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MovieResponse>> getOneEpisodeMovie(
    LimitMovie param,
  ) async {
    try {
      final response = await movieDataSource.getOneEpisodeMovie(param);
      return Right(response);
    } on DioException catch (e) {
      logger.e(e);
      return Left(
        Failure(
          error: e.response?.data['error'],
          message: e.response?.data['message'],
        ),
      );
    } catch (e) {
      logger.e(e);
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MovieResponse>> getCartoonMovie(LimitMovie param) async {
    try {
      final response = await movieDataSource.getCartoonMovie(param);
      return Right(response);
    } on DioException catch (e) {
      logger.e(e);
      return Left(
        Failure(
          error: e.response?.data['error'],
          message: e.response?.data['message'],
        ),
      );
    } catch (e) {
      logger.e(e);
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MovieResponse>> getSeriesMovie(LimitMovie param) async {
    try {
      final response = await movieDataSource.getSeriesMovie(param);
      return Right(response);
    } on DioException catch (e) {
      logger.e(e);
      return Left(
        Failure(
          error: e.response?.data['error'],
          message: e.response?.data['message'],
        ),
      );
    } catch (e) {
      logger.e(e);
      return Left(Failure(message: e.toString()));
    }
  }
}
