import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:tkstock/common/constant.dart';
import 'package:tkstock/common/model/user.dart';
import 'package:tkstock/common/ui/pressable.dart';
import 'package:tkstock/common/ui/screen_util.dart';
import 'package:tkstock/common/ui/std_color.dart';
import 'package:tkstock/common/util/event_bus_util.dart';
import 'package:tkstock/common/util/ui_util.dart';
import 'package:tkstock/route/route_url.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  User? get _user => Constant.user;

  late List<StreamSubscription> _subs;

  @override
  void initState() {
    super.initState();
    _subs = [
      EventBusUtil.listen<UserUpdateEvent>((event) {
        setState(() {});
      }),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    for (var sub in _subs) {
      sub.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(children: [
      Stack(children: [
        UIUtil.assetImage('user/bg_top.png', width: ScreenUtil.screenWidth, height: 220, fit: BoxFit.fill),
        _buildUserView(),
        _buildDataView(),
        _buildVipView(),
      ]).color(Colors.white).sizedBox(height: 233 + ScreenUtil.topPadding),
      const SizedBox(height: 6),
      Container(
        color: Colors.white,
        height: 76,
        alignment: Alignment.center,
        child: _buildToolItemView(assetName: 'user/ic_order.png', title: '我的订单'),
      ),
      const SizedBox(height: 6),
      Column(children: [
        const SizedBox(height: 26),
        _buildToolItemView(assetName: 'user/ic_trace.png', title: '智能追踪'),
        const SizedBox(height: 26),
        _buildToolItemView(assetName: 'user/ic_feedback.png', title: '意见反馈'),
        const SizedBox(height: 26),
        _buildToolItemView(assetName: 'user/ic_setting.png', title: '系统设置').pressable(_logout),
      ]).color(Colors.white).expanded(),
    ]).color(const Color(0xFFF4F5F9));
  }

  _logout() {
    Constant.user = null;
    Constant.token == '';
    EventBusUtil.fire(UserUpdateEvent());
  }

  Widget _buildUserView() {
    return Row(children: [
      AvatarView(avatarUrl: _user?.avatar),
      const SizedBox(width: 8),
      UIUtil.getText(_user?.nickname ?? '登录/注册', color: StdColor.normalText, weight: FontWeight.w600, size: 18),
    ]).pressable(() async {
      final res = await Navigator.of(context).pushNamed(RouteUrl.login);
      if (res == true) {
        setState(() {});
      }
    }, enable: !Constant.isLogin()).positioned(top: 25 + ScreenUtil.topPadding, left: 16);
  }

  Widget _buildDataView() {
    return Row(children: [
      const Spacer(),
      _buildDataItemView('0', '我的模型'),
      const SizedBox(width: 117),
      _buildDataItemView('0', '可用次数'),
      const Spacer(),
    ]).positioned(top: 83 + ScreenUtil.topPadding, left: 0, right: 0);
  }

  Widget _buildVipView() {
    final horPadding = 16.0;
    return Stack(children: [
      UIUtil.assetImage('user/bg_vip.png',
          width: ScreenUtil.screenWidth - horPadding * 2, height: 60, fit: BoxFit.fill),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          UIUtil.getText('SVIP专享', size: 14, color: const Color(0xFFF3CE95), weight: FontWeight.bold),
          UIUtil.getText('立 享 价 值 会 员 权 益', size: 11, color: const Color(0xFFB8AC92)),
        ],
      ).positioned(top: 13, left: 12),
      Pressable(
        onTap: () {},
        child: Stack(
          children: [
            UIUtil.assetImage('user/btn_bg.png'),
            UIUtil.getText('16元开通', size: 12, color: const Color(0xFF5B3D13), weight: FontWeight.bold)
                .positioned(left: 15, top: 3),
          ],
        ),
      ).positioned(top: 18, right: 16),
    ]).positioned(top: 152 + ScreenUtil.topPadding, left: horPadding, right: horPadding);
  }

  Widget _buildDataItemView(String count, String title) {
    return Column(children: [
      UIUtil.getText(count, size: 18),
      const SizedBox(height: 4),
      UIUtil.getText(title, size: 12),
    ]).padding(const EdgeInsets.symmetric(horizontal: 4)).sizedBox(height: 60);
  }

  Widget _buildToolItemView({required String assetName, required String title}) {
    return Row(children: [
      const SizedBox(width: 13),
      UIUtil.assetImage(assetName, width: 16, height: 16),
      const SizedBox(width: 10),
      UIUtil.getText(title, size: 15),
      const Spacer(),
      const Icon(Icons.arrow_forward_ios, size: 12),
      const SizedBox(width: 16),
    ]);
  }
}

class AvatarView extends StatelessWidget {
  final String? avatarUrl;

  const AvatarView({super.key, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    double size = 44.0;
    final Widget child;
    if (avatarUrl == null) {
      child = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: Colors.grey),
      );
    } else {
      child = ExtendedImage.network(
        avatarUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(size / 2),
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.completed:
              return null;
            case LoadState.loading:
              return const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            case LoadState.failed:
              return const Icon(Icons.account_circle, size: 22);
          }
        },
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: child,
    );
  }
}
