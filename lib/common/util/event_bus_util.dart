import 'dart:async';

import 'package:event_bus/event_bus.dart';

class EventBusUtil {
  EventBusUtil._();

  static final _eventBus = EventBus();

  static fire(Event event) {
    _eventBus.fire(event);
  }

  static StreamSubscription<T> listen<T extends Event>(Function(T event) onData) {
    return _eventBus.on<T>().listen((event) {
      onData(event);
    });
  }
}

abstract class Event {}

class UserUpdateEvent extends Event {}

class TokenExpiredEvent extends Event {}

class ChatUpdateEvent extends Event {}
