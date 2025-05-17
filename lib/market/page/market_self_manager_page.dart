import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:tkstock/common/ui/base_state.dart';
import 'package:tkstock/common/ui/cubit_page_state.dart';
import 'package:tkstock/common/ui/pressable.dart';
import 'package:tkstock/common/ui/screen_util.dart';
import 'package:tkstock/common/ui/std_color.dart';
import 'package:tkstock/common/ui/title_navigation.dart';
import 'package:tkstock/common/util/ui_util.dart';
import 'package:tkstock/market/cubit/market_self_manager_cubit.dart';


class MarketSelfManagerPage extends StatefulWidget {
  const MarketSelfManagerPage({super.key});

  @override
  State<MarketSelfManagerPage> createState() => _MarketSelfManagerPageState();

  static Widget create() => BlocProvider(
        create: (_) => MarketSelfManagerCubit(),
        child: MarketSelfManagerPage(),
      );
}

class _MarketSelfManagerPageState extends CubitPageState<MarketSelfManagerPage, MarketSelfManagerCubit> {
  @override
  bool get withSafeArea => false;

  @override
  Widget? buildTitleBar() {
    return TitleNavigation(
      title: '自选管理',
      leftWidget: const SizedBox.shrink(),
      rightWidget: UIUtil.getText('完成', size: 14, color: StdColor.highlight)
          .pressable(() => Navigator.pop(context))
          .paddingOnly(right: 13),
    );
  }

  var _tabIndex = 0;
  var _groupIndex = 0;
  final _selectedItemIndexes = <int>[];

  @override
  listener(BuildContext context, BaseState state) {
    super.listener(context, state);
    if (state is MarketSelfManagerLoaded) {
      _selectedItemIndexes.clear();
    }
  }

  @override
  Widget buildContent(BuildContext context, BaseState state) {
    if (state is! MarketSelfManagerLoaded) return const SizedBox.shrink();
    return Column(children: [
      Stack(children: [
        Container(color: StdColor.c_F4F6FA, height: 1).positioned(left: 0, right: 0, bottom: 0),
        Row(children: [
          const Spacer(),
          _buildTabHeader(index: 0, title: '编辑自选'),
          const Spacer(flex: 2),
          _buildTabHeader(index: 1, title: '分组管理'),
          const Spacer(),
        ]).positioned(left: 0, right: 0, top: 0, bottom: 0),
      ]).sizedBox(height: 40),
      if (_tabIndex == 0) _buildSelfView(state.groups) else _buildGroupView(state.groups),
    ]);
  }

  Widget _buildTabHeader({required int index, required String title}) {
    final isSelected = _tabIndex == index;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      const Spacer(flex: 5),
      UIUtil.getText(title, size: 14, color: isSelected ? StdColor.highlight : StdColor.c_999999),
      const Spacer(flex: 4),
      Container(
        color: isSelected ? StdColor.highlight : Colors.transparent,
        width: 16,
        height: 2,
      ),
    ]).pressable(() => setState(() => _tabIndex = index));
  }

  Widget _buildSelfView(List<MarketSelfGroupVo> groups) {
    final List<MarketSelfItemVo> showItems;
    if (_groupIndex == 0) {
      showItems = groups.expand((e) => e.items).toList();
    } else {
      showItems = groups[_groupIndex - 1].items;
    }
    return Column(children: [
      ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: groups.length + 1,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        separatorBuilder: (context, index) => const SizedBox(width: 11),
        itemBuilder: (context, index) {
          final String title;
          if (index == 0) {
            title = '全部自选';
          } else {
            title = groups[index - 1].name;
          }
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: _groupIndex == index ? Color(0xFFfff5ed) : StdColor.c_F4F6FA,
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: UIUtil.getText(title, size: 13, color: StdColor.c_090909),
          );
        },
      ).sizedBox(height: 44),
      Container(height: 1, color: StdColor.c_EFF3FB),
      _build4ItemRow([
        UIUtil.getText('名称代码', size: 13, color: StdColor.c_999999),
        UIUtil.getText('置顶', size: 13, color: StdColor.c_999999),
        UIUtil.getText('置底', size: 13, color: StdColor.c_999999),
        UIUtil.getText('拖动排序', size: 13, color: StdColor.c_999999),
      ]).paddingAll(13),
      ReorderableListView(
        onReorder: (oldIndex, newIndex) => cubit.reorderItem(
          groupIndex: _groupIndex,
          oldIndex: oldIndex,
          newIndex: newIndex,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 13),
        children: showItems.mapIndexed((index, e) {
          return Container(
            key: ValueKey(e.id),
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: _build4ItemRow([
              Row(children: [
                UIUtil.assetImage(
                  _selectedItemIndexes.contains(index) ? 'market/ic_select_highlight.png' : 'market/ic_select_gray.png',
                ).pressable(() {
                  setState(() {
                    if (_selectedItemIndexes.contains(index)) {
                      _selectedItemIndexes.remove(index);
                    } else {
                      _selectedItemIndexes.add(index);
                    }
                  });
                }),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  UIUtil.getText(e.name, size: 15, color: StdColor.c_090909),
                  UIUtil.getText(e.code, size: 13, color: StdColor.c_999999),
                ]),
              ]),
              UIUtil.assetImage('market/btn_top.png'),
              UIUtil.assetImage('market/btn_bottom.png'),
              UIUtil.assetImage('market/btn_drag.png'),
            ]),
          );
        }).toList(),
      ).expanded(),
    ]);
  }

  Widget _build4ItemRow(List<Widget> children) {
    const firstFlex = 4;
    const secondFlex = 1;
    const thirdFlex = 1;
    const fourthFlex = 2;
    const totalFlex = firstFlex + secondFlex + thirdFlex + fourthFlex;
    final showWidth = ScreenUtil.screenWidth - 26;
    final itemWidths = [
      showWidth * firstFlex / totalFlex,
      showWidth * secondFlex / totalFlex,
      showWidth * thirdFlex / totalFlex,
      showWidth * fourthFlex / totalFlex,
    ];
    return Row(
      children: children.take(4).mapIndexed((index, e) {
        final width = itemWidths[index];
        return Container(
          width: width,
          alignment: index == 0 ? Alignment.centerLeft : Alignment.center,
          child: e,
        );
      }).toList(),
    );
  }

  Widget _buildGroupView(List<MarketSelfGroupVo> groups) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 10),
      _build4ItemRow([
        UIUtil.getText('分组名称', size: 13, color: StdColor.c_999999),
        UIUtil.getText('编辑', size: 13, color: StdColor.c_999999),
        UIUtil.getText('排序', size: 13, color: StdColor.c_999999),
        UIUtil.getText('开关/删除', size: 13, color: StdColor.c_999999),
      ]),
      const SizedBox(height: 16),
      UIUtil.getText('全部自选(${groups.length})', size: 15, color: StdColor.c_282828),
      const SizedBox(height: 13),
      ReorderableListView(
        onReorder: cubit.reorderGroup,
        children: groups.mapIndexed((index, e) {
          final Widget switchOrDelView;
          switch (e.status) {
            case MarketSelfGroupVoStatus.on:
              switchOrDelView = UIUtil.assetImage('market/ic_open.png').paddingOnly(left: 4);
              break;
            case MarketSelfGroupVoStatus.off:
              switchOrDelView = UIUtil.assetImage('market/ic_close.png');
              break;
            case MarketSelfGroupVoStatus.other:
              switchOrDelView = UIUtil.assetImage('market/btn_del.png', width: 16);
              break;
          }
          return Container(
            key: ValueKey(e.id),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _build4ItemRow([
              UIUtil.getText(e.name, size: 15, color: StdColor.c_090909),
              Pressable(
                onTap: () {
                  SmartDialog.show(
                    alignment: Alignment.center,
                    builder: (context) => InputDialog(
                      title: '编辑分组名称',
                      defaultText: e.name,
                      onConfirm: (name) => cubit.updateGroup(index, name: name),
                    ),
                  );
                },
                child: UIUtil.assetImage('market/btn_edit.png', width: 16),
              ),
              ReorderableDragStartListener(
                index: index,
                child: UIUtil.assetImage('market/btn_drag.png'),
              ),
              switchOrDelView.pressable(() {
                switch (e.status) {
                  case MarketSelfGroupVoStatus.on:
                    cubit.updateGroup(index, status: MarketSelfGroupVoStatus.off);
                    break;
                  case MarketSelfGroupVoStatus.off:
                    cubit.updateGroup(index, status: MarketSelfGroupVoStatus.on);
                    break;
                  case MarketSelfGroupVoStatus.other:
                    cubit.deleteGroup(index);
                    break;
                }
              }),
            ]),
          );
        }).toList(),
      ).expanded(),
      Container(
        height: 40,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: StdColor.highlight, borderRadius: BorderRadius.circular(4)),
        child: UIUtil.getText('新建自选分组', size: 15, color: Colors.white),
      ).pressable(() {
        SmartDialog.show(
          alignment: Alignment.center,
          builder: (context) => InputDialog(
            title: '新建分组名称',
            onConfirm: (name) => cubit.createGroup(name),
          ),
        );
      }),
      SizedBox(height: ScreenUtil.bottomPadding),
    ]).paddingSymmetric(horizontal: 13).expanded();
  }
}

class InputDialog extends StatefulWidget {
  final String title;
  final String? defaultText;
  final Function(String) onConfirm;

  const InputDialog({super.key, required this.title, this.defaultText, required this.onConfirm});

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.defaultText ?? '';
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 293,
      height: 160,
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          UIUtil.getText(widget.title, size: 17, color: StdColor.c_333333, weight: FontWeight.w600),
          const SizedBox(height: 5),
          Container(
            width: 217,
            height: 40,
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: StdColor.c_EFF3FB))),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                counterText: '',
                hintStyle: TextStyle(fontSize: 15, color: Color(0xFF767680).withValues(alpha: 0.12)),
                hintText: '最多6个中文',
              ),
              maxLength: 6,
              style: TextStyle(fontSize: 15, color: StdColor.c_090812),
            ),
          ),
          const SizedBox(height: 14),
          Row(children: [
            Container(
              width: 100,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Color(0xFF818181)),
              ),
              child: UIUtil.getText('取消', size: 15, color: StdColor.c_090812),
            ).pressable(() => SmartDialog.dismiss()),
            const Spacer(),
            Container(
              width: 100,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: StdColor.highlight,
                borderRadius: BorderRadius.circular(18),
              ),
              child: UIUtil.getText('确定', size: 15, color: Colors.white),
            ).pressable(() {
              widget.onConfirm(_controller.text);
              SmartDialog.dismiss();
            }),
          ])
        ],
      ),
    );
  }
}
