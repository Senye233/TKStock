// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      deptId: (json['deptId'] as num?)?.toInt() ?? 0,
      status: (json['status'] as num?)?.toInt() ?? 0,
      username: json['username'] as String? ?? '',
      sex: (json['sex'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      nickname: json['nickname'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'deptId': instance.deptId,
      'status': instance.status,
      'username': instance.username,
      'sex': instance.sex,
      'name': instance.name,
      'nickname': instance.nickname,
      'phone': instance.phone,
      'email': instance.email,
      'avatar': instance.avatar,
    };

LoginResp _$LoginRespFromJson(Map<String, dynamic> json) => LoginResp(
      passwordSet: (json['passwordSet'] as num).toInt(),
      refreshToken: json['refreshToken'] as String,
      refreshTokenExpire: (json['refreshTokenExpire'] as num).toInt(),
      token: json['token'] as String,
      tokenExpire: (json['tokenExpire'] as num).toInt(),
    );

Map<String, dynamic> _$LoginRespToJson(LoginResp instance) => <String, dynamic>{
      'passwordSet': instance.passwordSet,
      'refreshToken': instance.refreshToken,
      'refreshTokenExpire': instance.refreshTokenExpire,
      'token': instance.token,
      'tokenExpire': instance.tokenExpire,
    };
