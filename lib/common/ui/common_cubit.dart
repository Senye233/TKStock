import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tkstock/common/ui/base_state.dart';

abstract class CommonCubit extends Cubit<CommonState> {
  CommonCubit() : super(CommonState());

  Future load();

  tryApi<T>({
    required Future<T> Function() api,
    required Function(T data) success,
  }) async {
    try {
      emit(CommonLoading(isWeak: true));
      T response = await api();
      success(response);
    } catch (err) {
      var error = CustomError.fromAny(err);
      emit(CommonLoadError(error: error, isWeak: false));
    }
  }

  handleError(Object err, {required bool isWeak}) =>
      emit(CommonLoadError(error: CustomError.fromAny(err), isWeak: isWeak));
}

class CommonLoadedCubit extends CommonCubit {
  @override
  Future load() async => emit(CommonLoaded());
}
