import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';
import 'package:tkstock/chat/model/resp.dart';
import 'package:tkstock/chat/model/vo.dart';
import 'package:tkstock/common/constant.dart';
import 'package:tkstock/common/model/response.dart';
import 'package:tkstock/common/network.dart';
import 'package:tkstock/common/ui/base_state.dart';
import 'package:tkstock/common/ui/common_cubit.dart';

part 'chat_state.dart';

class ChatCubit extends CommonCubit {
  int _id;

  ChatCubit(this._id) : super();

  List<BaseChatItemVo> _list = [];
  int _page = 1;
  var _modelType = ChatModelType.deepSeekR1;
  final _title = 'TkStock';
  var _status = CommonListStatus.noMore;

  @override
  Future load() async {
    if (_id == 0) {
      _refresh();
      return;
    }
    try {
      emit(CommonLoading(isWeak: false));
      final resp = await DioClient.getRespData(
        'dialog/$_id',
        fromJsonT: (jsonT) => ChatHistory.fromJson(jsonT),
      );
      _list = resp.data!.dialogContexts.reversed.map((e) => _convert(e)).expand((x) => x).toList();
      _refresh();
    } catch (e) {
      emit(CommonLoadError.any(e, isWeak: false));
    }
  }

  newChat() {
    _id = 0;
    _list = [];
    load();
  }

  List<BaseChatItemVo> _convert(DialogContext ctx) {
    var list = [
      AssistantTextChatItemVo(
        id: '${ctx.dialogDetailId}_assistant',
        text: ctx.replyContext,
        createStatus:
            ctx.traced == 1 ? AssistantTextChatItemCreateStatus.traced : AssistantTextChatItemCreateStatus.finish,
      ),
      UserChatItemVo(
        id: '${ctx.dialogDetailId}_user',
        name: Constant.user?.nickname ?? '用户',
        avatarUrl: Constant.user?.avatar ?? '',
        text: ctx.question,
        imageUrl: ctx.imageUrl
      ),
    ];
    final createTime = ctx.createdTime;
    if (createTime != null) {
      // convert to 2025年03月03日 10:10
      final timeStr = DateFormat('yyyy年MM月dd日 HH:mm').format(createTime);
      list.add(TimeChatItemVo(time: timeStr, id: '${ctx.dialogDetailId}_time'));
    }
    return list;
  }

  loadMore() async {
    _page++;
    // final newList = [
    //   ..._list,
    //   ..._list,    ];
    // _list = newList;
    _status = _page < 1 ? CommonListStatus.loadMore : CommonListStatus.noMore;
    _refresh();
  }

  changeModelType(ChatModelType type) {
    _modelType = type;
    _refresh();
  }

  stopCreating() {
    _list = _list.map((e) {
      if (e is AssistantTextChatItemVo && e.createStatus == AssistantTextChatItemCreateStatus.creating) {
        return e.copyWith(createStatus: AssistantTextChatItemCreateStatus.pause);
      } else {
        return e;
      }
    }).toList();
    _refresh();
  }

  continueCreating() {
    _list = _list.map((e) {
      if (e is AssistantTextChatItemVo && e.createStatus == AssistantTextChatItemCreateStatus.pause) {
        return e.copyWith(createStatus: AssistantTextChatItemCreateStatus.creating);
      }
      return e;
    }).toList();
    _refresh();
  }

  _refresh({List<BaseChatItemVo>? vos}) {
    emit(ChatLoaded(vos: vos ?? _list, modelType: _modelType, title: _title, status: _status, hintVo: null));
  }

  Future<void> trace(String id, bool traced) async {
    try {
      emit(CommonLoading(isWeak: true));
      final detailId = id.split('_').first;
      final url = 'dialog/trace/$detailId';
      final RespNoData resp;
      if (traced) {
        resp = await DioClient.post(url, deserializer: (json) => RespNoData.fromJson(json));
      } else {
        resp = await DioClient.put(url, deserializer: (json) => RespNoData.fromJson(json));
      }
      if (resp.error()) {
        emit(CommonLoadError.any(resp.message, isWeak: true));
        return;
      }
      final index = _list.indexWhere((e) => e.id == id);
      if (index == -1) return;
      final item = _list[index];
      if (item is AssistantTextChatItemVo) {
        _list[index] = item.copyWith(
          createStatus: traced ? AssistantTextChatItemCreateStatus.traced : AssistantTextChatItemCreateStatus.finish,
        );
      }
      _refresh();
    } catch (e) {
      debugPrint('trace失败: $e');
      emit(CommonLoadError.any(e, isWeak: true));
    }
  }

  var _tempCtxId = 1000;

  send({String? text, String? imagePath, bool online = false}) async {
    try {
      _tempCtxId++;
      if (imagePath != null && online) {
        SmartDialog.showNotify(msg: '不可同时上传图片和联网K线图', notifyType: NotifyType.warning);
        return;
      }

      // 1. 先上传图片获取imageUrl
      String? imageUrl;
      if (imagePath != null) {
        try {
          emit(CommonLoading(isWeak: true, msg: '上传图片中'));
          // 上传图片文件
          final rawResp = await DioClient.uploadFile(
            'file/upload',
            filePath: imagePath,
            fileKey: 'file',
            queryParameters: {'desc': '聊天图片'}, // 添加desc参数
          );

          final resp = RespWithData.fromJsonSimple(rawResp.data, (jsonT) => jsonT as String?);

          if (resp.error()) {
            emit(CommonLoadError.any(resp.message, isWeak: true));
            return;
          }
          imageUrl = resp.data;
          debugPrint('图片地址: $imageUrl');
        } catch (e) {
          debugPrint('图片上传失败: $e');
          SmartDialog.showNotify(msg: '图片上传失败: ${e.toString()}', notifyType: NotifyType.failure);
        }
      }
      // imageUrl = 'https://tkstock.oss-cn-beijing.aliyuncs.com/a56efe2e-566f-4f92-b180-aa811bd7844f.jpg';

      // 2. 添加用户消息到列表中
      if (text != null || imageUrl != null) {
        _list.insert(
            0,
            UserChatItemVo(
              id: '${_tempCtxId}_user',
              name: Constant.user?.nickname ?? '用户',
              avatarUrl: Constant.user?.avatar ?? '',
              text: text ?? '',
              imageUrl: imageUrl,
            ),);
      }

      _refresh();
      await Future.delayed(Duration.zero);
      emit(CommonLoading(isWeak: true));
      if (_id == 0) {
        final resp = await DioClient.post(
          'dialog',
          data: {'modeType': 10},
          deserializer: (json) => RespWithData.fromJsonSimple(json, (simple) => simple as int),
        );
        _id = resp.data!;
      }
      var msg = '';
      var tempList = <BaseChatItemVo>[
            AssistantTextChatItemVo(
              id: '${_tempCtxId}_assistant',
              text: msg,
              createStatus: AssistantTextChatItemCreateStatus.creating,
            )
          ] +
          _list;
      _refresh(vos: tempList);
      final stream = chatCompletionStream(question: text, imageUrl: imageUrl, online: online ? 1 : 0);
      var streamDialogDetailId = 0;
      await for (final res in stream) {
        msg += res.text;
        streamDialogDetailId = res.dialogDetailId;
        var tempList = <BaseChatItemVo>[
              AssistantTextChatItemVo(
                id: '${streamDialogDetailId}_assistant',
                text: msg,
                createStatus: AssistantTextChatItemCreateStatus.creating,
              )
            ] +
            _list;
        _refresh(vos: tempList);
      }
      debugPrint('最终结果：$msg');
      _list.insert(
          0,
          AssistantTextChatItemVo(
            id: '${streamDialogDetailId}_assistant',
            text: msg,
            createStatus: AssistantTextChatItemCreateStatus.finish,
          ));
      _refresh();
    } catch (e) {
      _refresh();
      emit(CommonLoadError.any(e, isWeak: true));
    } finally {
      SmartDialog.dismiss(status: SmartStatus.loading);
    }
  }

  // 创建 Dio 实例
  Dio _createDio() {
    return Dio(BaseOptions(
      baseUrl: 'https://api.tkstock.com/depth/',
      connectTimeout: const Duration(seconds: 3),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${Constant.token}'},
    ));
  }

  Stream<DialogResp> chatCompletionStream({
    String? question,
    String? imageUrl,
    int online = 0,
  }) async* {
    final dio = _createDio();

    // 设置响应类型为流
    final response = await dio.post(
      'dialog/ask/$_id',
      data: {'question': question, 'imageUrl': imageUrl, 'online': online},
      options: Options(responseType: ResponseType.stream, headers: {'Accept': 'text/event-stream'}),
    );

    final responseStream = response.data.stream as Stream<List<int>>;

    // 创建 buffer 来处理分块数据
    List<int> buffer = [];

    await for (final chunk in responseStream) {
      // print('接收chunk: $chunk');
      buffer.addAll(chunk);

      // 转换为字符串
      final String stringData = utf8.decode(buffer);
      // debugPrint('返回结果:$stringData');
      for (final line in stringData.split('\n')) {
        if (line.startsWith('data:')) {
          final text = line.substring(5); // 去掉 "data: "
          try {
            final dialogResp = DialogResp.fromJson(jsonDecode(text));
            yield dialogResp;
          } catch (e) {
            debugPrint('解析失败: $e');
          }
        }
      }

      // 清空 buffer
      buffer = [];
    }
  }
}

class DialogResp extends Equatable {
  final int dialogDetailId;
  final String text;

  const DialogResp({
    required this.dialogDetailId,
    required this.text,
  });

  factory DialogResp.fromJson(Map<String, dynamic> json) {
    return DialogResp(
      dialogDetailId: json['dialogDetailId'] as int,
      text: json['text'] as String,
    );
  }

  @override
  List<Object?> get props => [dialogDetailId, text];
}
