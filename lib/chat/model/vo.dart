import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tkstock/common/ui/std_color.dart';

class BaseChatItemVo extends Equatable {
  final String id;

  const BaseChatItemVo({required this.id});

  @override
  List<Object?> get props => [id];
}

class UserChatItemVo extends BaseChatItemVo {
  final String name;
  final String? avatarUrl;
  final String text;
  final String? imageUrl;

  const UserChatItemVo({
    required super.id,
    required this.name,
    required this.text,
    this.avatarUrl,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, avatarUrl, text, imageUrl];
}

class AssistantTextChatItemVo extends BaseChatItemVo {
  final String text;
  final AssistantTextChatItemCreateStatus createStatus;

  const AssistantTextChatItemVo({
    required this.text,
    required super.id,
    required this.createStatus,
  });

  @override
  List<Object?> get props => [id, text, createStatus];

  AssistantTextChatItemVo copyWith({AssistantTextChatItemCreateStatus? createStatus}) {
    return AssistantTextChatItemVo(id: id, text: text, createStatus: createStatus ?? this.createStatus);
  }

  bool get isTraced => createStatus == AssistantTextChatItemCreateStatus.traced;

  bool get isCreating => createStatus == AssistantTextChatItemCreateStatus.creating;

  bool get isPause => createStatus == AssistantTextChatItemCreateStatus.pause;

  bool get isFinish => createStatus == AssistantTextChatItemCreateStatus.finish;
}

enum AssistantTextChatItemCreateStatus {
  creating,
  pause,
  finish,
  traced;

  String get bottomRightText {
    switch (this) {
      case AssistantTextChatItemCreateStatus.creating:
        return '';
      case AssistantTextChatItemCreateStatus.pause:
        return '继续生成';
      case AssistantTextChatItemCreateStatus.finish:
        return '一键追踪';
      case AssistantTextChatItemCreateStatus.traced:
        return '已追踪';
    }
  }

  Decoration? get bottomRightDecoration {
    switch (this) {
      case AssistantTextChatItemCreateStatus.creating:
        return null;
      case AssistantTextChatItemCreateStatus.pause:
      case AssistantTextChatItemCreateStatus.finish:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: bottomRightTextColor),
        );
      case AssistantTextChatItemCreateStatus.traced:
        return BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: StdColor.c_999999),
        );
    }
  }

  Color get bottomRightTextColor {
    switch (this) {
      case AssistantTextChatItemCreateStatus.creating:
      case AssistantTextChatItemCreateStatus.pause:
        return StdColor.c_282828;
      case AssistantTextChatItemCreateStatus.finish:
        return StdColor.c_999999;
      case AssistantTextChatItemCreateStatus.traced:
        return Colors.white;
    }
  }
}

class AssistantAdviceChatItemVo extends BaseChatItemVo {
  final String code;
  final ChatAdviceType type;
  final double price;
  final double supportScore;
  final double reitScore;
  final double totalScore;
  final String date;

  const AssistantAdviceChatItemVo({
    required super.id,
    required this.code,
    required this.type,
    required this.price,
    required this.supportScore,
    required this.reitScore,
    required this.totalScore,
    required this.date,
  });

  @override
  List<Object?> get props => [id, code, type, price, supportScore, reitScore, totalScore, date];
}

class TimeChatItemVo extends BaseChatItemVo {
  final String time;

  const TimeChatItemVo({required this.time, super.id = ''});

  @override
  List<Object?> get props => [id, time];
}

enum ChatItemType { text, time, advice }

enum ChatAdviceType {
  buy,
  sell,
  wait;

  Color get priceColor {
    switch (this) {
      case ChatAdviceType.buy:
        return StdColor.highlight;
      case ChatAdviceType.sell:
        return const Color(0xFF34C759);
      case ChatAdviceType.wait:
        return StdColor.c_999999;
    }
  }

  String get assetName {
    switch (this) {
      case ChatAdviceType.buy:
        return 'chat/ic_buy.png';
      case ChatAdviceType.sell:
        return 'chat/ic_sell.png';
      case ChatAdviceType.wait:
        return 'chat/ic_wait.png';
    }
  }
}
