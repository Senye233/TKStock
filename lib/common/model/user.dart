import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';


@JsonSerializable()
class User extends Equatable {
  @JsonKey(defaultValue: 0)
  final int userId;
  @JsonKey(defaultValue: 0)
  final int deptId;
  @JsonKey(defaultValue: 0)
  final int status;
  @JsonKey(defaultValue: '')
  final String username;
  @JsonKey(defaultValue: 0)
  final int sex;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String nickname;
  @JsonKey(defaultValue: '')
  final String phone;
  @JsonKey(defaultValue: '')
  final String email;
  @JsonKey(defaultValue: '')
  final String avatar;

  const User({
    required this.userId,
    required this.deptId,
    required this.status,
    required this.username,
    required this.sex,
    required this.name,
    required this.nickname,
    required this.phone,
    required this.email,
    required this.avatar, 
  });

  factory User.fromJson(Map<String, dynamic> srcJson) => _$UserFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [userId, deptId, status, username, sex, name, nickname, phone, email, avatar];

  String toJsonStr() {
    return jsonEncode(toJson());
  }

  static User? fromJsonStr(String userStr) {
    if (userStr.isEmpty) {
      return null;
    }
    final Map<String, dynamic> json = jsonDecode(userStr);
    return User.fromJson(json);
  }
}

@JsonSerializable()
class LoginResp extends Equatable {
  final int passwordSet;
  final String refreshToken;
  // 秒为单位，从收到开始算
  final int refreshTokenExpire;
  final String token;
  // TODO: 检查 token 有效期并自动刷新逻辑
  // 秒为单位，从收到开始算
  final int tokenExpire;

  const LoginResp({
    required this.passwordSet,
    required this.refreshToken,
    required this.refreshTokenExpire,
    required this.token,
    required this.tokenExpire,
  });

  factory LoginResp.fromJson(Map<String, dynamic> srcJson) => _$LoginRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoginRespToJson(this);

  @override
  List<Object?> get props => [passwordSet, refreshToken, refreshTokenExpire, token, tokenExpire];
}
