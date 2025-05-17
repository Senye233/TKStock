import 'package:flutter/material.dart';
import 'package:tkstock/common/ui/pressable.dart';
import 'package:tkstock/common/ui/screen_util.dart';
import 'package:tkstock/common/ui/std_color.dart';
import 'package:tkstock/common/util/ui_util.dart';

class TitleNavigation extends StatelessWidget {
  final String title;
  final Widget? leftWidget;
  final Widget? rightWidget;

  const TitleNavigation({super.key, required this.title, this.leftWidget, this.rightWidget});

  static double contentHeight = 42;

  static double get height => contentHeight + ScreenUtil.topPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.only(top: ScreenUtil.topPadding),
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          UIUtil.getText(title, size: 16, color: StdColor.c_282828, weight: FontWeight.w600),
          if (leftWidget != null)
            leftWidget!.positioned(left: 0)
          else
            ReturnPressable(child: UIUtil.assetImage('chat/btn_back.png').paddingOnly(left: 10)).positioned(left: 0),
          if (rightWidget != null) rightWidget!.positioned(right: 0),
        ],
      ),
    );
  }
}
