// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoodsList _$GoodsListFromJson(Map<String, dynamic> json) => GoodsList(
      list: (json['list'] as List<dynamic>)
          .map((e) => Goods.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageList: (json['imageList'] as List<dynamic>)
          .map((e) => GoodsImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GoodsListToJson(GoodsList instance) => <String, dynamic>{
      'list': instance.list,
      'imageList': instance.imageList,
    };

Goods _$GoodsFromJson(Map<String, dynamic> json) => Goods(
      goodsName: json['goods_name'] as String,
      goodsId: (json['goods_id'] as num).toInt(),
      goodsPrice: json['goods_price'] as String,
      goodsVip: json['goods_vip'] as String,
    );

Map<String, dynamic> _$GoodsToJson(Goods instance) => <String, dynamic>{
      'goods_name': instance.goodsName,
      'goods_id': instance.goodsId,
      'goods_price': instance.goodsPrice,
      'goods_vip': instance.goodsVip,
    };

GoodsImage _$GoodsImageFromJson(Map<String, dynamic> json) => GoodsImage(
      id: (json['id'] as num).toInt(),
      goodsId: (json['goods_id'] as num).toInt(),
      imageId: (json['image_id'] as num).toInt(),
      filePath: json['file_path'] as String,
      fileName: json['file_name'] as String,
      fileUrl: json['file_url'] as String,
    );

Map<String, dynamic> _$GoodsImageToJson(GoodsImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'goods_id': instance.goodsId,
      'image_id': instance.imageId,
      'file_path': instance.filePath,
      'file_name': instance.fileName,
      'file_url': instance.fileUrl,
    };
