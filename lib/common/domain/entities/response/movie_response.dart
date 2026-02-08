import 'package:json_annotation/json_annotation.dart';
import 'package:movie/common/domain/entities/response/movie_data.dart';
part 'movie_response.g.dart';
@JsonSerializable()
class MovieResponse {
  Data data;

  MovieResponse({required this.data});

    factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
}

@JsonSerializable()
class Data {
  final List<Movie> items;
  Data({required this.items});

    factory Data.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
