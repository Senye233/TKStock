import 'package:equatable/equatable.dart';
import 'package:tkstock/common/ui/base_state.dart';
import 'package:tkstock/common/ui/common_cubit.dart';

part 'market_state.dart';

class MarketCubit extends CommonCubit {
  MarketCubit() : super();

  var _favoriteStocks = <FavoriteStock>[];
  var _indices = <Index>[];
  SortType _sortType = SortType.none;
  var _sortAscending = true;

  @override
  Future<void> load() async {
    refresh();
  }

  refresh() {
    _mockData();
    _updateUI();
  }

  _updateUI() {
    final sortFavoriteStocks = _favoriteStocks.map((e) {
      final stocks = List<FavoriteStockItem>.from(e.stocks);
      stocks.sort((a, b) {
        final int value;
        switch (_sortType) {
          case SortType.none:
            return 0;
          case SortType.latestPrice:
            value = a.latestPrice.compareTo(b.latestPrice);
          case SortType.changePercent:
            value = a.changePercent.compareTo(b.changePercent);
          case SortType.changeSpeed:
            value = a.changeSpeed.compareTo(b.changeSpeed);
          case SortType.volume:
            value = a.volume.compareTo(b.volume);
          case SortType.turnover:
            value = a.turnover.compareTo(b.turnover);
          case SortType.peRatio:
            value = a.peRatio.compareTo(b.peRatio);
          case SortType.totalMarketValue:
            value = a.totalMarketValue.compareTo(b.totalMarketValue);
        }
        return _sortAscending ? value : -value;
      });
      return e.copyWith(stocks: stocks);
    }).toList();
    emit(MarketState(indices: _indices, favoriteStocks: sortFavoriteStocks, sortType: _sortType, sortAscending: _sortAscending));
  }

  void _mockData() {
    final favoriteStock1 = FavoriteStock(
      id: 1,
      name: '自选股1',
      stocks: [
        FavoriteStockItem(
          code: '512980',
          name: '传媒ETF',
          latestPrice: 3528.94,
          changePercent: 0.04,
          changeSpeed: 1.14,
          volume: 3528.94,
          turnover: 1.12,
          peRatio: 108.84,
          totalMarketValue: 10884000000,
          favoriteTime: DateTime.now(),
          favoritePrice: 3528.94,
          favoriteProfit: FavoriteProfit.equal,
        ),
        FavoriteStockItem(
          code: '512980',
          name: '传媒ETF',
          latestPrice: 3528.94,
          changePercent: -0.04,
          changeSpeed: 1.14,
          volume: 3528.94,
          turnover: 1.12,
          peRatio: 108.84,
          totalMarketValue: 10884000000,
          favoriteTime: DateTime.now(),
          favoritePrice: 3528.94,
          favoriteProfit: FavoriteProfit.equal,
        ),
        FavoriteStockItem(
          code: '512980',
          name: '传媒ETF',
          latestPrice: 3528.94,
          changePercent: -0.04,
          changeSpeed: 1.14,
          volume: 3528.94,
          turnover: 1.12,
          peRatio: 108.84,
          totalMarketValue: 10884000000,
          favoriteTime: DateTime.now(),
          favoritePrice: 3528.94,
          favoriteProfit: FavoriteProfit.equal,
        ),
        FavoriteStockItem(
          code: '512980',
          name: '传媒ETF',
          latestPrice: 3528.94,
          changePercent: -0.04,
          changeSpeed: 1.14,
          volume: 3528.94,
          turnover: 1.12,
          peRatio: 108.84,
          totalMarketValue: 10884000000,
          favoriteTime: DateTime.now(),
          favoritePrice: 3528.94,
          favoriteProfit: FavoriteProfit.equal,
        ),
        FavoriteStockItem(
          code: '512980',
          name: '传媒ETF',
          latestPrice: 3528.94,
          changePercent: -0.04,
          changeSpeed: 1.14,
          volume: 3528.94,
          turnover: 1.12,
          peRatio: 108.84,
          totalMarketValue: 10884000000,
          favoriteTime: DateTime.now(),
          favoritePrice: 3528.94,
          favoriteProfit: FavoriteProfit.equal,
        ),
      ],
    );
    final totalFavoriteStocks = [favoriteStock1].expand((e) => e.stocks).toList();
    _indices = [
      Index(name: '上证指数', code: '000001', num: 3350.49, changePercent: 10.5, changeNum: 15.54),
      Index(name: '深证指数', code: '399001', num: 2345.67, changePercent: 10.5, changeNum: 15.54),
      Index(name: '创业指数', code: '399006', num: 2345.67, changePercent: -10.5, changeNum: -15.54),
    ];
    _favoriteStocks = [
      FavoriteStock(
        id: 0,
        name: '自选股1',
        stocks: totalFavoriteStocks,
      ),
      favoriteStock1,
    ];
  }

  void sort(SortType sortType) {
    if (_sortType == sortType) {
      _sortAscending = !_sortAscending;
    } else {
      _sortType = sortType;
      _sortAscending = true;
    }
    _updateUI();
  }
}

enum SortType {
  none,
  latestPrice,
  changePercent,
  changeSpeed,
  volume,
  turnover,
  peRatio,
  totalMarketValue,
}
