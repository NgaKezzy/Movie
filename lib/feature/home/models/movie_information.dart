// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'movie_information.g.dart';

@JsonSerializable()
class MovieInformation {
  final String name;

  final String slug;

   String origin_name;

  String poster_url;

  String thumb_url;

  final int year;

  bool isFavorite;
  bool isPremium;

  MovieInformation(
      {this.name = '',
      this.slug = '',
      this.origin_name = '',
      this.poster_url = '',
      this.thumb_url = ' ',
      this.year = 2020,
      this.isPremium = false,
      this.isFavorite = false});

  factory MovieInformation.fromJson(Map<String, dynamic> json) =>
      _$MovieInformationFromJson(json);

  Map<String, dynamic> toJson() => _$MovieInformationToJson(this);

  static List<MovieInformation> convertToList(List<dynamic> json) {
    //json ở đây là data
    return json
        .map<MovieInformation>((item) => MovieInformation.fromJson(item))
        .toList();
    // post này là từng instance   ------------- post này là  để ấy vào trong fromjson trong factory rồi chuyển thành list
  }

  @override
  String toString() {
    return 'MovieInformation(name: $name, slug: $slug, origin_name: $origin_name, poster_url: $poster_url, thumb_url: $thumb_url, year: $year, isFavorite: $isFavorite)';
  }
}
