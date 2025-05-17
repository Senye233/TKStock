import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tkstock/chat/page/chat_page.dart';
import 'package:tkstock/market/page/market_self_manager_page.dart';
import 'package:tkstock/route/route_url.dart';
import 'package:tkstock/user/page/login_page.dart';
import 'package:tkstock/user/page/agreement_page.dart';


typedef WidgetBuilder = Widget Function(Object? arguments);

class RouteUtil {
  RouteUtil._();

  static final Map<String, WidgetBuilder> _map = {
    RouteUrl.login: (arguments) => const LoginPage(),
    RouteUrl.chat: (arguments) {
      return ChatPage.create(arguments is RouteChatArg ? arguments : null);
    },
    RouteUrl.marketSelfManager: (arguments) => MarketSelfManagerPage.create(),
    RouteUrl.agreement: (arguments) {
      if (arguments is AgreementArg) {
        return AgreementPage(arg: arguments);
      }
      return _UnknownRouteWidget();
    },
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final page = _map[settings.name]?.call(settings.arguments);
    if (page == null) return null;
    return CupertinoPageRoute(builder: (_) => page, settings: settings);
  }

  static Widget generateUnknownWidget() {
    return _UnknownRouteWidget();
  }
}

class _UnknownRouteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Material(child: Center(child: Text("No Route Found!")));
  }
}
