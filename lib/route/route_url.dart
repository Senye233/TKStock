import 'package:equatable/equatable.dart';

class RouteUrl {
  RouteUrl._();

  static const String home = '/';
  static const String login = '/login';
  static const String chat = '/chat';
  static const String marketSelfManager = '/marketSelfManager';
  static const String agreement = '/agreement';
}

class RouteChatArg extends Equatable {
  final int id;
  final String name;

  const RouteChatArg({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class AgreementArg extends Equatable {
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String desc;

  const AgreementArg({
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.desc,
  });

  @override
  List<Object?> get props => [title, createdAt, updatedAt, desc];
}
