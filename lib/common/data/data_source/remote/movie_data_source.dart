import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:movie/common/domain/entities/request/keyword.dart';
import 'package:movie/common/domain/entities/request/limit_movie.dart';
import 'package:movie/common/domain/entities/request/page.dart';
import 'package:movie/common/domain/entities/response/movie_data.dart';
import 'package:movie/common/domain/entities/response/movie_info.dart';
import 'package:movie/common/domain/entities/response/movie_response.dart';
import 'package:movie/common/domain/entities/response/movie_search.dart';
import 'package:movie/core/constants/url_constants.dart';

part 'movie_data_source.g.dart';

@RestApi()
abstract class MovieDataSource {
  factory MovieDataSource(Dio dio, {required String baseUrl}) =
      _MovieDataSource;

  @GET(UrlConstants.newMovieUpdate)
  Future<MovieData> getNewMovieUpdate(@Queries() PageMovie param);

  @GET('${UrlConstants.movie}{slug}')
  Future<MovieInfo> getMovieInfo(@Path('slug') String slug);

  @GET(UrlConstants.movieSearch)
  Future<MovieSearch> getMovieSearch(@Queries() Keyword param);

    @GET(UrlConstants.singleMovie)
  Future<MovieResponse> getOneEpisodeMovie(@Queries() LimitMovie param);

      @GET(UrlConstants.seriesMovie)
  Future<MovieResponse> getSeriesMovie(@Queries() LimitMovie param);

      @GET(UrlConstants.cartoonMovie)
  Future<MovieResponse> getCartoonMovie(@Queries() LimitMovie param);

}
