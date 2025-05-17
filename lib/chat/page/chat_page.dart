import 'dart:io';
import 'dart:math';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tkstock/chat/cubit/chat_cubit.dart';
import 'package:tkstock/chat/view/chat_item_view.dart';
import 'package:tkstock/common/image/image_preview_page.dart';
import 'package:tkstock/common/ui/base_state.dart';
import 'package:tkstock/common/ui/cubit_page_state.dart';
import 'package:tkstock/common/ui/pressable.dart';
import 'package:tkstock/common/ui/screen_util.dart';
import 'package:tkstock/common/ui/std_color.dart';
import 'package:tkstock/common/ui/title_navigation.dart';
import 'package:tkstock/common/util/ui_util.dart';
import 'package:tkstock/route/route_url.dart';


class ChatPage extends StatefulWidget {
  final String? title;

  const ChatPage({super.key, this.title});

  @override
  State<ChatPage> createState() => _ChatPageState();

  static Widget create(RouteChatArg? arg) => BlocProvider(
        create: (_) => ChatCubit(arg?.id ?? 0),
        child: ChatPage(title: arg?.name),
      );
}

class _ChatPageState extends CubitPageState<ChatPage, ChatCubit> {
  @override
  Color get bgColor => StdColor.c_F4F6FA;

  @override
  bool get withSafeArea => false;

  final _refreshController = EasyRefreshController(controlFinishRefresh: true, controlFinishLoad: true);
  final _listController = ScrollController();
  final _modelKey = GlobalKey();
  var _sendBtnHighlight = false;

  @override
  void initState() {
    super.initState();
    _listController.addListener(() {
      _hideKeyboard();
    });
    _textController.addListener(() {
      setState(() => _sendBtnHighlight = _textController.text.isNotEmpty);
    });
    // _textController.text = '我想查询平安银行和600000以及万科A的股票';
    // _selectNetwork = true;
  }

  @override
  void dispose() {
    _listController.dispose();
    _refreshController.dispose();
    _textController.dispose();
    // _tts.stop();
    super.dispose();
  }

  @override
  listener(BuildContext context, BaseState state) {
    super.listener(context, state);
    if (state is ChatLoaded) {
      switch (state.status) {
        case CommonListStatus.refresh:
          _refreshController.finishRefresh();
          break;
        case CommonListStatus.loadMore:
          _refreshController.finishLoad();
          break;
        case CommonListStatus.loadMoreError:
          _refreshController.finishLoad(IndicatorResult.fail);
          break;
        case CommonListStatus.noMore:
          _refreshController.finishLoad(IndicatorResult.noMore);
          break;
      }
    }
  }

  // final _tts = FlutterTts();

  _switchPlayTTS(String text) async {
    // await _tts.stop();
    // await _tts.speak(text);
  }

  double get bottomPadding {
    if (Platform.isAndroid) {
      return max(ScreenUtil.bottomPadding, 18);
    }
    return ScreenUtil.bottomPadding;
  }

  @override
  Widget? buildTitleBar() => TitleNavigation(title: widget.title ?? '新对话');

  @override
  Widget buildContent(BuildContext context, BaseState state) {
    if (state is! ChatLoaded) {
      return Container();
    }
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(children: [
          _buildContentView(state).expanded(),
          _buildInputView(state),
        ]).sizedBox(width: double.infinity),
        _buildHintView(state),
        _buildSelectModelPop(),
        _buildImagePreview(),
        _buildNewChatView(),
      ],
    );
  }

  _showSelectModelPop() {
    final renderBox = _modelKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;
    setState(() => _showSelectModelWidth = renderBox.size.width);
  }

  Widget _buildSelectModelPop() {
    if (_showSelectModelWidth == 0) return Container();
    return Stack(
      children: [
        Container(
          color: Colors.transparent,
        ).pressable(() => setState(() => _showSelectModelWidth = 0)),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 4),
          width: _showSelectModelWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              UIUtil.assetImage(ChatModelType.chatGPT.assetName),
              const SizedBox(width: 5),
              UIUtil.getText(ChatModelType.chatGPT.title, size: 13, color: const Color(0xFF1C1B1F)),
            ]).pressable(() => _switchModelType(ChatModelType.chatGPT)),
            UIUtil.assetImage('chat/ic_unlock_model.png').paddingOnly(left: 17),
            const SizedBox(height: 10),
            Row(children: [
              UIUtil.assetImage(ChatModelType.deepSeekR1.assetName),
              const SizedBox(width: 5),
              UIUtil.getText(ChatModelType.deepSeekR1.title, size: 13, color: const Color(0xFF1C1B1F)),
              const Spacer(),
              RotatedBox(quarterTurns: 2, child: UIUtil.assetImage('chat/ic_arrow_down.png')),
            ]).pressable(() => _switchModelType(ChatModelType.deepSeekR1)),
            UIUtil.getText('30次', size: 11, color: const Color(0xFFFFD646), weight: FontWeight.bold)
                .paddingOnly(left: 21),
          ]),
        ).positioned(left: 13, bottom: bottomPadding),
      ],
    );
  }

  Widget _buildHintView(ChatLoaded state) {
    if (state.hintVo == null) return Container();
    return Container(
      height: 39,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFFFDBC1), Color(0xFFF6EAD5)],
        ),
      ),
      child: Row(
        children: [
          UIUtil.assetImage('home/ic_hint.png'),
          const SizedBox(width: 5),
          UIUtil.getText(state.hintVo!.title, size: 14, color: StdColor.c_282828),
          const SizedBox(width: 14),
          UIUtil.getText(state.hintVo!.percent, size: 14, color: StdColor.highlight),
          const Spacer(),
          Container(
            width: 59,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [StdColor.highlight, Color(0xFFFFAA77)],
              ),
            ),
            alignment: Alignment.center,
            child: UIUtil.getText('看持仓', size: 14, color: Colors.white),
          ),
          const SizedBox(width: 14),
        ],
      ),
    ).positioned(top: 6, left: 13, right: 13);
  }

  _switchModelType(ChatModelType type) {
    setState(() => _showSelectModelWidth = 0);
    cubit.changeModelType(type);
  }

  Widget _buildContentView(ChatLoaded state) {
    if (state.vos.isEmpty) {
      const fontColor = Color(0xFF454545);
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        UIUtil.assetImage('main/ic_logo.jpg', width: 68, shape: BoxShape.circle, borderRadius: BorderRadius.circular(34)),
        const SizedBox(height: 28),
        UIUtil.getText('嗨！我是股票深度追踪AI助手', size: 18, color: fontColor, weight: FontWeight.bold),
        const SizedBox(height: 16),
        UIUtil.getText('中国巴菲特，从小做起！', size: 15, color: fontColor),
        const SizedBox(height: 6),
        UIUtil.getText('(仅提供分析框架，不构成投资建议）', size: 12, color: const Color(0xFF808080)),
      ]);
    }
    return EasyRefresh(
      controller: _refreshController,
      onLoad: cubit.loadMore,
      footer: CupertinoFooter(),
      child: ListView.separated(
        controller: _listController,
        reverse: true,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 52),
        itemBuilder: (context, index) {
          return ChatItemView(vo: state.vos[index], switchPlayTTS: _switchPlayTTS);
        },
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemCount: state.vos.length,
      ),
    );
  }

  Widget _buildNewChatView() {
    return Container(
      width: 105,
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF767680).withValues(alpha: 0.12)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(children: [
        const SizedBox(width: 8),
        Icon(Icons.add, size: 16),
        const SizedBox(width: 4),
        UIUtil.getText('开启新对话', size: 13, color: StdColor.c_282828).pressable(cubit.newChat),
      ]),
    ).positioned(bottom: 117 + ScreenUtil.bottomPadding / 2 + (_showAddTools ? _addToolsHeight : 0));
  }

  final _textController = TextEditingController();
  var _showSelectModelWidth = 0.0;
  var _showAddTools = false;
  final _addToolsHeight = 64.0;
  var _selectNetwork = false;
  final _textFocusNode = FocusNode();

  Widget _buildInputView(ChatLoaded state) {
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(maxHeight: 70, minHeight: 44),
          margin: const EdgeInsets.symmetric(horizontal: 13),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(22)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: TextField(
            focusNode: _textFocusNode,
            textAlignVertical: TextAlignVertical.center,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: _textController,
            decoration: InputDecoration(
              hintStyle: TextStyle(fontSize: 15, color: const Color(0xFF999999)),
              hintText: '',
              isCollapsed: true,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            ),
            style: const TextStyle(fontSize: 15, color: StdColor.c_282828),
          ),
        ),
        const SizedBox(height: 10),
        Row(children: [
          const SizedBox(width: 13),
          RepaintBoundary(
            key: _modelKey,
            child: Container(
              height: 28,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: Row(children: [
                const SizedBox(width: 10),
                UIUtil.assetImage(state.modelType.assetName),
                const SizedBox(width: 5),
                UIUtil.getText(state.modelType.title, size: 13, color: const Color(0xFF1C1B1F)),
                const SizedBox(width: 5),
                RotatedBox(
                  quarterTurns: _showSelectModelWidth == 0 ? 2 : 0,
                  child: UIUtil.assetImage('chat/ic_arrow_down.png'),
                ),
                const SizedBox(width: 10),
              ]),
            ).pressable(_showSelectModelPop),
          ),
          const SizedBox(width: 16),
          Container(
            height: 28,
            decoration: BoxDecoration(
              color: _selectNetwork ? const Color(0xFFFFE6C8) : Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(children: [
              const SizedBox(width: 10),
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  _selectNetwork ? StdColor.highlight : Colors.black,
                  BlendMode.srcIn,
                ),
                child: UIUtil.assetImage('chat/ic_network.png'),
              ),
              const SizedBox(width: 5),
              UIUtil.getText('联网k线图', size: 13, color: _selectNetwork ? StdColor.highlight : const Color(0xFF1C1B1F)),
              const SizedBox(width: 10),
            ]),
          ).pressable(() => setState(() => _selectNetwork = !_selectNetwork)),
          const Spacer(),
          UIUtil.assetImage('chat/btn_add.png').pressable(() {
            _hideKeyboard();
            setState(() => _showAddTools = !_showAddTools);
          }),
          const SizedBox(width: 16),
          Pressable(
            enable: _sendBtnHighlight || state.isCreating,
            onTap: () {
              if (state.isCreating) {
                return;
                // cubit.stopCreating();
              } else {
                cubit.send(text: _textController.text, imagePath: _pickedImage?.path, online: _selectNetwork);
                _hideKeyboard();
                setState(() {
                  _textController.text = '';
                  _pickedImage = null;
                });
              }
            },
            child: _buildSendButton(state),
          ),
          const SizedBox(width: 13),
        ]),
        Offstage(
          offstage: !_showAddTools,
          child: Row(children: [
            Container(
              height: _addToolsHeight,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.camera_alt_outlined, size: 24),
                const SizedBox(width: 3),
                UIUtil.getText('拍照识文', size: 13, color: const Color(0xFF1C1B1F)),
              ]),
            ).pressable(_getImageFromCamera).expanded(),
            const SizedBox(width: 11),
            Container(
              height: _addToolsHeight,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.add_photo_alternate_outlined, size: 24),
                const SizedBox(width: 3),
                UIUtil.getText('图片识文', size: 13, color: const Color(0xFF1C1B1F)),
              ]),
            ).pressable(_getImageFromGallery).expanded(),
          ]).paddingOnly(top: 10, left: 13, right: 13),
        ),
        SizedBox(height: ScreenUtil.bottomPadding),
        if (Platform.isAndroid) SizedBox(height: 20),
      ],
    ).sizedBox(width: double.infinity);
  }

  _hideKeyboard() {
    _textFocusNode.unfocus();
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _getImageFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        _processPickedImage(photo);
      }
    } catch (e) {
      SmartDialog.showNotify(msg: '拍照失败: $e', notifyType: NotifyType.error);
    }
  }

  Future<void> _getImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _processPickedImage(image);
      }
    } catch (e) {
      SmartDialog.showNotify(msg: '选择图片失败: $e', notifyType: NotifyType.error);
    }
  }

  XFile? _pickedImage;

  void _processPickedImage(XFile image) async {
    setState(() => _showAddTools = false);
    try {
      setState(() {
        _pickedImage = image;
        _sendBtnHighlight = true;
      });
    } catch (e) {
      // 处理异常情况
      SmartDialog.showToast('处理图片时出错: $e');
    }
  }

  Widget _buildImagePreview() {
    if (_pickedImage == null) return Container();
    return Stack(alignment: Alignment.center, clipBehavior: Clip.none, children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
      ),
      Hero(
        tag: _pickedImage!.path,
        child: ExtendedImage.file(File(_pickedImage!.path), width: 22, height: 26, fit: BoxFit.cover),
      ).pressable(() => ImagePreviewPage.show(context, _pickedImage!.path)),
      UIUtil.assetImage('chat/btn_close.png')
          .pressable(() => setState(() => _pickedImage = null))
          .positioned(top: -2, right: -2),
    ]).sizedBox(width: 50, height: 48).positioned(left: 13, bottom: 117 + ScreenUtil.bottomPadding / 2);
  }

  Widget _buildSendButton(ChatLoaded state) {
    if (state.isCreating) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(color: const Color(0xFF8A63FF), borderRadius: BorderRadius.circular(12)),
        alignment: Alignment.center,
        child: Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2)),
        ),
      );
    } else {
      return UIUtil.assetImage(_sendBtnHighlight ? 'chat/btn_send_highlight.png' : 'chat/btn_send.png');
    }
  }
}
