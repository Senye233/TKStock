import 'package:equatable/equatable.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tkstock/chat/model/vo.dart';
import 'package:tkstock/common/ui/std_color.dart';
import 'package:tkstock/common/util/ui_util.dart';

class HomeItemView extends StatelessWidget {
  final HomeItemVo vo;

  const HomeItemView({super.key, required this.vo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(children: [
        _buildIconView(),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                UIUtil.getText(vo.name, size: 15, color: StdColor.c_282828),
                const SizedBox(width: 8),
                UIUtil.getText(vo.code, size: 12, color: StdColor.c_999999),
                const Spacer(),
                UIUtil.assetImage(
                  vo.adviceType == ChatAdviceType.buy ? 'home/ic_buy.png' : 'home/ic_sell.png',
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 15),
                UIUtil.getText(vo.date, size: 12, color: StdColor.c_999999),
              ],
            ).sizedBox(height: 18),
            const SizedBox(height: 3),
            UIUtil.getText(vo.desc, size: 13, color: const Color(0xFF828282)),
          ],
        ).expanded(),
      ]),
    );
  }

  Widget _buildIconView() {
    const size = 38.0;
    const borderRadius = 4.0;
    final iconUrl = vo.iconUrl;
    if (iconUrl == null) {
      // 取名称第一个汉字加随机背景色
      final firstChar = vo.name.substring(0, 1);
      // 使用名称的哈希码生成固定颜色，确保同名同色
      final nameHash = vo.name.hashCode;
      final colorValue = 0xFF000000 | (nameHash & 0xFFFFFF);
      final nameColor = Color(colorValue);
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: nameColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        alignment: Alignment.center,
        child: Text(firstChar, style: const TextStyle(color: Colors.white, fontSize: 16)),
      );
    }
    return ExtendedImage.network(
      iconUrl,
      width: size,
      height: size,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(borderRadius),
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return SpinKitCircle(size: 24, color: StdColor.c_282828).center();
          case LoadState.failed:
            return Container(color: const Color(0xFFFFE5C8));
          case LoadState.completed:
            return state.completedWidget;
        }
      },
    );
  }
}

class HomeItemVo extends Equatable {
  final int dialogId;
  final int hitStockId;
  final String name;
  final String code;
  final String date;
  final String desc;
  final String? iconUrl;
  final ChatAdviceType adviceType;
  final bool isTop;

  const HomeItemVo({
    required this.dialogId,
    required this.hitStockId,
    required this.name,
    required this.code,
    required this.date,
    required this.desc,
    required this.iconUrl,
    required this.adviceType,
    required this.isTop,
  });

  @override
  List<Object?> get props => [dialogId, hitStockId, name, code, date, desc, iconUrl, adviceType, isTop];
}
