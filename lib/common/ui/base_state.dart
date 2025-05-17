import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';


/// 基础状态
/// 所有 Cubit 状态必须继承此类
abstract class BaseState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

/// 加载中状态
mixin Loading on BaseState {
  bool get isWeak;
  String? get msg;
}

/// 加载完成状态
mixin Loaded on BaseState {}

/// 翻页
mixin MultiPage on BaseState {
  CommonListStatus get status;
}

enum CommonListStatus { refresh, loadMore, loadMoreError, noMore }

/// 加载错误状态
mixin LoadError on BaseState {
  CustomError get error;

  bool get isWeak;
}

class CommonState extends BaseState {}

class CommonLoaded extends CommonState with Loaded {}

class CommonEmpty extends CommonState with Loaded {}

class CommonClose extends CommonState {}

class CommonRouteName extends CommonState {
  final String routeName;
  final dynamic arguments;

  CommonRouteName(this.routeName, {this.arguments});

  @override
  List<Object?> get props => [routeName, arguments];
}

class CommonSuccessToast extends CommonState {
  final String msg;

  CommonSuccessToast(this.msg);
}

class CommonLoading extends CommonState with Loading {
  @override
  final bool isWeak;
  @override
  final String? msg;

  CommonLoading({required this.isWeak, this.msg});
}

class CommonLoadError extends CommonState with LoadError {
  @override
  final CustomError error;

  @override
  final bool isWeak;

  CommonLoadError({required this.error, required this.isWeak});
  
  factory CommonLoadError.any(Object err, {required bool isWeak}) {
    return CommonLoadError(error: CustomError.fromAny(err), isWeak: isWeak);
  }

  @override
  List<Object?> get props => [error, isWeak, Object()];
}

class CustomError extends Equatable {
  final String message;
  final bool unAuth;

  const CustomError({required this.message, this.unAuth = false});

  @override
  List<Object?> get props => [message, Object()];

  factory CustomError.fromDio(DioException error) {
    if (error.error is SocketException) {
      return const CustomError(message: '网络异常，请检查网络');
    }
    var msg = '${error.response?.statusCode} ${error.message}';
    final data = error.response?.data;
    if (data is Map && data['message'] != null) {
      msg = data['message'].toString();
    }
    return CustomError(message: msg, unAuth: error.response?.statusCode == 401);
  }

  factory CustomError.fromAny(Object err) {
    if (err is DioException) {
      return CustomError.fromDio(err);
    }
    return CustomError(message: err.toString());
  }
}
