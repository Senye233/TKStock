import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tkstock/common/constant.dart';

part 'response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class RespWithData<T> extends Equatable {
  final RespCode code;
  final String message;
  final bool successful;
  final T? data;

  const RespWithData({
    required this.code,
    required this.message,
    required this.successful,
    required this.data,
  });

  factory RespWithData.fromJson(Map<String, dynamic> srcJson, T Function(Map<String, dynamic>) fromJsonT) {
    final resp = _$RespWithDataFromJson(srcJson, (json) => fromJsonT(json as Map<String, dynamic>));
    if (resp.code == RespCode.notAuth) {
      Constant.logout();
    }
    if (!resp.successful) {
      throw Exception(resp.message);
    }
    return resp;
  }

  factory RespWithData.fromJsonSimple(Map<String, dynamic> srcJson, T Function(Object?) fromJsonT) {
    final resp = _$RespWithDataFromJson(srcJson, (json) => fromJsonT(json));
    if (!resp.successful) {
      throw Exception(resp.message);
    }
    return resp;
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => _$RespWithDataToJson(this, toJsonT);

  @override
  List<Object?> get props => [code, message, data];

  bool success() => code == RespCode.success && data != null && successful;

  bool error() => !success();
}

@JsonEnum(valueField: 'value')
enum RespCode {
  error('9999'),
  notAuth('401'),
  success('200');

  const RespCode(this.value);

  final String value;
}

@JsonSerializable()
class RespNoData extends Equatable {
  final RespCode code;
  final String message;
  final bool successful;

  const RespNoData({required this.code, required this.message, required this.successful});

  @override
  List<Object?> get props => [code, message, successful];

  bool success() => code == RespCode.success && successful;

  bool error() => !success();

  factory RespNoData.fromJson(Map<String, dynamic> srcJson) => _$RespNoDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RespNoDataToJson(this);
}
