import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tkstock/common/ui/bottom_navi_bar.dart';
import 'package:tkstock/common/util/keyboard_util.dart';
import 'package:tkstock/common/util/ui_util.dart';
import 'package:tkstock/home/page/home_page.dart';
import 'package:tkstock/market/page/market_page.dart';
import 'package:tkstock/route/no_animation_route.dart';
import 'package:tkstock/route/route_url.dart';
import 'package:tkstock/user/page/user_page.dart';
import 'package:tkstock/welcome_page.dart';

import 'common/constant.dart';


class MainPage extends StatefulWidget {
  final String restorationId = 'main';

  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with RestorationMixin {
  final _currentIndex = RestorableInt(0);

  List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();
    _subscriptions = [];
    _checkPopPage();
  }

  _checkPopPage() async {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      if (!Constant.showWelcome) {
        await Navigator.push(context, NoAnimationRoute(page: const WelcomePage()));
        if (!mounted || Constant.isLogin()) return;
        Navigator.pushNamed(context, RouteUrl.login);
      } else if (!Constant.isLogin()) {
        Navigator.pushNamed(context, RouteUrl.login);
      }
    });
  }

  @override
  void dispose() {
    for (var element in _subscriptions) {
      element.cancel();
    }
    _subscriptions.clear();
    super.dispose();
  }

  @override
  String get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_currentIndex, "bottom_navigation_tab_index");
  }

  final _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              HomePage.create(),
              MarketPage.create(),
              // Center(child: Text('行情')),
              Center(child: Text('交易')),
              UserPage(),
            ],
          ).expanded(),
          BottomNaviBar(
            curType: BottomNaviType.values[_currentIndex.value],
            onTabChange: (type) => _jumpToPage(type.index),
          ),
        ],
      ),
    );
  }

  void _jumpToPage(int index) async {
    KeyboardUtil.hideKeyboard();
    if (index == 2) {
      QuickAlert.show(context: context, type: QuickAlertType.info, text: '模块开发中……', confirmBtnText: '确定');
      return;
    }
    _pageController.jumpToPage(index);
    setState(() {
      _currentIndex.value = index;
    });
  }
}
