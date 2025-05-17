// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeUnbindDialogList _$HomeUnbindDialogListFromJson(
        Map<String, dynamic> json) =>
    HomeUnbindDialogList(
      page: (json['page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      list: (json['list'] as List<dynamic>)
          .map((e) => HomeUnbindDialog.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeUnbindDialogListToJson(
        HomeUnbindDialogList instance) =>
    <String, dynamic>{
      'page': instance.page,
      'total': instance.total,
      'list': instance.list,
    };

HomeUnbindDialog _$HomeUnbindDialogFromJson(Map<String, dynamic> json) =>
    HomeUnbindDialog(
      dialogId: (json['dialogId'] as num).toInt(),
      dialogContexts: (json['dialogContexts'] as List<dynamic>?)
              ?.map((e) =>
                  HomeUnbindDialogContext.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$HomeUnbindDialogToJson(HomeUnbindDialog instance) =>
    <String, dynamic>{
      'dialogId': instance.dialogId,
      'dialogContexts': instance.dialogContexts,
    };

HomeUnbindDialogContext _$HomeUnbindDialogContextFromJson(
        Map<String, dynamic> json) =>
    HomeUnbindDialogContext(
      dialogId: (json['dialogId'] as num).toInt(),
      dialogDetailId: (json['dialogDetailId'] as num).toInt(),
      question: json['question'] as String,
      replyContext: json['replyContext'] as String,
      hit: (json['hit'] as num).toInt(),
      traced: (json['traced'] as num).toInt(),
      imageUrl: json['imageUrl'] as String? ?? '',
      createdTime: DateTime.parse(json['createdTime'] as String),
    );

Map<String, dynamic> _$HomeUnbindDialogContextToJson(
        HomeUnbindDialogContext instance) =>
    <String, dynamic>{
      'dialogId': instance.dialogId,
      'dialogDetailId': instance.dialogDetailId,
      'question': instance.question,
      'replyContext': instance.replyContext,
      'hit': instance.hit,
      'traced': instance.traced,
      'imageUrl': instance.imageUrl,
      'createdTime': instance.createdTime.toIso8601String(),
    };

HomeBindDialogList _$HomeBindDialogListFromJson(Map<String, dynamic> json) =>
    HomeBindDialogList(
      page: (json['page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      list: (json['list'] as List<dynamic>)
          .map((e) => HomeBindDialog.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeBindDialogListToJson(HomeBindDialogList instance) =>
    <String, dynamic>{
      'page': instance.page,
      'total': instance.total,
      'list': instance.list,
    };

HomeBindDialog _$HomeBindDialogFromJson(Map<String, dynamic> json) =>
    HomeBindDialog(
      baseStockInfo:
          BaseStockInfo.fromJson(json['baseStockInfo'] as Map<String, dynamic>),
      hitStockId: (json['hitStockId'] as num).toInt(),
      top: (json['top'] as num).toInt(),
      aiResp: json['aiResp'] as String,
      dialogId: (json['dialogId'] as num).toInt(),
      createdTime: DateTime.parse(json['createdTime'] as String),
    );

Map<String, dynamic> _$HomeBindDialogToJson(HomeBindDialog instance) =>
    <String, dynamic>{
      'baseStockInfo': instance.baseStockInfo,
      'hitStockId': instance.hitStockId,
      'top': instance.top,
      'aiResp': instance.aiResp,
      'dialogId': instance.dialogId,
      'createdTime': instance.createdTime.toIso8601String(),
    };

BaseStockInfo _$BaseStockInfoFromJson(Map<String, dynamic> json) =>
    BaseStockInfo(
      code: json['code'] as String,
      name: json['name'] as String,
      stockAvatarUrl: json['stockAvatarUrl'] as String?,
      latestPrice: (json['latestPrice'] as num).toDouble(),
      changePercent: (json['changePercent'] as num).toDouble(),
      changeAmount: (json['changeAmount'] as num).toDouble(),
      volume: (json['volume'] as num).toDouble(),
      turnover: (json['turnover'] as num).toDouble(),
      amplitude: (json['amplitude'] as num).toDouble(),
      highPrice: (json['highPrice'] as num).toDouble(),
      lowPrice: (json['lowPrice'] as num).toDouble(),
      openPrice: (json['openPrice'] as num).toDouble(),
      prevClose: (json['prevClose'] as num).toDouble(),
      volumeRatio: (json['volumeRatio'] as num).toDouble(),
      turnoverRate: (json['turnoverRate'] as num).toDouble(),
      peRatio: (json['peRatio'] as num).toDouble(),
      pbRatio: (json['pbRatio'] as num).toDouble(),
      totalMarketValue: (json['totalMarketValue'] as num).toDouble(),
      circulatingMarketValue:
          (json['circulatingMarketValue'] as num).toDouble(),
      riseSpeed: (json['riseSpeed'] as num).toDouble(),
      fiveMinChange: (json['fiveMinChange'] as num).toDouble(),
      sixtyDayChange: (json['sixtyDayChange'] as num).toDouble(),
      yearToDateChange: (json['yearToDateChange'] as num).toDouble(),
    );

Map<String, dynamic> _$BaseStockInfoToJson(BaseStockInfo instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'stockAvatarUrl': instance.stockAvatarUrl,
      'latestPrice': instance.latestPrice,
      'changePercent': instance.changePercent,
      'changeAmount': instance.changeAmount,
      'volume': instance.volume,
      'turnover': instance.turnover,
      'amplitude': instance.amplitude,
      'highPrice': instance.highPrice,
      'lowPrice': instance.lowPrice,
      'openPrice': instance.openPrice,
      'prevClose': instance.prevClose,
      'volumeRatio': instance.volumeRatio,
      'turnoverRate': instance.turnoverRate,
      'peRatio': instance.peRatio,
      'pbRatio': instance.pbRatio,
      'totalMarketValue': instance.totalMarketValue,
      'circulatingMarketValue': instance.circulatingMarketValue,
      'riseSpeed': instance.riseSpeed,
      'fiveMinChange': instance.fiveMinChange,
      'sixtyDayChange': instance.sixtyDayChange,
      'yearToDateChange': instance.yearToDateChange,
    };
