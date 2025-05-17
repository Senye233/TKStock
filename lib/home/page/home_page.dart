import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:tkstock/common/constant.dart';
import 'package:tkstock/common/ui/base_state.dart';
import 'package:tkstock/common/ui/cubit_page_state.dart';
import 'package:tkstock/common/ui/screen_util.dart';
import 'package:tkstock/common/ui/std_color.dart';
import 'package:tkstock/common/util/event_bus_util.dart';
import 'package:tkstock/common/util/ui_util.dart';
import 'package:tkstock/home/cubit/home_cubit.dart';
import 'package:tkstock/home/view/home_item_view.dart';
import 'package:tkstock/route/route_url.dart';

class HomePage extends StatefulWidget {
  const HomePage._();

  @override
  State<StatefulWidget> createState() => _HomePageState();

  static create() => BlocProvider(create: (_) => HomeCubit(), child: const HomePage._());
}

class _HomePageState extends KeepAliveCubitPageState<HomePage, HomeCubit> {
  @override
  Color get bgColor => StdColor.c_F4F6FA;

  final _refreshController = EasyRefreshController(controlFinishRefresh: true, controlFinishLoad: true);
  final _historyRefreshController = EasyRefreshController(controlFinishRefresh: true, controlFinishLoad: true);
  final _scrollController = ScrollController();

  var _isFirstLoad = true;

  @override
  List<StreamSubscription> setupSubscriptions() {
    return [
      EventBusUtil.listen<UserUpdateEvent>((_) => cubit.load()),
      EventBusUtil.listen<ChatUpdateEvent>((_) => cubit.load()),
    ];
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _historyRefreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  listener(BuildContext context, BaseState state) {
    super.listener(context, state);
    if (state is HomeLoaded) {
      if (_isFirstLoad) {
        _isFirstLoad = false;
        if (state.vos.isEmpty && Constant.isLogin()) {
          Navigator.pushNamed(context, RouteUrl.chat);
        }
      }
      switch (state.status) {
        case CommonListStatus.refresh:
          _refreshController.finishRefresh();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.position.pixels > 0) {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
            }
          });
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

  @override
  Widget buildContent(BuildContext context, BaseState state) {
    if (state is! HomeLoaded) {
      return Container();
    }
    final titleHeight = 44 + ScreenUtil.topPadding;
    return Stack(
      children: [
        EasyRefresh(
          controller: _refreshController,
          onRefresh: cubit.load,
          onLoad: cubit.loadMore,
          header: CupertinoHeader(),
          footer: CupertinoFooter(),
          child: ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) => _buildSlidableItemView(state.vos[index]),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: state.vos.length,
          ),
        ).paddingOnly(top: titleHeight + 10, left: 13, right: 13),
        Container(
          height: titleHeight,
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.only(left: 13, right: 13, top: ScreenUtil.topPadding),
          child: Stack(
            alignment: Alignment.center,
            children: [
              UIUtil.assetImage('home/btn_menu.png')
                  .pressable(() => _showHistoryDrawer(state.historyChatList))
                  .positioned(left: 0),
              UIUtil.assetImage('home/btn_search.png').positioned(right: 36),
              UIUtil.assetImage('home/btn_add.png').pressable(() async {
                await Navigator.pushNamed(context, RouteUrl.chat);
                cubit.load();
              }).positioned(right: 0),
            ],
          ),
        ),
      ],
    );
  }

  void _showHistoryDrawer(List<dynamic> historyChatList) {
    SmartDialog.show(
      alignment: Alignment.centerLeft,
      builder: (_) => Container(
        width: ScreenUtil.screenWidth * 0.8,
        height: ScreenUtil.screenHeight,
        color: const Color(0xFFF4F5F7),
        padding: EdgeInsets.only(left: 13, right: 13, bottom: 13),
        child: Column(
          children: [
            SizedBox(height: ScreenUtil.topPadding + 10),
            Row(children: [
              UIUtil.getText('历史聊天', size: 15, color: const Color(0xFF090909)),
              const Spacer(),
              UIUtil.getText('全部清除', size: 13, color: StdColor.c_999999),
            ]),
            const SizedBox(height: 4),
            ListView.separated(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) => _buildHistoryItemView(historyChatList[index]),
              separatorBuilder: (context, index) => const SizedBox(height: 6),
              itemCount: historyChatList.length,
            ).expanded(),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItemView(dynamic vo) {
    if (vo is String) {
      return UIUtil.getText(vo, size: 13, color: StdColor.c_999999).paddingOnly(top: 10, bottom: 4);
    }
    if (vo is! HistoryChatVo) return Container();
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(9), color: Colors.white),
      height: 38,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: UIUtil.getText(vo.title, size: 15, color: const Color(0xFF090909)),
    ).pressable(() async {
      SmartDialog.dismiss();
      await Navigator.pushNamed(context, RouteUrl.chat, arguments: RouteChatArg(id: vo.id, name: vo.title));
      cubit.load();
    });
  }

  Widget _buildSlidableItemView(HomeItemVo vo) {
    return Slidable(
      key: Key(vo.dialogId.toString()),
      endActionPane: ActionPane(
        extentRatio: 0.5,
        motion: const ScrollMotion(),
        children: [
          CustomSlidableAction(
            onPressed: (BuildContext context) {},
            backgroundColor: const Color(0xFF007AFF),
            child: UIUtil.assetImage('home/btn_signal.png'),
          ),
          CustomSlidableAction(
            onPressed: (BuildContext context) {
              cubit.setTop(vo.hitStockId, true);
            },
            backgroundColor: const Color(0xFF454545),
            child: UIUtil.assetImage('home/btn_top.png'),
          ),
          CustomSlidableAction(
            onPressed: (BuildContext context) {
              cubit.del(vo.hitStockId);
            },
            backgroundColor: const Color(0xFFFF2D55),
            child: UIUtil.assetImage('home/btn_del.png'),
          ),
        ],
      ),
      child: HomeItemView(vo: vo).pressable(() async {
        await Navigator.pushNamed(context, RouteUrl.chat, arguments: RouteChatArg(id: vo.dialogId, name: vo.name));
        cubit.load();
      }),
    );
  }
}
