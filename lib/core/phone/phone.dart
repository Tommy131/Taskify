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
 * @LastEditTime : 2024-02-07 01:03:28
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// core/phone.dart
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:taskify/main.dart';

class Phone {
  static Future<int> get version async {
    try {
      final int version = await const MethodChannel('android_version').invokeMethod('getAndroidVersion');
      return version;
    } on PlatformException catch (e) {
      Application.debug('Error: ${e.message}');
      return -1;
    }
  }

  static Future<void> checkStoragePermission({
    Function? onGrantedCallback,
    Function? onDeclinedCallback,
  }) async {
    var status1 = await Permission.storage.status;
    var status2 = await Permission.manageExternalStorage.status;

    if (status1.isDenied || status2.isDenied) {
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
    }

    final int androidVersion = await version;
    if ((androidVersion == -1) || (androidVersion >= 13)) {
      return;
    }

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
