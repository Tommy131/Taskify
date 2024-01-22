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
 * @LastEditTime : 2024-01-22 11:13:34
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// main.dart
import 'dart:io';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'package:window_size/window_size.dart';

import 'package:todolist_app/app.dart';
import 'package:todolist_app/models/category.dart';
import 'package:todolist_app/providers/json_driver.dart';

/// 全局常量: DEBUG状态
const bool isDebugMode = bool.fromEnvironment('dart.vm.product') == false;
final Logger mainLogger = Logger('MainLogger');

/// 主函数
void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    developer.log(
        '[${rec.loggerName}] ${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();
  setWindowTitle("TodoListApp by Jay");

  mainLogger.info('正在启动TodoList程序...');
  Application();
  MyApp.run();
}

/// 主程序类
class Application {
  static late JsonDriver _settings;
  static late Category _defaultCategory;

  Application() {
    _settings = JsonDriver('userSettings', savePath: 'userData');

    Map<String, dynamic> mergedData = {
      ...{
        'categories': {
          'settings': {
            'name': 'Default',
            'color': Colors.blue.value,
            'priority': 0,
          },
          'list': {}
        }
      },
      ..._settings.data
    };
    _settings.writeData(mergedData);
    Map<String, dynamic> setting = _settings.data['categories']['settings'];
    _defaultCategory =
        Category(name: setting['name'], color: Color(setting['color']));
  }

  static Category get defaultCategory {
    return _defaultCategory;
  }

  static Map get settings {
    return _settings.data;
  }

  static JsonDriver userSettings() {
    return _settings;
  }

  static debug(String message) {
    if (isDebugMode) {
      mainLogger.info('[DEBUG] $message');
    }
  }

  static void createDirectory(String path) {
    // 创建 Directory 对象
    Directory directory = Directory(path);

    // 检查目录是否存在，如果不存在，则创建
    if (!directory.existsSync()) {
      directory.createSync(recursive: true); // 使用 recursive 参数确保创建父目录（如果不存在）
      Application.debug('Directory created: $path');
    } else {
      // mainLogger.warning('Directory already exists: $path');
    }
  }

  static void showStandardDialog(BuildContext context,
      {String title = 'Success', String content = 'Action done.'}) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                )
              ],
            ));
  }

  static void showConfirmationDialog(BuildContext context,
      {String confirmMessage = '', Function? onCall}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Are you sure you want to perform this action?'),
            Text(
              confirmMessage,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          ]),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onCall != null) {
                  onCall();
                }
                showStandardDialog(context);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  static bool moveFile(String sourcePath, String destinationDirectory) {
    try {
      File sourceFile = File(sourcePath);

      if (sourceFile.existsSync()) {
        String destinationPath =
            '$destinationDirectory${sourceFile.uri.pathSegments.last}';

        sourceFile.renameSync(destinationPath);

        Application.debug(
            'File moved successfully from $sourcePath to $destinationPath');
        return true;
      } else {
        Application.debug('WARN >> Source file does not exist.');
      }
    } catch (e) {
      Application.debug('WARN >> Error moving file: $e');
    }
    return false;
  }
}

class UI {
  static Ink decoratedContainer(Widget widget, {Function? onTapCall}) {
    return Ink(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell(
        onTap: () {
          if (onTapCall != null) {
            onTapCall();
          }
        },
        borderRadius: BorderRadius.circular(5),
        child: Container(
          // margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                spreadRadius: 3,
                blurRadius: 7,
                blurStyle: BlurStyle.outer,
              ),
            ],
          ),
          child: widget,
        ),
      ),
    );
  }
}
