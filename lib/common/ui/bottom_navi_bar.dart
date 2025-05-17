import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:tkstock/common/constant.dart';
import 'package:tkstock/common/ui/pressable.dart';
import 'package:tkstock/common/ui/screen_util.dart';
import 'package:tkstock/common/ui/std_color.dart';
import 'package:tkstock/common/util/event_bus_util.dart';
import 'package:tkstock/common/util/ui_util.dart';
import 'package:tkstock/route/route_url.dart';

class _BottomItemView extends StatelessWidget {
  final String title;
  final String iconName;
  final bool selected;
  final Function() onTap;

  const _BottomItemView({
    required this.title,
    required this.iconName,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Pressable(
      onTap: onTap,
      child: Container(
        width: screenWidth / 6,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(selected ? StdColor.highlight : const Color(0xFF9F9F9F), BlendMode.srcIn),
              child: ExtendedImage.asset(iconName, width: 18, height: 18),
            ),
            UIUtil.getText(title, size: 9, color: selected ? StdColor.highlight : const Color(0xFF9F9F9F)),
          ],
        ),
      ),
    );
  }
}

enum BottomNaviType {
  home,
  market,
  trade,
  user;

  String get title {
    switch (this) {
      case BottomNaviType.home:
        return '首页';
      case BottomNaviType.market:
        return '行情';
      case BottomNaviType.trade:
        return '交易';
      case BottomNaviType.user:
        return '我的';
    }
  }

  String get normalIconKey {
    switch (this) {
      case BottomNaviType.home:
        return 'ic_home.png';
      case BottomNaviType.market:
        return 'ic_market.png';
      case BottomNaviType.trade:
        return 'ic_trade.png';
      case BottomNaviType.user:
        return 'ic_user.png';
    }
  }
}

class BottomNaviBar extends StatefulWidget {
  final BottomNaviType curType;
  final Function(BottomNaviType) onTabChange;

  static const double _contentHeight = 49.0;

  static double get height => _contentHeight + ScreenUtil.bottomPadding;

  const BottomNaviBar({super.key, required this.curType, required this.onTabChange});

  @override
  State<StatefulWidget> createState() => _BottomNaviBarState();
}

class _BottomNaviBarState extends State<BottomNaviBar> {
  List<StreamSubscription>? _subscriptions;

  @override
  void initState() {
    super.initState();
    _subscriptions = [];
  }

  @override
  void dispose() {
    _subscriptions?.forEach((element) => element.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.only(bottom: bottomPadding),
      height: 49 + bottomPadding,
      decoration: BoxDecoration(
        color: StdColor.c_FBFBFE,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, -1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          const Spacer(flex: 1),
          _buildItem(type: BottomNaviType.home, onTap: () => widget.onTabChange(BottomNaviType.home)),
          const Spacer(flex: 2),
          _buildItem(type: BottomNaviType.market, onTap: () => widget.onTabChange(BottomNaviType.market)),
          const Spacer(flex: 2),
          Pressable(
            onTap: () async {
              if (!Constant.isLogin()) {
                Navigator.pushNamed(context, RouteUrl.login);
                return;
              }
              await Navigator.pushNamed(context, RouteUrl.chat);
              EventBusUtil.fire(ChatUpdateEvent());
            },
            child: Icon(Icons.add_circle, size: 27, color: StdColor.highlight),
          ),
          const Spacer(flex: 2),
          _buildItem(type: BottomNaviType.trade, onTap: () => widget.onTabChange(BottomNaviType.trade)),
          const Spacer(flex: 2),
          _buildItem(type: BottomNaviType.user, onTap: () => widget.onTabChange(BottomNaviType.user)),
          const Spacer(flex: 1),
        ],
      ),
    );
  }

  Widget _buildItem({
    required BottomNaviType type,
    required Function() onTap,
  }) {
    final selected = type == widget.curType;
    return _BottomItemView(
      title: type.title,
      iconName: 'assets/img/main/${type.normalIconKey}',
      selected: selected,
      onTap: onTap,
    );
  }
}
