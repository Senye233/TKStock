// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_game_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShareGameInfo _$ShareGameInfoFromJson(Map<String, dynamic> json) =>
    ShareGameInfo(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      imgUrl: json['imgUrl'] as String,
      holderName: json['holderName'] as String? ?? '',
      holderAvatarUrl: json['holderAvatarUrl'] as String? ?? '',
    );

Map<String, dynamic> _$ShareGameInfoToJson(ShareGameInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imgUrl': instance.imgUrl,
      'holderName': instance.holderName,
      'holderAvatarUrl': instance.holderAvatarUrl,
    };
