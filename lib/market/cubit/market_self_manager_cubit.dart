import 'package:equatable/equatable.dart';
import 'package:tkstock/common/ui/base_state.dart';
import 'package:tkstock/common/ui/common_cubit.dart';

part 'market_self_manager_state.dart';

class MarketSelfManagerCubit extends CommonCubit {
  final List<MarketSelfGroupVo> _groupVos = [];

  @override
  Future<void> load() async {
    _groupVos.clear();
    _groupVos.addAll(_mockData());
    emit(MarketSelfManagerLoaded(groups: _groupVos));
  }

  List<MarketSelfGroupVo> _mockData() {
    return [
      MarketSelfGroupVo(id: 1, name: '持仓', status: MarketSelfGroupVoStatus.off, items: [
        MarketSelfItemVo(id: 1, name: '自选1', code: '000001'),
        MarketSelfItemVo(id: 2, name: '自选2', code: '000002'),
      ]),
      MarketSelfGroupVo(id: 2, name: '基金', status: MarketSelfGroupVoStatus.on, items: [
        MarketSelfItemVo(id: 3, name: '自选3', code: '000003'),
        MarketSelfItemVo(id: 4, name: '自选4', code: '000004'),
      ]),
      MarketSelfGroupVo(id: 3, name: '自选股1', status: MarketSelfGroupVoStatus.other, items: [
        MarketSelfItemVo(id: 5, name: '自选5', code: '000005'),
        MarketSelfItemVo(id: 6, name: '自选6', code: '000006'),
      ]),
      MarketSelfGroupVo(id: 4, name: '自选股2', status: MarketSelfGroupVoStatus.other, items: [
        MarketSelfItemVo(id: 7, name: '自选7', code: '000007'),
        MarketSelfItemVo(id: 8, name: '自选8', code: '000008'),
      ]),
    ];
  }

  reorderGroup(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;
    if (oldIndex < newIndex) newIndex--;
    final group = _groupVos[oldIndex];
    _groupVos.removeAt(oldIndex);
    _groupVos.insert(newIndex, group);
    emit(MarketSelfManagerLoaded(groups: _groupVos));
  }

  deleteGroup(int index) {
    _groupVos.removeAt(index);
    emit(MarketSelfManagerLoaded(groups: _groupVos));
  }

  updateGroup(int index, {String? name, MarketSelfGroupVoStatus? status}) {
    _groupVos[index] = _groupVos[index].copyWith(name: name, status: status);
    emit(MarketSelfManagerLoaded(groups: _groupVos));
  }

  createGroup(String name) {
    _groupVos.add(MarketSelfGroupVo(
      id: _groupVos.length + 1,
      name: name,
      status: MarketSelfGroupVoStatus.other,
      items: [],
    ));
    emit(MarketSelfManagerLoaded(groups: _groupVos));
  }

  reorderItem({required int groupIndex, required int oldIndex, required int newIndex}) {
    if (oldIndex == newIndex) return;
    if (oldIndex < newIndex) newIndex--;
    final item = _groupVos[groupIndex].items[oldIndex];
    _groupVos[groupIndex].items.removeAt(oldIndex);
    _groupVos[groupIndex].items.insert(newIndex, item);
    emit(MarketSelfManagerLoaded(groups: _groupVos));
  }
}
