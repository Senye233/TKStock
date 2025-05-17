import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;

class EncryptUtil {
  EncryptUtil._();

  /// 计算字符串的MD5值
  static String md5(String input) {
    return md5Bytes(utf8.encode(input));
  }

  /// 计算字节数组的MD5值
  static String md5Bytes(List<int> bytes) {
    return hex(crypto.md5.convert(bytes).bytes);
  }

  /// 字节数组转16进制字符串
  static String hex(List<int> bytes) {
    var result = StringBuffer();
    for (var part in bytes) {
      result.write('${part < 16 ? '0' : ''}${part.toRadixString(16)}');
    }
    return result.toString();
  }
} 