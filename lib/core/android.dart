/*
 *        _____   _          __  _____   _____   _       _____   _____
 *      /  _  \ | |        / / /  _  \ |  _  \ | |     /  _  \ /  ___|
 *      | | | | | |  __   / /  | | | | | |_| | | |     | | | | | |
 *      | | | | | | /  | / /   | | | | |  _  { | |     | | | | | |   _
 *      | |_| | | |/   |/ /    | |_| | | |_| | | |___  | |_| | | |_| |
 *      \_____/ |___/|___/     \_____/ |_____/ |_____| \_____/ \_____/
 *
 *  Copyright (c) 2023 by OwOTeam-DGMT (OwOBlog).
 * @Date         : 2024-01-19 00:55:40
 * @Author       : HanskiJay
 * @LastEditors  : HanskiJay
 * @LastEditTime : 2024-01-26 17:59:36
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// core/android.dart
import 'package:permission_handler/permission_handler.dart';

class Android {
  static void checkStoragePermission(
      {Function? onGrantedCallback, Function? onDeclinedCallback}) async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
    }

    if (status.isGranted) {
      if (onGrantedCallback != null) {
        onGrantedCallback();
      }
    } else {
      if (onDeclinedCallback != null) {
        if (status.isDenied) {
          await openAppSettings();
        }
        onDeclinedCallback();
      }
    }
  }
}
