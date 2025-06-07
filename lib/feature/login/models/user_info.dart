import 'package:json_annotation/json_annotation.dart';
part 'user_info.g.dart';

@JsonSerializable()
class UserInfo {
  String name;
  String email;
  String photoUrl;
  String id;
  bool isPremium;
  int diamond;
  DateTime? premiumTerm;

  UserInfo({
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.id,
    required this.isPremium,
    this.diamond = 100,
    this.premiumTerm,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
