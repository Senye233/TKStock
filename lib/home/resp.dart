import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'resp.g.dart';

@JsonSerializable()
class HomeUnbindDialogList extends Equatable {
  final int page;
  final int total;
  final List<HomeUnbindDialog> list;

  const HomeUnbindDialogList({
    required this.page,
    required this.total,
    required this.list,
  });

  factory HomeUnbindDialogList.fromJson(Map<String, dynamic> json) => _$HomeUnbindDialogListFromJson(json);

  Map<String, dynamic> toJson() => _$HomeUnbindDialogListToJson(this);

  @override
  List<Object?> get props => [page, total, list];
}

@JsonSerializable()
class HomeUnbindDialog extends Equatable {
  final int dialogId;
  @JsonKey(defaultValue: [])
  final List<HomeUnbindDialogContext> dialogContexts;

  const HomeUnbindDialog({
    required this.dialogId,
    required this.dialogContexts,
  });

  factory HomeUnbindDialog.fromJson(Map<String, dynamic> json) => _$HomeUnbindDialogFromJson(json);

  Map<String, dynamic> toJson() => _$HomeUnbindDialogToJson(this);

  @override
  List<Object?> get props => [dialogId, dialogContexts];
}

@JsonSerializable()
class HomeUnbindDialogContext extends Equatable {
  final int dialogId;
  final int dialogDetailId;
  final String question;
  final String replyContext;
  final int hit;
  final int traced;
  @JsonKey(defaultValue: '')
  final String imageUrl;
  final DateTime createdTime;

  const HomeUnbindDialogContext({
    required this.dialogId,
    required this.dialogDetailId,
    required this.question,
    required this.replyContext,
    required this.hit,
    required this.traced,
    required this.imageUrl,
    required this.createdTime,
  });

  factory HomeUnbindDialogContext.fromJson(Map<String, dynamic> json) => _$HomeUnbindDialogContextFromJson(json);

  Map<String, dynamic> toJson() => _$HomeUnbindDialogContextToJson(this);

  @override
  List<Object?> get props => [dialogId, dialogDetailId, question, replyContext, hit, traced, imageUrl, createdTime];
}

@JsonSerializable()
class HomeBindDialogList extends Equatable {
  final int page;
  final int total;
  final List<HomeBindDialog> list;

  const HomeBindDialogList({
    required this.page,
    required this.total,
    required this.list,
  });

  factory HomeBindDialogList.fromJson(Map<String, dynamic> json) => _$HomeBindDialogListFromJson(json);

  Map<String, dynamic> toJson() => _$HomeBindDialogListToJson(this);

  @override
  List<Object?> get props => [page, total, list];
}

@JsonSerializable()
class HomeBindDialog extends Equatable {
  final BaseStockInfo baseStockInfo;
  final int hitStockId;
  final int top;
  final String aiResp;
  final int dialogId;
  final DateTime createdTime;

  const HomeBindDialog({
    required this.baseStockInfo,
    required this.hitStockId,
    required this.top,
    required this.aiResp,
    required this.dialogId,
    required this.createdTime,
  });

  factory HomeBindDialog.fromJson(Map<String, dynamic> json) => _$HomeBindDialogFromJson(json);

  Map<String, dynamic> toJson() => _$HomeBindDialogToJson(this);

  @override
  List<Object?> get props => [baseStockInfo, hitStockId, top, aiResp, dialogId, createdTime];
}

@JsonSerializable()
class BaseStockInfo extends Equatable {
  /// 股票代码
  final String code;
  /// 股票名称
  final String name;
  /// 股票头像
  final String? stockAvatarUrl;
  /// 最新价
  final double latestPrice;
  /// 涨跌幅(%)
  final double changePercent;
  /// 涨跌额
  final double changeAmount;
  /// 成交量(手)
  final double volume;
  /// 成交额(元)
  final double turnover;
  /// 振幅(%)
  final double amplitude;
  /// 最高价
  final double highPrice;
  /// 最低价
  final double lowPrice;
  /// 今开盘价
  final double openPrice;
  /// 昨收盘价
  final double prevClose;
  /// 量比
  final double volumeRatio;
  /// 换手率(%)
  final double turnoverRate;
  /// 市盈率(动态)
  final double peRatio;
  /// 市净率
  final double pbRatio;
  /// 总市值(元)
  final double totalMarketValue;
  /// 流通市值(元)
  final double circulatingMarketValue;
  /// 涨速(%)
  final double riseSpeed;
  /// 5分钟涨跌(%)
  final double fiveMinChange;
  /// 60日涨跌幅(%)
  final double sixtyDayChange;
  /// 年初至今涨跌幅(%)
  final double yearToDateChange;

  const BaseStockInfo({
    required this.code,
    required this.name,
    this.stockAvatarUrl,
    required this.latestPrice,
    required this.changePercent,
    required this.changeAmount,
    required this.volume,
    required this.turnover,
    required this.amplitude,
    required this.highPrice,
    required this.lowPrice,
    required this.openPrice,
    required this.prevClose,
    required this.volumeRatio,
    required this.turnoverRate,
    required this.peRatio,
    required this.pbRatio,
    required this.totalMarketValue,
    required this.circulatingMarketValue,
    required this.riseSpeed,
    required this.fiveMinChange,
    required this.sixtyDayChange,
    required this.yearToDateChange,
  });

  factory BaseStockInfo.fromJson(Map<String, dynamic> json) => _$BaseStockInfoFromJson(json);

  Map<String, dynamic> toJson() => _$BaseStockInfoToJson(this);

  @override
  List<Object?> get props => [code, name, stockAvatarUrl, latestPrice, changePercent, changeAmount, volume, turnover, amplitude, highPrice, lowPrice, openPrice, prevClose, volumeRatio, turnoverRate, peRatio, pbRatio, totalMarketValue, circulatingMarketValue, riseSpeed, fiveMinChange, sixtyDayChange, yearToDateChange];
}
