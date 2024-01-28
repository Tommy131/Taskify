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
 * @LastEditTime : 2024-01-28 01:14:24
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// core/android.dart
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todolist_app/main.dart';

class Android {
  static const MethodChannel _channel = MethodChannel('android_version');

  static Future<int?> getAndroidVersion() async {
    try {
      final int version = await _channel.invokeMethod('getAndroidVersion');
      return version;
    } on PlatformException catch (e) {
      Application.debug('Error: ${e.message}');
      return null;
    }
  }

  static void checkStoragePermission({
    Function? onGrantedCallback,
    Function? onDeclinedCallback,
  }) async {
    final int? androidVersion = await getAndroidVersion();

    var status1 = await Permission.storage.status;
    var status2 = await Permission.manageExternalStorage.status;

    if (status1.isDenied || status2.isDenied) {
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
    }

    if (androidVersion! < 13) {
      if (status1.isGranted && status2.isGranted) {
        if (onGrantedCallback != null) {
          onGrantedCallback();
        }
      } else {
        if (onDeclinedCallback != null) {
          if (status1.isDenied || status2.isGranted) {
            await openAppSettings();
          }
          onDeclinedCallback();
        }
      }
    }
  }
}
