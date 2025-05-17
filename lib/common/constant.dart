import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tkstock/common/model/user.dart';
import 'package:tkstock/common/util/event_bus_util.dart';

class Constant {
  Constant._();

  static const String _commonBoxName = "common";

  static Box get commonBox => Hive.box(_commonBoxName);

  static const String _kUser = "user";
  static User? _user;

  static User? get user => _user;

  static set user(User? user) {
    _user = user;
    if (user == null) {
      commonBox.delete(_kUser);
    } else {
      commonBox.put(_kUser, user.toJsonStr());
    }
  }

  static int get userId => _user?.userId ?? 0;

  static setup() async {
    final box = await Hive.openBox(_commonBoxName);
    final String? userStr = box.get(_kUser, defaultValue: null);
    if (userStr != null) {
      _user = User.fromJsonStr(userStr);
      debugPrint('Token: $token');
    }
  }

  static bool isLogin() {
    return user != null;
  }

  static const _keyShowWelcome = 'showWelcome';

  static bool get showWelcome => commonBox.get(_keyShowWelcome, defaultValue: false);

  static set showWelcome(bool value) {
    commonBox.put(_keyShowWelcome, value);
  }

  static const _keyToken = 'token';

  static String get token => commonBox.get(_keyToken, defaultValue: '');

  static set token(String value) {
    commonBox.put(_keyToken, value);
  }

  static const _keyTokenExpire = 'tokenExpire';

  static int get tokenExpire => commonBox.get(_keyTokenExpire, defaultValue: 0);

  static set tokenExpire(int value) {
    commonBox.put(_keyTokenExpire, value);
  }

  static logout() {
    user = null;
    token = '';
    EventBusUtil.fire(UserUpdateEvent());
  }
}
