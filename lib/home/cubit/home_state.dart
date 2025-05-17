part of 'home_cubit.dart';

class HomeLoaded extends CommonLoaded {
  final List<HomeItemVo> vos;
  final CommonListStatus status;
  final List<dynamic> historyChatList;

  HomeLoaded({
    required this.vos,
    required this.status,
    required this.historyChatList,
  });

  @override
  List<Object?> get props => [vos, status, Object()];
}

/// 历史聊天记录VO
class HistoryChatVo extends Equatable {
  final int id;
  final String title;
  final String name;

  const HistoryChatVo({
    required this.id,
    required this.title,
    required this.name,
  });

  @override
  List<Object?> get props => [id, title, name];
}
