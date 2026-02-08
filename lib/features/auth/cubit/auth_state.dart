import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie/common/domain/entities/response/user_data.dart';
part 'auth_state.g.dart';

@CopyWith()
@JsonSerializable()
class AuthState extends Equatable {
  const AuthState({this.users = const [], this.user, this.isLogin = false});

  final List<UserData> users;
  final UserData? user;
  final bool isLogin;

  @override
  List<Object?> get props => [users, user, isLogin];  

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
  Map<String, dynamic> toJson() => _$AuthStateToJson(this);
}
