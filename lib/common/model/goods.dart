import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'goods.g.dart';

@JsonSerializable()
class GoodsList extends Equatable {
  final List<Goods> list;
  final List<GoodsImage> imageList;

  const GoodsList({
    required this.list,
    required this.imageList,
  });

  factory GoodsList.fromJson(Map<String, dynamic> srcJson) => _$GoodsListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GoodsListToJson(this);

  @override
  List<Object?> get props => [list, imageList];
}

@JsonSerializable()
class Goods extends Equatable {
  @JsonKey(name: 'goods_name')
  final String goodsName;
  @JsonKey(name: 'goods_id')
  final int goodsId;
  @JsonKey(name: 'goods_price')
  final String goodsPrice;
  @JsonKey(name: 'goods_vip')
  // iOS商店产品名
  final String goodsVip;

  const Goods({
    required this.goodsName,
    required this.goodsId,
    required this.goodsPrice,
    required this.goodsVip,
  });

  factory Goods.fromJson(Map<String, dynamic> srcJson) => _$GoodsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GoodsToJson(this);

  @override
  List<Object?> get props => [goodsName, goodsId, goodsPrice, goodsVip];
}

@JsonSerializable()
class GoodsImage extends Equatable {
  final int id;
  @JsonKey(name: 'goods_id')
  final int goodsId;
  @JsonKey(name: 'image_id')
  final int imageId;
  @JsonKey(name: 'file_path')
  final String filePath;
  @JsonKey(name: 'file_name')
  final String fileName;
  @JsonKey(name: 'file_url')
  final String fileUrl;

  const GoodsImage({
    required this.id,
    required this.goodsId,
    required this.imageId,
    required this.filePath,
    required this.fileName,
    required this.fileUrl,
  });

  factory GoodsImage.fromJson(Map<String, dynamic> srcJson) => _$GoodsImageFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GoodsImageToJson(this);

  @override
  List<Object?> get props => [id, goodsId, imageId, filePath, fileName, fileUrl];
}
