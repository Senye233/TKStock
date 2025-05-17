import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:tkstock/common/constant.dart';
import 'package:tkstock/common/ui/base_state.dart';
import 'package:tkstock/common/ui/common_cubit.dart';
import 'package:tkstock/common/ui/pressable.dart';
import 'package:tkstock/common/ui/screen_util.dart';
import 'package:tkstock/common/util/ui_util.dart';
import 'package:tkstock/route/route_url.dart';

abstract class CubitPageState<T extends StatefulWidget, C extends CommonCubit> extends State<T> {
  C get cubit => context.read();

  bool refreshOnLogin = false;

  List<StreamSubscription> _subscriptions = [];

  EasyRefreshController? refreshController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _refresh());
    _subscriptions = setupSubscriptions();
  }

  bool _showLoading = false;

  @override
  dispose() {
    if (_showLoading) {
      SmartDialog.dismiss(status: SmartStatus.loading);
    }
    for (var element in _subscriptions) {
      element.cancel();
    }
    super.dispose();
  }

  List<StreamSubscription> setupSubscriptions() => [];

  _refresh() {
    if (mounted) {
      cubit.load();
    }
  }

  Widget? buildTitleBar();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<C, BaseState>(
      listener: listener,
      builder: (context, state) {
        Widget widget;
        if (state is LoadError && !state.isWeak) {
          widget = Center(child: CommonErrorView(onTap: _refresh));
        } else if (state is Loading && !state.isWeak) {
          widget = Container(color: bgColor);
        } else {
          widget = buildContent(context, state);
        }
        if (withSafeArea) {
          widget = SafeArea(child: widget);
        }
        final titleBar = buildTitleBar();
        if (titleBar != null) {
          widget = Column(children: [
            titleBar,
            widget.expanded(),
          ]);
        }
        if (withScaffold) {
          widget = Scaffold(backgroundColor: bgColor, body: widget);
        } else {
          widget = Container(color: bgColor, child: widget);
        }
        return widget;
      },
      buildWhen: (previous, current) => current is Loaded || (current is LoadError && !current.isWeak),
    );
  }

  double get topPadding => MediaQuery.of(context).padding.top;

  @mustCallSuper
  listener(BuildContext context, BaseState state) {
    if (state is LoadError) {
      SmartDialog.showNotify(msg: state.error.message, notifyType: NotifyType.failure);
      if (state.error.unAuth) {
        _logout();
      }
      _showLoading = false;
    } else if (state is Loading) {
      SmartDialog.showLoading(msg: state.msg ?? '');
      _showLoading = true;
    } else {
      SmartDialog.dismiss(status: SmartStatus.loading);
      _showLoading = false;
    }
    if (state is! Loading) {
      SmartDialog.dismiss(status: SmartStatus.loading);
    }
    if (state is CommonClose) {
    Navigator.pop(context, true);
    }
    if (state is CommonSuccessToast) {
      SmartDialog.showNotify(msg: state.msg, notifyType: NotifyType.success);
    }
    if (state is CommonRouteName) {
      Navigator.pushNamed(context, state.routeName, arguments: state.arguments);
    }
    if (state is MultiPage) {
      switch (state.status) {
        case CommonListStatus.refresh:
          refreshController?.finishRefresh();
          break;
        case CommonListStatus.loadMore:
          refreshController?.finishLoad();
          break;
        case CommonListStatus.loadMoreError:
          refreshController?.finishLoad(IndicatorResult.fail);
          break;
        case CommonListStatus.noMore:
          refreshController?.finishLoad(IndicatorResult.noMore);
          break;
      }
    }
  }

  _logout() {
    Constant.logout();
    Navigator.popUntil(context, (route) => route.settings.name == RouteUrl.home);
    Navigator.pushNamed(context, RouteUrl.login);
  }

  Widget buildContent(BuildContext context, BaseState state);

  Color bgColor = Colors.white;

  bool withSafeArea = true;
  bool withScaffold = true;
}

abstract class KeepAliveCubitPageState<T extends StatefulWidget, C extends CommonCubit> extends State<T>
    with AutomaticKeepAliveClientMixin {
  C get cubit => context.read();

  bool refreshOnLogin = false;

  List<StreamSubscription> _subscriptions = [];

  EasyRefreshController? refreshController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _refresh());
    _subscriptions = setupSubscriptions();
  }

  List<StreamSubscription> setupSubscriptions() => [];

  @override
  dispose() {
    for (var element in _subscriptions) {
      element.cancel();
    }
    super.dispose();
  }

  _refresh() {
    if (mounted) {
      cubit.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<C, BaseState>(
      listener: listener,
      builder: (context, state) {
        Widget widget;
        if (state is LoadError) {
          widget = CommonErrorView(onTap: _refresh);
        } else if (state is CommonEmpty) {
          widget = const CommonEmptyView();
        } else {
          widget = buildContent(context, state);
        }
        return Container(color: bgColor, child: widget);
      },
      buildWhen: (previous, current) => current is Loaded || (current is LoadError && !current.isWeak),
    );
  }

  double get topPadding => MediaQuery.of(context).padding.top;

  @mustCallSuper
  listener(BuildContext context, BaseState state) {
    if (state is LoadError) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      SmartDialog.showNotify(msg: state.error.message, notifyType: NotifyType.failure);
      if (state.error.unAuth) {
        _logout();
      }
    } else if (state is Loading) {
      SmartDialog.showLoading(msg: '');
    } else {
      SmartDialog.dismiss(status: SmartStatus.loading);
    }
    if (state is MultiPage) {
      switch (state.status) {
        case CommonListStatus.refresh:
          refreshController?.finishRefresh();
          break;
        case CommonListStatus.loadMore:
          refreshController?.finishLoad();
          break;
        case CommonListStatus.loadMoreError:
          refreshController?.finishLoad(IndicatorResult.fail);
          break;
        case CommonListStatus.noMore:
          refreshController?.finishLoad(IndicatorResult.noMore);
          break;
      }
    }
  }

  _logout() {
    Constant.logout();
    Navigator.pushNamed(context, RouteUrl.login);
  }

  Widget buildContent(BuildContext context, BaseState state);

  Color bgColor = Colors.white;

  @override
  bool get wantKeepAlive => true;
}

enum SimplePageStatus { loading, error, empty, content }

abstract class SimplePageState<T extends StatefulWidget> extends State<T> {
  Color bgColor = Colors.white;

  String? title;

  bool withSafeArea = false;

  bool withScaffold = true;

  bool needLoad = false;

  var status = SimplePageStatus.content;

  @override
  initState() {
    super.initState();
    if (needLoad) {
      load();
    }
  }

  Future<void> load() async {
    try {
      showLoading(isWeak: false);
      await fetchData();
    } catch (e) {
      showError(e, isWeak: false);
    }
  }

  Future<void> fetchData() async {}

  @override
  Widget build(BuildContext context) {
    Widget widget;
    switch (status) {
      case SimplePageStatus.loading:
        widget = Container();
        break;
      case SimplePageStatus.error:
        widget = Center(child: CommonErrorView(onTap: load));
        break;
      case SimplePageStatus.empty:
        widget = const CommonEmptyView();
        break;
      case SimplePageStatus.content:
        widget = buildContent(context);
        break;
    }
    if (title != null) {
      widget = Column(children: [
        Stack(
          alignment: Alignment.center,
          children: [
            ReturnPressable(child: UIUtil.assetImage('user/setting_return.png')).positioned(left: 16),
            UIUtil.getText(title!, size: 26, color: Colors.black),
          ],
        ).sizedBox(height: 44, width: ScreenUtil.screenWidth),
        widget.expanded(),
      ]);
    }
    if (withSafeArea) {
      widget = SafeArea(child: widget);
    }
    if (!withScaffold) {
      return widget;
    }
    return Scaffold(backgroundColor: bgColor, body: widget);
  }

  Widget buildContent(BuildContext context);

  showLoading({bool isWeak = true}) {
    SmartDialog.showLoading(msg: '');
    if (!isWeak) {
      setState(() => status = SimplePageStatus.loading);
    }
  }

  showError(Object err, {bool isWeak = true}) {
    if (isWeak) {
      final error = CustomError.fromAny(err);
      SmartDialog.showNotify(msg: error.message, notifyType: NotifyType.failure);
    } else {
      SmartDialog.dismiss(status: SmartStatus.loading);
      setState(() => status = SimplePageStatus.error);
    }
  }

  showContent() {
    SmartDialog.dismiss(status: SmartStatus.loading);
    setState(() => status = SimplePageStatus.content);
  }
}

class CommonErrorView extends StatelessWidget {
  final VoidCallback? onTap;

  const CommonErrorView({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final widget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, size: 60),
        UIUtil.getText('加载失败，点击重试', size: 20),
      ],
    );
    if (onTap != null) {
      return Pressable(onTap: () => onTap?.call(), child: widget);
    } else {
      return widget;
    }
  }
}

class CommonEmptyView extends StatelessWidget {
  final String? hintText;
  const CommonEmptyView({super.key, this.hintText});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UIUtil.assetImage('home/logo.png', width: 200),
        UIUtil.getText(hintText ?? '数据为空', size: 20),
      ],
    );
  }
}
