import 'package:json_annotation/json_annotation.dart';
import 'package:movie/common/domain/entities/response/movie_data.dart';
part 'movie_info.g.dart';

@JsonSerializable()
class MovieInfo {
  bool? status;
  String? msg;
  Movie? movie;
  List<Episode>? episodes;

  MovieInfo({this.status, this.msg, this.movie, this.episodes});

  factory MovieInfo.fromJson(Map<String, dynamic> json) =>
      _$MovieInfoFromJson(json);

  Map<String, dynamic> toJson() => _$MovieInfoToJson(this);
}

@JsonSerializable()
class Episode {
  String? serverName;
  @JsonKey(name: 'server_data')
  List<ServerData>? serverData;

  Episode({this.serverName, this.serverData});
  factory Episode.fromJson(Map<String, dynamic> json) =>
      _$EpisodeFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}

@JsonSerializable()
class ServerData {
  String? name;
  String? slug;

  String? filename;
  @JsonKey(name: 'link_embed')
  String? linkEmbed;
  @JsonKey(name: 'link_m3u8')
  String? linkM3U8;

  ServerData({
    this.name,
    this.slug,
    this.filename,
    this.linkEmbed,
    this.linkM3U8,
  });
  factory ServerData.fromJson(Map<String, dynamic> json) =>
      _$ServerDataFromJson(json);

  Map<String, dynamic> toJson() => _$ServerDataToJson(this);
}
