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
 * @LastEditTime : 2024-01-26 23:29:05
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// main.dart
import 'dart:async';
import 'dart:io';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:logging/logging.dart';
import 'package:window_size/window_size.dart';
import 'package:path_provider/path_provider.dart';

import 'package:todolist_app/app.dart';
import 'package:todolist_app/models/category.dart';
import 'package:todolist_app/providers/json_driver.dart';
import 'package:todolist_app/core/android.dart';

/// 全局常量: DEBUG状态
const bool isDebugMode = bool.fromEnvironment('dart.vm.product') == false;

/// 全局常量: 主日志记录器
final Logger mainLogger = Logger('MainLogger');

/// 全局常量: 文件夹名称
const savePathName = 'userData';

/// 主函数
void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    developer.log(
        '[${rec.loggerName}] ${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    setWindowTitle(
        "${Application.appName} v${Application.version} By HanskiJay");
  }

  mainLogger.info('正在启动TodoList程序 v${Application.version} By HanskiJay...');
  Application();

  Timer(const Duration(seconds: 2), () {
    MyApp.run();
  });
}

/// 主程序类
class Application {
  static const String appName = 'TodoList App';
  static const String version = '0.0.2-beta';
  static const String author = 'Jay Hanski';

  static late JsonDriver _settings;
  static late JsonDriver _todoList;
  static late Category _defaultCategory;

  Application() {
    if (Platform.isAndroid) {
      Android.checkStoragePermission(
        onGrantedCallback: () {
          debug('获取读写权限成功.');
        },
        onDeclinedCallback: () {
          debug('获取读写权限失败!');
          Fluttertoast.showToast(
            msg: 'Unable to access system storage path! Program exit.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          if (!isDebugMode) exit(0);
        },
      );

      getApplicationDocumentsDirectory().then((Directory directory) {
        generateConfiguration(savePath: '${directory.path}/$savePathName');
      });
    } else {
      generateConfiguration();
    }
  }

  static void generateConfiguration({String savePath = savePathName}) {
    _settings = JsonDriver(
      'userSettings',
      savePath: savePath,
      useDefault: !Platform.isAndroid,
    );

    _todoList = JsonDriver(
      'todoList',
      savePath: savePath,
      useDefault: !Platform.isAndroid,
    );

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
    _defaultCategory = Category(
      name: setting['name'],
      color: Color(setting['color']),
    );
  }

  static Category get defaultCategory {
    return _defaultCategory;
  }

  static Map get settings {
    return _settings.data;
  }

  static Map get todoList {
    return _todoList.data;
  }

  static JsonDriver userSettings() {
    return _settings;
  }

  static JsonDriver todoListJson() {
    return _todoList;
  }

  static debug(String message) {
    if (isDebugMode) {
      mainLogger.info('[DEBUG] $message');
    }
  }

  static bool isValidEmail(String email) {
    // 使用正则表达式验证邮箱格式
    final RegExp emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  void getStorageDirectory() async {
    // 获取应用程序文档目录
    final directory = await getApplicationDocumentsDirectory();
    debug("应用程序文档目录：${directory.path}");

    // 获取应用程序缓存目录
    final cacheDirectory = await getTemporaryDirectory();
    debug("应用程序缓存目录：${cacheDirectory.path}");

    // 获取外部存储目录
    final externalDirectory = await getExternalStorageDirectory();
    if (externalDirectory != null) {
      debug("外部存储目录：${externalDirectory.path}");
    } else {
      debug("无法获取外部存储目录");
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
  static EdgeInsets getStandardPaddingData() {
    return const EdgeInsets.symmetric(vertical: 10, horizontal: 20);
  }

  static double getMaxWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static AppBar createAppBar(BuildContext context, String title) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: UI.getTheme(context).primaryColor,
      elevation: 5,
    );
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
      ),
    );
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
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
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

  static InputDecoration input(String hintText,
      {Color color = Colors.black45}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: color),
    );
  }

  static ThemeData getTheme(BuildContext context) {
    return Theme.of(context);
  }
}
