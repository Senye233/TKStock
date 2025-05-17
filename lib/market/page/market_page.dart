import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tkstock/common/ui/base_state.dart';
import 'package:tkstock/common/ui/cubit_page_state.dart';
import 'package:tkstock/common/ui/pressable.dart';
import 'package:tkstock/common/ui/screen_util.dart';
import 'package:tkstock/common/ui/std_color.dart';
import 'package:tkstock/common/util/ui_util.dart';
import 'package:tkstock/market/cubit/market_cubit.dart';
import 'package:tkstock/route/route_url.dart';


class MarketPage extends StatefulWidget {
  const MarketPage._();

  @override
  State<StatefulWidget> createState() => _MarketPageState();

  static create() => BlocProvider(create: (_) => MarketCubit(), child: const MarketPage._());
}

class _MarketPageState extends KeepAliveCubitPageState<MarketPage, MarketCubit> {
  final _curTab = 0;
  var _curFavoriteIndex = 0;
  bool _isLandscape = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _toggleOrientation();
  // }

  @override
  void dispose() {
    // 恢复所有方向
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Color get bgColor => StdColor.c_F4F6FA;

  // 添加切换屏幕方向的方法
  void _toggleOrientation() {
    setState(() {
      _isLandscape = !_isLandscape;
      if (_isLandscape) {
        // 设置为横屏
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        // 设置为竖屏
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  @override
  Widget buildContent(BuildContext context, BaseState state) {
    if (state is! MarketState) return const SizedBox.shrink();
    return _isLandscape ? _buildLandscapeContent(context, state) : _buildPortraitContent(context, state);
  }

  Widget _buildLandscapeContent(BuildContext context, MarketState state) {
    const headerHeight = 60.0;
    return Row(children: [
      Container(
        width: 136,
        padding: const EdgeInsets.only(left: 44),
        decoration: BoxDecoration(
          color: Colors.white,
          // 右侧阴影
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              UIUtil.getText(state.favoriteStocks[_curFavoriteIndex].name, size: 16, weight: FontWeight.w600),
              Icon(Icons.arrow_drop_down),
            ]).sizedBox(height: headerHeight),
          ],
        ),
      ),
      const SizedBox(width: 44),
    ]);
  }

  Widget _buildPortraitContent(BuildContext context, MarketState state) {
    final showFavorite = _curTab == 0;
    final showAll = _curTab == 1;
    const horMargin = 13.0;
    const divider = SizedBox(height: 1);
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(height: ScreenUtil.topPadding, color: Colors.white),
      Container(
        color: Colors.white,
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: horMargin),
        child: Row(children: [
          _buildTab('自选', showFavorite),
          const SizedBox(width: 17),
          _buildTab('市场', showAll),
          const Spacer(),
          UIUtil.assetImage('market/btn_search.png'),
        ]),
      ),
      divider,
      Container(
        color: Colors.white,
        height: 86,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: horMargin),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => _IndexView(vo: state.indices[index]),
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemCount: state.indices.length,
        ),
      ),
      divider,
      Container(
        color: Colors.white,
        height: 40,
        child: Row(children: [
          ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: horMargin),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              if (i == state.favoriteStocks.length) {
                return UIUtil.assetImage('market/btn_add_favorite.png');
              }
              final selected = i == _curFavoriteIndex;
              final color = selected ? StdColor.highlight : StdColor.c_999999;
              final weight = selected ? FontWeight.w600 : FontWeight.w400;
              return UIUtil.getText(state.favoriteStocks[i].name, size: 15, color: color, weight: weight)
                  .pressable(() => setState(() => _curFavoriteIndex = i));
            },
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemCount: state.favoriteStocks.length + 1,
          ).expanded(),
          Pressable(
            onTap: () async {
              await Navigator.pushNamed(context, RouteUrl.marketSelfManager);
              cubit.refresh();
            } ,
            child: UIUtil.assetImage('market/btn_manager.png'),
          ),
          const SizedBox(width: horMargin),
        ]),
      ),
      divider,
      Container(
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _buildFavoriteHorView(state.favoriteStocks[_curFavoriteIndex].stocks),
        ),
      ),
      divider,
      Container(
        color: Colors.white,
        height: 40,
        child: Row(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UIUtil.assetImage('market/btn_add_favorite.png'),
              const SizedBox(width: 3),
              UIUtil.getText('添加自选', color: StdColor.c_999999),
            ],
          ).expanded(),
          Container(width: 1, height: 40, color: bgColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UIUtil.assetImage('market/btn_favorite_import.png'),
              const SizedBox(width: 3),
              UIUtil.getText('自选导入', color: StdColor.c_999999),
            ],
          ).expanded(),
        ]),
      ),
    ]);
  }

  Widget _buildTab(String text, bool isSelected) {
    return UIUtil.getText(
      text,
      size: isSelected ? 18 : 16,
      color: isSelected ? StdColor.c_282828 : StdColor.c_999999,
      weight: isSelected ? FontWeight.w600 : FontWeight.w400,
    );
  }

  DataColumn _buildColumnHeader(String text, double width, SortType sortType) {
    final isCurrentSort = cubit.state is MarketState && (cubit.state as MarketState).sortType == sortType;
    final isAscending = cubit.state is MarketState && (cubit.state as MarketState).sortAscending;

    return DataColumn(
      label: Container(
        alignment: Alignment.center,
        width: width,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          UIUtil.getText(text),
          const SizedBox(width: 4),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '▲',
                style: TextStyle(
                  fontSize: 8,
                  height: 0.7,
                  color: isCurrentSort && isAscending ? StdColor.highlight : StdColor.c_999999,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '▼',
                style: TextStyle(
                  fontSize: 8,
                  height: 0.7,
                  color: isCurrentSort && !isAscending ? StdColor.highlight : StdColor.c_999999,
                ),
              ),
            ],
          ),
        ]),
      ).pressable(() => cubit.sort(sortType)),
    );
  }

  Widget _buildFavoriteHorView(List<FavoriteStockItem> stocks) {
    const normalWidth = 80.0;
    return DataTable(
      horizontalMargin: 13,
      columnSpacing: 0,
      dividerThickness: 0.01,
      columns: [
        DataColumn(
          label: Row(mainAxisSize: MainAxisSize.max, children: [
            Pressable(
              onTap: () {
                // _toggleOrientation();
              },
              child: UIUtil.assetImage('market/btn_rotate.png'),
            ),
            const SizedBox(width: 10),
            UIUtil.assetImage('market/btn_config.png'),
          ]).sizedBox(width: 200),
        ),
        _buildColumnHeader('最新价', normalWidth, SortType.latestPrice),
        _buildColumnHeader('涨幅', normalWidth, SortType.changePercent),
        _buildColumnHeader('涨速', normalWidth, SortType.changeSpeed),
        _buildColumnHeader('成交量', normalWidth, SortType.volume),
        _buildColumnHeader('换手率', normalWidth, SortType.turnover),
        _buildColumnHeader('市盈率', normalWidth, SortType.peRatio),
        _buildColumnHeader('总市值', normalWidth, SortType.totalMarketValue),
      ],
      rows: stocks
          .map((stock) => DataRow(cells: [
                DataCell(RichText(
                    text: TextSpan(children: [
                  TextSpan(text: '${stock.name}\n', style: TextStyle(fontSize: 15, color: StdColor.c_282828)),
                  TextSpan(text: stock.code, style: TextStyle(fontSize: 13, color: StdColor.c_999999)),
                ]))),
                DataCell(Text(stock.latestPrice.toString()).center()),
                DataCell(Container(
                  decoration: BoxDecoration(
                    color: stock.changePercent > 0 ? StdColor.c_FF2D55 : StdColor.c_34C759,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  width: 64,
                  alignment: Alignment.center,
                  height: 22,
                  child: UIUtil.getText('${stock.changePercent > 0 ? '+' : ''}${stock.changePercent}%',
                      color: Colors.white, size: 15),
                ).center()),
                DataCell(Text(stock.changeSpeed.toString()).center()),
                DataCell(Text(stock.volume.toString()).center()),
                DataCell(Text(stock.turnover.toString()).center()),
                DataCell(Text(stock.peRatio.toString()).center()),
                DataCell(Text(stock.totalMarketValue.toString()).center()),
              ]))
          .toList(),
    );
  }
}

class _IndexView extends StatelessWidget {
  final Index vo;

  const _IndexView({required this.vo});

  @override
  Widget build(BuildContext context) {
    final isPos = vo.changePercent > 0;
    final prefix = isPos ? '+' : '';
    return Stack(children: [
      UIUtil.assetImage(isPos ? 'market/bg_index_pos.png' : 'market/bg_index_neg.png'),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        UIUtil.getText(vo.name, size: 13, color: StdColor.c_282828),
        UIUtil.getText(vo.num.toString(), size: 16, color: StdColor.c_FF2D55),
        Row(children: [
          UIUtil.getText('$prefix${vo.changeNum}', size: 12, color: StdColor.c_FF2D55),
          const Spacer(),
          UIUtil.getText('$prefix${vo.changePercent}%', size: 12, color: StdColor.c_FF2D55),
        ]),
      ]).positioned(left: 3, right: 3, top: 0, bottom: 0),
    ]).sizedBox(width: 108, height: 66);
  }
}
