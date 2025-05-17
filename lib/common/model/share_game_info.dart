import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'share_game_info.g.dart';

@JsonSerializable()
class ShareGameInfo extends Equatable {
  final int id;
  @JsonKey(defaultValue: '')
  final String title;
  final String imgUrl;
  @JsonKey(defaultValue: '')
  final String holderName;
  @JsonKey(defaultValue: '')
  final String holderAvatarUrl;

  const ShareGameInfo({
    required this.id,
    required this.title,
    required this.imgUrl,
    required this.holderName ,
    required this.holderAvatarUrl,
  });

  factory ShareGameInfo.fromJson(Map<String, dynamic> srcJson) => _$ShareGameInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ShareGameInfoToJson(this);

  @override
  List<Object?> get props => [id, title, imgUrl];

  static const shareGamePrefix = '##shareGame=';

  String toChatContent() {
    final jsonStr = jsonEncode(toJson());
    return '$shareGamePrefix$jsonStr';
  }

  static bool isShareGameContent(String content) {
    return content.startsWith(shareGamePrefix);
  }

  static ShareGameInfo? fromChatContent(String? content) {
    if (content == null) {
      return null;
    }
    if (!isShareGameContent(content)) {
      return null;
    }
    var jsonStr = content.substring(shareGamePrefix.length).replaceAll('&quot;', '"');
    if (!jsonStr.startsWith('{')) {
      return null;
    }
    final jsonMap = jsonDecode(jsonStr);
    return ShareGameInfo.fromJson(jsonMap);
  }
}