// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RespWithData<T> _$RespWithDataFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    RespWithData<T>(
      code: $enumDecode(_$RespCodeEnumMap, json['code']),
      message: json['message'] as String,
      successful: json['successful'] as bool,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
    );

Map<String, dynamic> _$RespWithDataToJson<T>(
  RespWithData<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'code': _$RespCodeEnumMap[instance.code]!,
      'message': instance.message,
      'successful': instance.successful,
      'data': _$nullableGenericToJson(instance.data, toJsonT),
    };

const _$RespCodeEnumMap = {
  RespCode.error: '9999',
  RespCode.notAuth: '401',
  RespCode.success: '200',
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

RespNoData _$RespNoDataFromJson(Map<String, dynamic> json) => RespNoData(
      code: $enumDecode(_$RespCodeEnumMap, json['code']),
      message: json['message'] as String,
      successful: json['successful'] as bool,
    );

Map<String, dynamic> _$RespNoDataToJson(RespNoData instance) =>
    <String, dynamic>{
      'code': _$RespCodeEnumMap[instance.code]!,
      'message': instance.message,
      'successful': instance.successful,
    };
