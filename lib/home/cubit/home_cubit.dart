import 'package:equatable/equatable.dart';
import 'package:tkstock/chat/model/vo.dart';
import 'package:tkstock/common/constant.dart';
import 'package:tkstock/common/model/response.dart';
import 'package:tkstock/common/network.dart';
import 'package:tkstock/common/ui/base_state.dart';
import 'package:tkstock/common/ui/common_cubit.dart';
import 'package:tkstock/home/resp.dart';
import 'package:tkstock/home/view/home_item_view.dart';

part 'home_state.dart';

class HomeCubit extends CommonCubit {
  List<HomeItemVo> _list = [];
  int _page = 1;
  List<dynamic> _historyChatList = [];

  @override
  Future load() async {
    _page = 1;
    try {
      if (!Constant.isLogin()) {
        emit(HomeLoaded(vos: [], status: CommonListStatus.noMore, historyChatList: []));
        return;
      }
      if (_list.isEmpty) {
        emit(CommonLoading(isWeak: false));
      }
      final res = await _loadBindDialogData(false);
      _list = res.list;
      _historyChatList = await _loadUnbindDialogData();
      emit(HomeLoaded(
        vos: _list,
        status: res.status,
        historyChatList: _historyChatList,
      ));
    } catch (e) {
      emit(CommonLoadError.any(e, isWeak: false));
    }
  }

  loadMore() async {
    _page++;
    try {
      final res = await _loadBindDialogData(true);
      _list.addAll(res.list);
      emit(HomeLoaded(
        vos: _list,
        status: res.status,
        historyChatList: _historyChatList,
      ));
    } catch (e) {
      _page--;
      emit(HomeLoaded(vos: _list, status: CommonListStatus.loadMoreError, historyChatList: _historyChatList));
      emit(CommonLoadError.any(e, isWeak: true));
    }
  }

  Future<HomeItemVoList> _loadBindDialogData(bool isLoadMore) async {
    final resp = await DioClient.getRespData(
      'hit-stock/page',
      queryParameters: {'pageNum': _page, 'pageSize': 50},
      fromJsonT: (json) => HomeBindDialogList.fromJson(json),
    );
    if (resp.error()) {
      throw Exception(resp.message);
    }
    final list = resp.data?.list ?? [];
    final vos = <HomeItemVo>[];
    for (final item in list) {
      final ChatAdviceType adviceType;
      if (item.baseStockInfo.changeAmount > 0) {
        adviceType = ChatAdviceType.buy;
      } else if (item.baseStockInfo.changeAmount < 0) {
        adviceType = ChatAdviceType.sell;
      } else {
        adviceType = ChatAdviceType.wait;
      }
      vos.add(HomeItemVo(
        dialogId: item.dialogId,
        hitStockId: item.hitStockId,
        name: item.baseStockInfo.name,
        code: item.baseStockInfo.code,
        date: _date2Str(item.createdTime),
        desc: item.aiResp,
        iconUrl: item.baseStockInfo.stockAvatarUrl,
        adviceType: adviceType,
        isTop: item.top == 1,
      ));
    }
    final CommonListStatus status;
    if (isLoadMore) {
      final loadedNum = _page * 100;
      status = loadedNum >= (resp.data?.total ?? 0) ? CommonListStatus.noMore : CommonListStatus.loadMore;
    } else {
      status = CommonListStatus.refresh;
    }
    return HomeItemVoList(
      list: vos,
      status: status,
    );
  }

  Future<List<dynamic>> _loadUnbindDialogData() async {
    final resp = await DioClient.postRespData(
      'dialog/page',
      data: {'pageNum': 1, 'pageSize': 100},
      fromJsonT: (json) => HomeUnbindDialogList.fromJson(json),
    );
    final list = resp.data?.list ?? [];
    final res = <dynamic>[];
    var dateStr = '';
    for (final item in list) {
      if (item.dialogContexts.isEmpty) continue;
      final createdDateStr = _date2Str(item.dialogContexts.last.createdTime);
      if (dateStr != createdDateStr) {
        dateStr = createdDateStr;
        res.add(createdDateStr);
      }
      res.add(HistoryChatVo(
        id: item.dialogId,
        title: item.dialogContexts.first.question,
        // TODO: 更新
        name: '新对话',
        // name: item.dialogContexts.first.question,
      ));
    }
    return res;
  }

  String _date2Str(DateTime date) {
    final now = DateTime.now();
    final todayZero = DateTime(now.year, now.month, now.day);
    final diff = todayZero.difference(date);
    final diffInHours = diff.inHours;
    if (diffInHours <= 0) {
      return '今天';
    } else if (diffInHours < 24) {
      return '昨天';
    } else if (diffInHours < 48) {
      return '前天';
    }
    return '${date.year}-${date.month}-${date.day}';
  }

  Future<void> del(int hitStockId) async {
    try {
      emit(CommonLoading(isWeak: true));
      final resp = await DioClient.delRespNoData('hit-stock/$hitStockId');
      if (resp.error()) {
        throw Exception(resp.message);
      }
      load();
    } catch (e) {
      emit(CommonLoadError.any(e, isWeak: true));
    }
  }

  Future<void> setTop(int hitStockId, bool top) async {
    try {
      emit(CommonLoading(isWeak: true));
      final RespNoData resp;
      final String url = 'hit-stock/$hitStockId';
      if (top) {
        resp = await DioClient.postRespNoData(url);
      } else {
        resp = await DioClient.delRespNoData(url);
      }
      if (resp.error()) {
        throw Exception(resp.message);
      }
      load();
    } catch (e) {
      emit(CommonLoadError.any(e, isWeak: true));
    }
  }
}

class HomeItemVoList extends Equatable {
  final List<HomeItemVo> list;
  final CommonListStatus status;

  const HomeItemVoList({required this.list, required this.status});

  @override
  List<Object?> get props => [list, status];
}
