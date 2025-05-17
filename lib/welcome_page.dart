import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tkstock/common/constant.dart';
import 'package:tkstock/common/util/ui_util.dart';
import 'package:tkstock/common/ui/std_color.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolledToBottom = false;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkCanConfirm);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _checkCanConfirm();
    });
  }
  
  @override
  void dispose() {
    _scrollController.removeListener(_checkCanConfirm);
    _scrollController.dispose();
    super.dispose();
  }
  
  void _checkCanConfirm() {
    if (_isScrolledToBottom || _scrollController.offset < _scrollController.position.maxScrollExtent) return;
    setState(() => _isScrolledToBottom = true);
  }

  @override
  Widget build(BuildContext context) {
    final fontColor = StdColor.c_333333;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          SystemNavigator.pop(animated: true);
        },
        child: Stack(alignment: Alignment.center, children: [
          UIUtil.assetImage('main/bg_welcome.png').positioned(left: 0, right: 0, top: 0, bottom: 0),
          Container(color: Colors.black26),
          Container(
            width: screenWidth - 80,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(height: 8),
              UIUtil.getText('WELCOME', size: 20, color: fontColor, weight: FontWeight.w600),
              const SizedBox(height: 5),
              UIUtil.getText('欢迎来到TKstock', size: 20, color: fontColor, weight: FontWeight.w600),
              const SizedBox(height: 27),
              UIUtil.getText('免责声明', size: 15, color: StdColor.highlight),
              const SizedBox(height: 14),
              SingleChildScrollView(
                controller: _scrollController,
                child: UIUtil.getText(_privacyText, size: 12, color: Colors.black, maxLines: 999),
              ).sizedBox(height: 261),
              const SizedBox(height: 22),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  width: 100,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF818181)),
                  ),
                  alignment: Alignment.center,
                  child: UIUtil.getText('取消', size: 17, color: StdColor.normalText),
                ).pressable(() {
                  // 强制退出应用程序
                  SystemNavigator.pop(animated: true);
                }),
                const SizedBox(width: 16),
                Container(
                  width: 100,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _isScrolledToBottom ? const Color(0xFFFFE6C8) : Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: UIUtil.getText('确定', size: 17, color: _isScrolledToBottom ? const Color(0xFFFFA55B) : Colors.grey),
                ).pressable(() {
                    Constant.showWelcome = true;
                    Navigator.pop(context);
                }, enable: _isScrolledToBottom),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  final _privacyText = '''
1.市场有风险，投资需谨慎。本页面内容仅供参考，不构成深圳深度追踪人工智能有限公司做出的投资建议或对任何证券投资价值观点的认可。

2.本页面的金融产品展示不分先后，不构成投资建议或推荐。以上过往业绩仅供参考，不构成收益保证。本公司力求但不保证数据的准确性和完整性，不保证已做最新变更，请以基金公司、上市公司等公告或公开信息为准。

3.投资者应当自主进行投资决策，对投资者因依赖上述信息进行投资决策而导致的财产损失，本公司不承担法律责任。未经本公司同意，任何机构或个人不得对本公司提供的上述信息进行任何形式的转载、发布、复制或进行有悖原意的删节和修改，投资有风险，应该谨慎至上。
  ''';
}
