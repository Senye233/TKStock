// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatHistory _$ChatHistoryFromJson(Map<String, dynamic> json) => ChatHistory(
      dialogId: (json['dialogId'] as num).toInt(),
      dialogContexts: (json['dialogContexts'] as List<dynamic>)
          .map((e) => DialogContext.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatHistoryToJson(ChatHistory instance) =>
    <String, dynamic>{
      'dialogId': instance.dialogId,
      'dialogContexts': instance.dialogContexts,
    };

DialogContext _$DialogContextFromJson(Map<String, dynamic> json) =>
    DialogContext(
      dialogId: (json['dialogId'] as num).toInt(),
      dialogDetailId: (json['dialogDetailId'] as num).toInt(),
      question: json['question'] as String,
      replyContext: json['replyContext'] as String,
      hit: (json['hit'] as num).toInt(),
      traced: (json['traced'] as num).toInt(),
      imageUrl: json['imageUrl'] as String?,
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.parse(json['createdTime'] as String),
    );

Map<String, dynamic> _$DialogContextToJson(DialogContext instance) =>
    <String, dynamic>{
      'dialogId': instance.dialogId,
      'dialogDetailId': instance.dialogDetailId,
      'question': instance.question,
      'replyContext': instance.replyContext,
      'hit': instance.hit,
      'traced': instance.traced,
      'imageUrl': instance.imageUrl,
      'createdTime': instance.createdTime?.toIso8601String(),
    };
