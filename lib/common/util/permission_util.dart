
// import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {

  static Future<bool> tryPhotoPermission() async {
    // var status = await Permission.photos.status;
    // if (status.isGranted) return true;
    // if (status.isPermanentlyDenied) {
    //   EasyLoading.showInfo('请去设置中同意相册权限以上传图片，$status');
    //   return false;
    // }
    // if (!status.isGranted && !status.isPermanentlyDenied) {
    //   status = await Permission.storage.request();
    //   if (status.isGranted) {
    //     return true;
    //   }
    // }
    return false;
  }
}
