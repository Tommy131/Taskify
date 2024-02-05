/*
 *        _____   _          __  _____   _____   _       _____   _____
 *      /  _  \ | |        / / /  _  \ |  _  \ | |     /  _  \ /  ___|
 *      | | | | | |  __   / /  | | | | | |_| | | |     | | | | | |
 *      | | | | | | /  | / /   | | | | |  _  { | |     | | | | | |   _
 *      | |_| | | |/   |/ /    | |_| | | |_| | | |___  | |_| | | |_| |
 *      \_____/ |___/|___/     \_____/ |_____/ |_____| \_____/ \_____/
 *
 *  Copyright (c) 2023 by OwOTeam-DGMT (OwOBlog).
 * @Date         : 2024-01-29 22:27:29
 * @Author       : HanskiJay
 * @LastEditors  : HanskiJay
 * @LastEditTime : 2024-01-29 22:27:47
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
/// core/utils.dart
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Utils {
  static String formatBytes(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
    int i = 0;
    double size = bytes.toDouble();
    while (size > 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(2)} ${suffixes[i]}';
  }

  static Future<int> getDirectorySize(Directory dir) async {
    int size = 0;
    await for (var entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        size += await entity.length();
      }
    }
    return size;
  }

  static Future<String> getStorageInfo() async {
    String storageInfo = '';
    try {
      // 获取应用程序的文档目录路径
      Directory appDocDir = await getApplicationDocumentsDirectory();

      // 获取文档目录的存储使用情况
      int storageUsage = await getDirectorySize(appDocDir);

      storageInfo = 'Storage usage: ${formatBytes(storageUsage)}';
    } catch (e) {
      storageInfo = 'Failed to fetch storage info';
    }
    return storageInfo;
  }
}
