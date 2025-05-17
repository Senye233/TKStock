import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tkstock/common/constant.dart';
import 'package:tkstock/common/model/response.dart';

class DioClient {
  static Dio? _dio;

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    var options = BaseOptions(
      baseUrl: 'https://api.tkstock.com/depth/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      // contentType: 'application/json; charset=utf-8',
    );

    var dio = Dio(options);
    dio.interceptors.add(TokenInterceptor());
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
    //   client.badCertificateCallback = (X509Certificate cert, String host, int port) {
    //     return true;
    //   };
    //   // client.findProxy = (uri) {
    //   //   return 'PROXY 192.168.31.201:8888';
    //   // };
    //   return client;
    // };
    return dio;
  }

  static Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    required T Function(dynamic json) deserializer,
  }) async {
    queryParameters ??= {};
    // debugPrint('http get: $path, params: $queryParameters');
    final resp = await instance.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
    // debugPrint('http get: response:\n${_prettyPrintJson(resp.data)}');
    return deserializer(resp.data);
  }

  static Future<RespWithData<T>> getRespData<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJsonT,
  }) async {
    return get(path, queryParameters: queryParameters, deserializer: (data) => RespWithData.fromJson(data, fromJsonT));
  }

  static Future<RespWithData<T>> postRespData<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJsonT,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      deserializer: (data) => RespWithData.fromJson(data, fromJsonT),
    );
  }

  static Future<RespNoData> postRespNoData(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      deserializer: (data) => RespNoData.fromJson(data),
    );
  }

  static Future<T> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    required T Function(dynamic json) deserializer,
  }) async {
    queryParameters ??= {};
    debugPrint('http post: $path, params: $queryParameters\ndata: ${_prettyPrintJson(data)}}');
    final resp = await instance.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    // debugPrint('http post: response:\n${resp.data}');
    return deserializer(resp.data);
  }

  static Future<RespNoData> putRespNoData(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      deserializer: (data) => RespNoData.fromJson(data),
    );
  }

  static Future<T> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    required T Function(dynamic json) deserializer,
  }) async {
    final dio = instance;
    final resp = await dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return deserializer(resp.data);
  }

  static Future<RespNoData> delRespNoData(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final resp = await del(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    return RespNoData.fromJson(resp.data);
  }

  static Future<Response<T>> del<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final dio = instance;
    return dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  static Future<Response<T>> uploadFile<T>(
    String path, {
    required String filePath,
    String? filename,
    String fileKey = 'file',
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final dio = instance;
    return dio.post(
      path,
      data: FormData.fromMap({
        fileKey: await MultipartFile.fromFile(filePath),
        'filename': filename,
      }),
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Options wait30sOptions() {
    final option = Options();
    option.sendTimeout = const Duration(seconds: 30);
    option.receiveTimeout = const Duration(seconds: 30);
    return option;
  }
}

class TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = Constant.token;
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer ${Constant.token}';
    }
    debugPrint('http request: ${options.method}, ${options.uri}, ${options.data}');
    handler.next(options);
  }
}

String _prettyPrintJson(dynamic json) {
  const JsonEncoder encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(json);
}
