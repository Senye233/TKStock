part of 'market_self_manager_cubit.dart';

class MarketSelfManagerLoaded extends CommonLoaded {
  final List<MarketSelfGroupVo> groups;

  MarketSelfManagerLoaded({required this.groups});

  @override
  List<Object?> get props => [groups, Object()];
}

class MarketSelfItemVo extends Equatable {
  final int id;
  final String name;
  final String code;

  const MarketSelfItemVo({required this.id, required this.name, required this.code});

  @override
  List<Object?> get props => [id, name, code];
}

class MarketSelfGroupVo extends Equatable {
  final int id;
  final String name;
  final MarketSelfGroupVoStatus status;
  final List<MarketSelfItemVo> items;

  const MarketSelfGroupVo({required this.id, required this.name, required this.status, required this.items});

  @override
  List<Object?> get props => [id, name, status, items];

  MarketSelfGroupVo copyWith({
    int? id,
    String? name,
    MarketSelfGroupVoStatus? status,
    List<MarketSelfItemVo>? items,
  }) {
    return MarketSelfGroupVo(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      items: items ?? this.items,
    );
  }
}

enum MarketSelfGroupVoStatus {
  off,
  on,
  other;
}
