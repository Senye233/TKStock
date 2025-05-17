import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';


class KeyboardUtil {
  KeyboardUtil._();

  static hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
