import 'package:app/feature/login/models/user_info.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'auth_state.g.dart';

@JsonSerializable()
@CopyWith()
class AuthState extends Equatable {
  const AuthState({this.userInfo, this.isLogin = false});
  final UserInfo? userInfo;
  final bool isLogin;

  @override
  List<Object?> get props => [userInfo, isLogin];

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
  Map<String, dynamic> toJson() => _$AuthStateToJson(this);
}
