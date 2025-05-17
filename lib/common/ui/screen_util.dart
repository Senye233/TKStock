import 'package:flutter/widgets.dart';

class ScreenUtil {
  ScreenUtil._();

  static double _screenWidth = 0.0;
  static double _screenHeight = 0.0;
  static double _contentHeight = 0.0;
  static double _topPadding = 0.0;
  static double _bottomPadding = 0.0;

  static void init(BuildContext context) {
    final query = MediaQuery.of(context);
    _screenWidth = query.size.width;
    _screenHeight = query.size.height;
    _contentHeight = _screenHeight - query.padding.top;
    _topPadding = query.padding.top;
    _bottomPadding = query.padding.bottom;
  }

  static double get screenWidth => _screenWidth;

  static double get screenHeight => _screenHeight;

  static double get contentHeight => _contentHeight;

  static double get topPadding => _topPadding;

  static double get bottomPadding => _bottomPadding;
}
