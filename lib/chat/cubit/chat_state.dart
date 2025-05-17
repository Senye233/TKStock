part of 'chat_cubit.dart';

class ChatLoaded extends CommonLoaded {
  final List<BaseChatItemVo> vos;
  final ChatModelType modelType;
  final String title;
  final CommonListStatus status;
  final HintVo? hintVo;

  ChatLoaded({
    required this.vos,
    required this.modelType,
    required this.title,
    required this.status,
    required this.hintVo,
  });

  @override
  List<Object?> get props => [vos, modelType, title, status, hintVo, Object()];

  bool get isCreating {
    final first = vos.firstOrNull;
    if (first == null) return false;
    if (first is! AssistantTextChatItemVo) return false;
    return first.createStatus == AssistantTextChatItemCreateStatus.creating;
  }
}

enum ChatModelType {
  chatGPT,
  deepSeekR1;

  String get assetName {
    switch (this) {
      case ChatModelType.chatGPT:
        return 'chat/ic_model_chatgpt.png';
      case ChatModelType.deepSeekR1:
        return 'chat/ic_model_deepseekr1.png';
    }
  }

  String get title {
    switch (this) {
      case ChatModelType.chatGPT:
        return 'ChatGPT 4.1';
      case ChatModelType.deepSeekR1:
        return '深度模型R1';
    }
  }

  String get modelName {
    switch (this) {
      case ChatModelType.chatGPT:
        return 'chatgpt';
      case ChatModelType.deepSeekR1:
        return 'deepseek_r1';
    }
  }
}

class HintVo extends Equatable {
  final String title;
  final String percent;

  const HintVo({required this.title, required this.percent});

  @override
  List<Object?> get props => [title, percent];
}
