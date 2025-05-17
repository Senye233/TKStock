import 'package:equatable/equatable.dart';

class GameDetailPageArg extends Equatable {
  final int id;
  final bool joined;

  const GameDetailPageArg({required this.id, required this.joined});

  factory GameDetailPageArg.empty() => const GameDetailPageArg(id: 0, joined: false);

  @override
  List<Object?> get props => [id, joined];
}
