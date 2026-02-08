// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:movie/common/domain/entities/response/movie_data.dart';

part 'movie_search.g.dart';

@JsonSerializable()
class MovieSearch {
  String? status;
  String? msg;
  MovieData? data;
  MovieSearch({this.status, this.msg, this.data});

  factory MovieSearch.fromJson(Map<String, dynamic> json) =>
      _$MovieSearchFromJson(json);

  Map<String, dynamic> toJson() => _$MovieSearchToJson(this);
}
