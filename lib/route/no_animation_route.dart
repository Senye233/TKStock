import 'package:flutter/material.dart';

/// 无动画切换的路由
/// 用于需要立即切换、不需要过渡动画的场景
class NoAnimationRoute<T> extends PageRoute<T> {
  final Widget page;
  
  NoAnimationRoute({
    required this.page,
    super.settings,
    this.maintainState = true,
    super.fullscreenDialog = false,
  });

  @override
  final bool maintainState;

  @override
  Color? get barrierColor => null;
  
  @override
  String? get barrierLabel => null;
  
  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return page;
  }
  
  @override
  Duration get transitionDuration => Duration.zero;
  
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, 
      Animation<double> secondaryAnimation, Widget child) {
    // 不使用任何动画效果，直接返回child
    return child;
  }
}

/// 扩展方便使用
extension NoAnimationRouteExt on Widget {
  /// 使用无动画路由跳转
  Route<T> noAnimationRoute<T>({String? routeName}) {
    return NoAnimationRoute<T>(
      page: this,
      settings: routeName != null ? RouteSettings(name: routeName) : null,
    );
  }
} 