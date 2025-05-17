import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tkstock/common/util/ui_util.dart';
import 'package:tkstock/common/ui/std_color.dart';
import 'package:tkstock/route/route_url.dart';
import 'package:tkstock/common/ui/title_navigation.dart';

class AgreementPage extends StatelessWidget {
  final AgreementArg arg;

  const AgreementPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    const horPadding = 16.0;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TitleNavigation(title: ''),
        UIUtil.getText(arg.title, size: 18, color: Colors.black).paddingSymmetric(horizontal: horPadding),
        const SizedBox(height: 7),
        Container(height: 1, color: StdColor.c_DEDEDE).paddingSymmetric(horizontal: horPadding),
        const SizedBox(height: 9),
        Row(children: [
          UIUtil.getText('更新日期:${_formatDate(arg.createdAt)}', size: 12, color: StdColor.c_828282),
          const Spacer(),
          UIUtil.getText('更新日期:${_formatDate(arg.updatedAt)}', size: 12, color: StdColor.c_828282),
        ]).paddingSymmetric(horizontal: horPadding),
        const SizedBox(height: 32),
        UIUtil.getText(arg.desc, size: 14, color: StdColor.c_282828, maxLines: 999)
            .paddingSymmetric(horizontal: horPadding)
            .expanded(),
      ]),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
