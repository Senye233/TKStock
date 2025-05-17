part of 'market_cubit.dart';

class MarketState extends CommonLoaded {
  final List<Index> indices;
  final List<FavoriteStock> favoriteStocks;
  final SortType sortType;
  final bool sortAscending;

  MarketState({
    required this.indices,
    required this.favoriteStocks,
    required this.sortType,
    required this.sortAscending,
  });

  @override
  List<Object> get props => [indices, favoriteStocks, sortType, sortAscending];
}

/// 指数
class Index extends Equatable {
  final String name;
  final String code;
  final double num;
  final double changePercent;
  final double changeNum;

  const Index({
    required this.name,
    required this.code,
    required this.num,
    required this.changePercent,
    required this.changeNum,
  });

  @override
  List<Object> get props => [name, code, num, changePercent, changeNum];
}

class FavoriteStock extends Equatable {
  final int id;
  final String name;
  final List<FavoriteStockItem> stocks;

  const FavoriteStock({
    required this.id,
    required this.name,
    required this.stocks,
  });

  @override
  List<Object> get props => [id, name, stocks];

  FavoriteStock copyWith({List<FavoriteStockItem>? stocks}) {
    return FavoriteStock(id: id, name: name, stocks: stocks ?? this.stocks);
  }
}

/// 自选股
class FavoriteStockItem extends Equatable {
  /// 代码
  final String code;

  /// 名称
  final String name;

  /// 最新价
  final double latestPrice;

  /// 涨跌幅
  final double changePercent;

  /// 涨速
  final double changeSpeed;

  /// 成交量
  final double volume;

  /// 换手率
  final double turnover;

  /// 市盈率
  final double peRatio;

  /// 总市值
  final double totalMarketValue;

  /// 自选时间
  final DateTime favoriteTime;

  /// 自选价
  final double favoritePrice;

  /// 自选收益
  final FavoriteProfit favoriteProfit;

  const FavoriteStockItem({
    required this.code,
    required this.name,
    required this.latestPrice,
    required this.changePercent,
    required this.changeSpeed,
    required this.volume,
    required this.turnover,
    required this.peRatio,
    required this.totalMarketValue,
    required this.favoriteTime,
    required this.favoritePrice,
    required this.favoriteProfit,
  });

  @override
  List<Object> get props => [
        code,
        name,
        latestPrice,
        changePercent,
        changeSpeed,
        volume,
        turnover,
        peRatio,
        totalMarketValue,
        favoriteTime,
        favoritePrice,
        favoriteProfit,
      ];
}

/// 枚举，自选收益
enum FavoriteProfit {
  /// 盈利
  profit,

  /// 亏损
  loss,

  /// 持平
  equal,
}
