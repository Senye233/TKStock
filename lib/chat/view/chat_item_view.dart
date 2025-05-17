import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tkstock/chat/cubit/chat_cubit.dart';
import 'package:tkstock/chat/model/vo.dart';
import 'package:tkstock/common/image/image_preview_page.dart';
import 'package:tkstock/common/ui/pressable.dart';
import 'package:tkstock/common/ui/screen_util.dart';
import 'package:tkstock/common/ui/std_color.dart';
import 'package:tkstock/common/util/ui_util.dart';

class ChatItemView extends StatelessWidget {
  final BaseChatItemVo vo;
  final Function(String) switchPlayTTS;

  const ChatItemView({super.key, required this.vo, required this.switchPlayTTS});

  @override
  Widget build(BuildContext context) {
    if (vo is TimeChatItemVo) {
      return Container(
        alignment: Alignment.center,
        child: UIUtil.getText((vo as TimeChatItemVo).time, size: 11, color: const Color(0xFFABABAB)),
      );
    }
    final chatCubit = context.read<ChatCubit>();
    if (vo is UserChatItemVo) {
      final userVo = vo as UserChatItemVo;
      final imageUrl = userVo.imageUrl;
      return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          UIUtil.getText(userVo.name, size: 15, color: StdColor.c_282828),
          const SizedBox(width: 10),
          ExtendedImage.network(
            userVo.avatarUrl ?? '',
            width: 28,
            height: 28,
            fit: BoxFit.cover,
            shape: BoxShape.circle,
            loadStateChanged: (state) {
              if (state.extendedImageLoadState == LoadState.completed) {
                return state.completedWidget;
              }
              return Icon(
                Icons.account_circle,
                size: 28,
                color: const Color(0xFFABABAB),
              );
            },
          ),
        ]),
        const SizedBox(height: 10),
        Container(
          constraints: BoxConstraints(maxWidth: ScreenUtil.screenWidth * 0.75),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (userVo.text.isNotEmpty) UIUtil.getSelectableText(userVo.text, size: 15, color: StdColor.c_282828),
              if (imageUrl != null && imageUrl.isNotEmpty) ...[
                if (userVo.text.isNotEmpty) const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Hero(
                    tag: imageUrl,
                    child: ExtendedImage.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      constraints: BoxConstraints(
                        maxWidth: ScreenUtil.screenWidth * 0.6,
                        maxHeight: ScreenUtil.screenWidth * 0.6,
                      ),
                      loadStateChanged: (state) {
                        if (state.extendedImageLoadState == LoadState.completed) {
                          return state.completedWidget;
                        }
                        return Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey.withValues(alpha: 0.3),
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                  ).pressable(() => ImagePreviewPage.show(context, imageUrl)),
                ),
              ],
            ],
          ),
        ),
      ]);
    }
    final showPauseHint = (vo is AssistantTextChatItemVo) && (vo as AssistantTextChatItemVo).isPause;
    final assistantHeader = Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      UIUtil.assetImage('main/ic_logo.jpg', width: 28, shape: BoxShape.circle, borderRadius: BorderRadius.circular(14)),
      const SizedBox(width: 10),
      UIUtil.getText('小娲牛', size: 15, color: StdColor.c_282828),
      UIUtil.getText(' (已暂停生成)', size: 12, color: StdColor.c_282828).visible(showPauseHint),
    ]);
    if (vo is AssistantTextChatItemVo) {
      final assistantVo = vo as AssistantTextChatItemVo;
      final showTools = assistantVo.isFinish || assistantVo.isTraced;
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        assistantHeader,
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            UIUtil.getSelectableText(assistantVo.text, size: 15, color: StdColor.c_282828),
            const SizedBox(height: 10),
            Container(height: 1, color: const Color(0xFFF4F6FA)),
            const SizedBox(height: 10),
            Row(children: [
              UIUtil.assetImage('chat/btn_refresh.png').visible(showTools),
              const SizedBox(width: 24),
              UIUtil.assetImage('chat/btn_play_voice.png')
                  .pressable(() => switchPlayTTS(assistantVo.text))
                  .visible(showTools),
              const SizedBox(width: 24),
              UIUtil.assetImage('chat/btn_hand_good.png').visible(showTools),
              const SizedBox(width: 24),
              UIUtil.assetImage('chat/btn_hand_bad.png').visible(showTools),
              const Spacer(),
              Pressable(
                onTap: () {
                  switch (assistantVo.createStatus) {
                    case AssistantTextChatItemCreateStatus.creating:
                      return;
                    case AssistantTextChatItemCreateStatus.pause:
                      chatCubit.continueCreating();
                    case AssistantTextChatItemCreateStatus.finish:
                      chatCubit.trace(vo.id, true);
                    case AssistantTextChatItemCreateStatus.traced:
                      chatCubit.trace(vo.id, false);
                  }
                },
                child: Container(
                  height: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: assistantVo.createStatus.bottomRightDecoration,
                  alignment: Alignment.center,
                  child: UIUtil.getText(
                    assistantVo.createStatus.bottomRightText,
                    size: 13,
                    color: assistantVo.createStatus.bottomRightTextColor,
                  ),
                ),
              ).visible(!assistantVo.isCreating),
            ]).sizedBox(height: 24),
          ]),
        ),
        const SizedBox(height: 10),
        UIUtil.getText('(内容仅供参考，不构成投资建议）', size: 12, color: const Color(0xFF808080).withValues(alpha: 0.55)),
      ]);
    }
    if (vo is AssistantAdviceChatItemVo) {
      final adviceVo = vo as AssistantAdviceChatItemVo;
      final hintFontColor = const Color(0xFF3C3C43).withValues(alpha: 0.3);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          assistantHeader,
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(children: [
              Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  UIUtil.getText('小娲牛', size: 15, color: StdColor.c_282828, weight: FontWeight.bold),
                  UIUtil.getText(adviceVo.code, size: 10, color: StdColor.c_999999),
                ]),
                const Spacer(),
                UIUtil.assetImage(adviceVo.type.assetName),
                const SizedBox(width: 44),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Row(children: [
                    UIUtil.getText(
                      adviceVo.price.toString(),
                      size: 15,
                      weight: FontWeight.bold,
                      color: adviceVo.type.priceColor,
                    ),
                    UIUtil.assetImage('chat/ic_arrow_right.png'),
                  ]),
                  UIUtil.getText('当前价格', size: 10, color: StdColor.c_999999).paddingOnly(right: 16),
                ]),
              ]),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFF4F6FA)),
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 77,
                child: Row(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UIUtil.getText('综合评分', size: 13, color: hintFontColor),
                      const SizedBox(height: 4),
                      UIUtil.getText(
                        '${adviceVo.totalScore}分',
                        size: 15,
                        color: const Color(0xFF007AFF),
                        weight: FontWeight.bold,
                      ),
                    ],
                  ).center().expanded(),
                  Container(
                    width: 1,
                    height: 46,
                    color: const Color(0xFFF4F6FA),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UIUtil.getText('支撑位', size: 13, color: hintFontColor),
                      const SizedBox(height: 4),
                      UIUtil.getText(
                        adviceVo.supportScore.toString(),
                        size: 15,
                        color: adviceVo.type == ChatAdviceType.buy ? StdColor.highlight : StdColor.c_282828,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ).center().expanded(),
                  Container(
                    width: 1,
                    height: 46,
                    color: const Color(0xFFF4F6FA),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UIUtil.getText('压力位', size: 13, color: hintFontColor),
                      const SizedBox(height: 4),
                      UIUtil.getText(
                        '${adviceVo.reitScore}',
                        size: 15,
                        color: StdColor.c_282828,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ).center().expanded(),
                ]),
              ),
              const SizedBox(height: 5),
              Row(children: [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  UIUtil.getText('参考来源', size: 12, color: hintFontColor),
                  RotatedBox(quarterTurns: 1, child: UIUtil.assetImage('chat/ic_arrow_right.png')),
                ]),
                const Spacer(),
                UIUtil.getText(adviceVo.date.toString(), size: 12, color: hintFontColor),
              ]),
            ]),
          ),
          const SizedBox(height: 10),
          UIUtil.getText('(内容仅供参考，不构成投资建议）', size: 12, color: const Color(0xFF808080).withValues(alpha: 0.55)),
        ],
      );
    }
    return Container();
  }
}
