import 'package:equatable/equatable.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tkstock/common/ui/pressable.dart';
import 'package:tkstock/common/ui/screen_util.dart';
import 'package:tkstock/common/ui/std_color.dart';
import 'package:tkstock/common/util/keyboard_util.dart';


class RichTextVO extends Equatable {
  final String text;
  final Color color;
  final double size;

  const RichTextVO({
    required this.text,
    required this.color,
    required this.size,
  });

  @override
  List<Object?> get props => [text, color, size];
}

class UIUtil {
  UIUtil._();

  static Widget assetImage(
    String assetName, {
    double? width,
    double? height,
    BoxFit? fit,
    BoxShape? shape,
    BorderRadius? borderRadius,
  }) {
    if (width != null && height == null) {
      height = width;
    }
    return ExtendedImage.asset(
      'assets/img/$assetName',
      width: width,
      height: height,
      fit: fit,
      scale: 3,
      gaplessPlayback: true,
      shape: shape,
      borderRadius: borderRadius,
    );
  }

  static Text getText(
    String text, {
    double size = 15.0,
    Color color = StdColor.normalText,
    FontWeight weight = FontWeight.normal,
    int maxLines = 1,
    TextAlign? textAlign,
    String? fontFamily,
  }) {
    return Text(
      text,
      style: TextStyle(fontSize: size, color: color, fontWeight: weight, fontFamily: fontFamily),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  static Text getRichText(
    List<RichTextVO> children, {
    FontWeight? weight,
    TextAlign? textAlign,
  }) {
    return Text.rich(
      textAlign: textAlign,
      TextSpan(
        children: children.map((e) {
          return TextSpan(text: e.text, style: TextStyle(color: e.color, fontSize: e.size, fontWeight: weight));
        }).toList(),
      ),
    );
  }

  static SelectableText getSelectableText(
    String text, {
    double size = 15.0,
    Color color = StdColor.normalText,
    FontWeight weight = FontWeight.normal,
    int? maxLines,
    TextAlign? textAlign,
    String? fontFamily,
    bool enableCopy = true,
    bool enableSelectAll = true,
  }) {
    return SelectableText(
      text,
      style: TextStyle(fontSize: size, color: color, fontWeight: weight, fontFamily: fontFamily),
      maxLines: maxLines,
      textAlign: textAlign,
      toolbarOptions: ToolbarOptions(copy: enableCopy, selectAll: enableSelectAll),
      scrollPhysics: const NeverScrollableScrollPhysics(),
    );
  }

  static Widget getNetworkImage(
    String url, {
    double? width,
    double? height,
    BoxFit? fit,
    BoxShape? shape,
    BorderRadius? borderRadius,
    LoadStateChanged? loadStateChanged,
  }) {
    return ExtendedImage.network(
      url,
      width: width,
      height: height,
      fit: fit,
      shape: shape,
      borderRadius: borderRadius,
      gaplessPlayback: true,
      loadStateChanged: loadStateChanged,
    );
  }

  static Size boundingTextSize(String text, TextStyle style,
      {int maxLines = 2 ^ 31, double maxWidth = double.infinity}) {
    if (text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter =
        TextPainter(textDirection: TextDirection.ltr, text: TextSpan(text: text, style: style), maxLines: maxLines)
          ..layout(maxWidth: maxWidth);
    return textPainter.size;
  }

  static Widget getInputView({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    Color hintColor = Colors.black,
    double fontSize = 15,
    Color? bottomLineColor,
    double? width,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      width: width ?? (ScreenUtil.screenWidth - 80),
      height: 53,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: bottomLineColor ?? Colors.black.withValues(alpha: 0.18))),
      ),
      alignment: Alignment.bottomCenter,
      child: TextField(
        maxLines: 1,
        maxLength: maxLength,
        obscureText: obscureText,
        controller: controller,
        cursorColor: Colors.black,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          border: InputBorder.none,
          suffixIcon: suffixIcon,
          filled: true,
          hintText: hint,
          hintStyle: TextStyle(fontSize: fontSize, color: hintColor, fontWeight: FontWeight.normal),
          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
        ),
        style: TextStyle(fontSize: fontSize, color: StdColor.normalText),
        buildCounter: (context, {required currentLength, maxLength, required isFocused}) => null,
      ),
    );
  }

  static Pressable getBlackButton({required String title, required Function() onTap, double height = 48}) {
    return Pressable(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
          // boxShadow: const [BoxShadow(color: StdColor.c_808080, offset: Offset(0, 2), blurRadius: 15)],
        ),
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 40),
        alignment: Alignment.center,
        child: UIUtil.getText(title, size: 16),
      ),
    );
  }
}

extension WidgetExt on Widget {
  Widget padding(EdgeInsetsGeometry padding) => Padding(padding: padding, child: this);

  Widget paddingOnly({double? left, double? top, double? right, double? bottom}) => Padding(
        padding: EdgeInsets.only(left: left ?? 0, top: top ?? 0, right: right ?? 0, bottom: bottom ?? 0),
        child: this,
      );

  Widget paddingAll(double padding) => Padding(padding: EdgeInsets.all(padding), child: this);

  Widget paddingSymmetric({double? horizontal, double? vertical}) => Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontal ?? 0, vertical: vertical ?? 0),
        child: this,
      );

  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  Widget sizedBox({double? width, double? height}) => SizedBox(width: width, height: height, child: this);

  Widget positioned({double? left, double? top, double? right, double? bottom}) => Positioned(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        child: this,
      );

  Widget pressable(Function() onTap, {bool enable = true}) => Pressable(onTap: onTap, enable: enable, child: this);

  Widget route(BuildContext context, {required String routeName, Object? arguments}) => Pressable(
        onTap: () => Navigator.of(context).pushNamed(routeName, arguments: arguments),
        child: this,
      );

  Widget visible(bool visible) => Visibility(visible: visible, child: this);

  Widget routeName(BuildContext context, String routeName, {Object? arguments}) =>
      Pressable(onTap: () => Navigator.of(context).pushNamed(routeName, arguments: arguments), child: this);

  Widget hideKeyboard() => GestureDetector(
        onTap: KeyboardUtil.hideKeyboard,
        child: Container(color: Colors.transparent, child: this),
      );

  Widget color(Color color) => ColoredBox(color: color, child: this);

  Widget center() => Center(child: this);
}

extension ColorExt on Color {
  static Color fromHex(String hex) {
    final value = int.tryParse(hex.replaceAll('#', '0xFF'));
    return value == null ? Colors.green : Color(value);
  }
}

extension StringExt on String? {
  bool get notNullAndEmpty => this != null && this!.isNotEmpty;
}
