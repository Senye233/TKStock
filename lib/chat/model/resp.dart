import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'resp.g.dart';

@JsonSerializable()
class ChatHistory extends Equatable {
  final int dialogId;
  final List<DialogContext> dialogContexts;

  const ChatHistory({
    required this.dialogId,
    required this.dialogContexts,
  });

  factory ChatHistory.fromJson(Map<String, dynamic> json) => _$ChatHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$ChatHistoryToJson(this);

  @override
  List<Object?> get props => [dialogId, dialogContexts];
}

@JsonSerializable()
class DialogContext extends Equatable {
  final int dialogId;
  final int dialogDetailId;
  final String question;
  final String replyContext;
  final int hit;
  final int traced;
  final String? imageUrl;
  final DateTime? createdTime;

  const DialogContext({
    required this.dialogId,
    required this.dialogDetailId,
    required this.question,
    required this.replyContext,
    required this.hit,
    required this.traced,
    required this.imageUrl,
    required this.createdTime,
  });

  factory DialogContext.fromJson(Map<String, dynamic> json) => _$DialogContextFromJson(json);

  Map<String, dynamic> toJson() => _$DialogContextToJson(this);

  @override
  List<Object?> get props => [dialogId, dialogDetailId, question, replyContext, hit, traced, imageUrl, createdTime];
}
