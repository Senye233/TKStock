import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:tkstock/common/constant.dart';
import 'package:tkstock/common/model/user.dart';
import 'package:tkstock/common/network.dart';
import 'package:tkstock/common/ui/base_state.dart';
import 'package:tkstock/common/ui/pressable.dart';
import 'package:tkstock/common/ui/screen_util.dart';
import 'package:tkstock/common/ui/std_color.dart';
import 'package:tkstock/common/util/encrypt_util.dart';
import 'package:tkstock/common/util/event_bus_util.dart';
import 'package:tkstock/common/util/ui_util.dart';
import 'package:tkstock/route/route_url.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPhoneLogin = true;
  bool _agreePrivacy = false;
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // 验证码倒计时相关变量
  bool _isCounting = false;
  int _countdownSeconds = 60;
  Timer? _timer;
  
  // 登录按钮防抖动变量
  bool _isLoginButtonEnabled = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: SafeArea(child: _buildContentView()));
  }

  Widget _buildContentView() {
    const horPadding = 16.0;
    const hintColor = Color(0xFFC0C0C0);
    const bottomLineColor = Color(0xFFEDEDED);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 12),
      ReturnPressable(child: const Icon(Icons.arrow_back_ios_new, size: 16)),
      const SizedBox(height: 32),
      UIUtil.getText(_isPhoneLogin ? '验证码登录' : '密码登录', size: 22),
      UIUtil.getText('未注册的手机号验证通过后将自动注册', size: 11, color: const Color(0xFF828282))
          .paddingOnly(top: 8)
          .visible(_isPhoneLogin),
      const SizedBox(height: 45),
      UIUtil.getInputView(
        controller: _phoneController,
        hint: '请输入手机号',
        keyboardType: TextInputType.phone,
        hintColor: hintColor,
        bottomLineColor: bottomLineColor,
        width: ScreenUtil.screenWidth - horPadding * 2,
        suffixIcon: _buildCodeView(hintColor),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
      UIUtil.getInputView(
        controller: _isPhoneLogin ? _codeController : _passwordController,
        hint: _isPhoneLogin ? '请输入验证码' : '请输入密码',
        keyboardType: _isPhoneLogin ? TextInputType.number : TextInputType.text,
        obscureText: !_isPhoneLogin,
        hintColor: hintColor,
        bottomLineColor: bottomLineColor,
        width: ScreenUtil.screenWidth - horPadding * 2,
        maxLength: _isPhoneLogin ? 6 : null,
        inputFormatters: _isPhoneLogin ? [FilteringTextInputFormatter.digitsOnly] : null,
      ),
      const SizedBox(height: 16),
      _buildPrivacyView(),
      const SizedBox(height: 40),
      Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: StdColor.highlight,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: UIUtil.getText('立即登录', size: 15, color: Colors.white),
      ).pressable(() {
        if (!_isLoginButtonEnabled) return;

        setState(() => _isLoginButtonEnabled = false);
        
        // 执行登录逻辑
        _isPhoneLogin ? _phoneLogin() : _pwdLogin();
        
        // 1秒后恢复按钮可点击状态
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() => _isLoginButtonEnabled = true);
          }
        });
      }),
      const SizedBox(height: 6),
      Container(
        height: 40,
        width: double.infinity,
        alignment: Alignment.center,
        child: UIUtil.getText(_isPhoneLogin ? '密码登录' : '验证码登录', size: 13, color: const Color(0xFF828282)),
      ).pressable(() => setState(() => _isPhoneLogin = !_isPhoneLogin)),
    ]).padding(const EdgeInsets.symmetric(horizontal: horPadding));
  }

  Widget? _buildCodeView(Color hintColor) {
    if (!_isPhoneLogin) {
      return null;
    }
    
    String btnText = _isCounting ? '重新发送(${_countdownSeconds}s)' : '获取验证码';
    Color textColor = _isCounting ? const Color(0xFFAAAAAA) : hintColor;
    
    Widget textWidget = UIUtil.getText(btnText, size: 14, color: textColor)
        .paddingOnly(top: 14);
    
    return _isCounting ? textWidget : textWidget.pressable(_requestCode);
  }

  Widget _buildPrivacyView() {
    const normalTextColor = Color(0xFF818181);
    const highlightTextColor = Color(0xFF090812);
    const fontSize = 14.0;
    return Row(children: [
      Pressable(
        onTap: () => setState(() => _agreePrivacy = !_agreePrivacy),
        child: Icon(
          _agreePrivacy ? Icons.check_circle : Icons.circle_outlined,
          size: 17,
          color: _agreePrivacy ? StdColor.highlight : const Color(0xFFC0C0C0),
        ),
      ),
      const SizedBox(width: 4),
      RichText(
        text: TextSpan(
          text: '已阅读并同意',
          style: TextStyle(color: normalTextColor, fontSize: fontSize),
          children: <TextSpan>[
            TextSpan(
              text: '《注册协议》',
              style: TextStyle(color: highlightTextColor, fontSize: fontSize),
              recognizer: TapGestureRecognizer()..onTap = () {
                Navigator.pushNamed(context, RouteUrl.agreement, arguments: AgreementArg(
                  title: 'TKstocK用户协议',
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  desc: '''
1. 服务内容
我们将为您提供安全、可靠的产品与服务，包括但不限于信息浏览、账号注册、商品交易等功能。

2. 账号注册
您需要注册账号才能使用本服务。注册时应当按照流程填写信息，保证信息的真实性、正确性及完整性。

3. 用户行为规范
您在使用本服务时需遵守法律法规，不得从事违法违规行为，不得侵犯他人合法权益。
                  ''',
                ));
              },
            ),
            TextSpan(text: '和', style: TextStyle(color: normalTextColor, fontSize: fontSize)),
            TextSpan(
              text: '《隐私协议》',
              style: TextStyle(color: highlightTextColor, fontSize: fontSize),
              recognizer: TapGestureRecognizer()..onTap = () {
                Navigator.pushNamed(context, RouteUrl.agreement, arguments: AgreementArg(
                  title: 'TKstocK隐私协议',
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  desc: '''
信息收集
我们可能收集您的个人信息，包括但不限于姓名、联系方式、位置信息等，用于提供更好的服务。

信息使用
我们承诺对您的个人信息进行严格保密，不会将您的信息用于未经授权的用途。

信息安全
我们采用业界领先的安全技术保护您的个人信息，防止未经授权的访问、使用或泄露。
                  ''',
                ));
              },
            ),
          ],
        ),
      ),
    ]);
  }

  _pwdLogin() async {
    if (_passwordController.text.isEmpty) {
      SmartDialog.showToast('请输入密码');
      return;
    }
    if (_phoneController.text.isEmpty) {
      SmartDialog.showToast('请输入手机号');
      return;
    }
    if (!_agreePrivacy) {
      SmartDialog.showToast('请阅读并同意\n用户协议及隐私政策');
      return;
    }
    SmartDialog.showLoading();
    final phone = _phoneController.text;
    final password = _passwordController.text;
    final passwordMd5 = EncryptUtil.md5(password);
    try {
      final loginResp = await DioClient.postRespData(
        'auth/login',
        queryParameters: {'phone': phone, 'password': passwordMd5},
        fromJsonT: (jsonT) => LoginResp.fromJson(jsonT),
      );
      _afterLogin(loginResp.data);
    } catch (e) {
      SmartDialog.showNotify(msg: CustomError.fromAny(e).message, notifyType: NotifyType.failure);
    } finally {
      SmartDialog.dismiss(status: SmartStatus.loading);
    }
  }

  Future<void> _afterLogin(LoginResp? data) async {
    if (data == null) {
      SmartDialog.showToast('登录失败');
      return;
    }
    Constant.token = data.token;
    Constant.tokenExpire = data.tokenExpire;
    final userResp = await DioClient.getRespData(
      'user',
      fromJsonT: (jsonT) => User.fromJson(jsonT),
    );
    final user = userResp.data;
    if (user == null) {
      SmartDialog.showToast('获取用户信息失败');
      return;
    }
    Constant.user = user;
    EventBusUtil.fire(UserUpdateEvent());
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  _phoneLogin() async {
    if (_phoneController.text.isEmpty) {
      SmartDialog.showToast('请输入手机号');
      return;
    }
    if (_codeController.text.isEmpty) {
      SmartDialog.showToast('请输入验证码');
      return;
    }
    if (!_agreePrivacy) {
      SmartDialog.showToast('请阅读并同意\n用户协议及隐私政策');
      return;
    }
    SmartDialog.showLoading();
    final phone = _phoneController.text;
    try {
      final resp = await DioClient.postRespData(
        'auth/sms-login',
        queryParameters: {'phone': phone, 'authCode': _codeController.text},
        fromJsonT: (jsonT) => LoginResp.fromJson(jsonT),
      );
      _afterLogin(resp.data);
    } catch (e) {
      SmartDialog.showNotify(msg: CustomError.fromAny(e).message, notifyType: NotifyType.failure);
    } finally {
      SmartDialog.dismiss(status: SmartStatus.loading);
    }
  }

  _requestCode() async {
    if (_phoneController.text.isEmpty) {
      SmartDialog.showToast('请输入手机号');
      return;
    }
    SmartDialog.showLoading();
    final phone = _phoneController.text;
    try {
      await DioClient.postRespData('/auth/sms-code/$phone', fromJsonT: (jsonT) => true);
      SmartDialog.showNotify(msg: '验证码已发送', notifyType: NotifyType.success);
      
      // 开始倒计时
      setState(() {
        _isCounting = true;
        _countdownSeconds = 60;
      });
      
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdownSeconds <= 1) {
            _isCounting = false;
            timer.cancel();
          } else {
            _countdownSeconds -= 1;
          }
        });
      });
    } catch (e) {
      SmartDialog.showNotify(msg: e.toString(), notifyType: NotifyType.failure);
    } finally {
      SmartDialog.dismiss(status: SmartStatus.loading);
    }
  }
}
