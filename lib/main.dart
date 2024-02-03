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
 * @LastEditTime : 2024-02-03 23:30:49
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
import 'package:url_launcher/url_launcher.dart';
import 'package:window_size/window_size.dart';
import 'package:path_provider/path_provider.dart';

import 'package:todolist_app/app.dart';
import 'package:todolist_app/models/category.dart';
import 'package:todolist_app/models/json_driver.dart';
import 'package:todolist_app/core/android.dart';

/// 全局常量: DEBUG状态
const bool isDebugMode = bool.fromEnvironment('dart.vm.product') == false;

/// 全局常量: 主日志记录器
final Logger mainLogger = Logger('MainLogger');

/// 全局常量: 文件夹名称
const savePathName = 'userData';

final List<String> jsonFileNames = ['userSettings', 'todoList'];

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
        '${Application.appName} v${Application.versionName} By HanskiJay');
  }

  mainLogger.info(
      '正在启动 ${Application.appName} v${Application.versionName} By HanskiJay...');
  Application();

  Timer(const Duration(seconds: 2), () {
    MyApp.run();
  });

  mainLogger.info('所有组件全部启动成功, 正在系统 ${Platform.operatingSystem} 上运行.');
  mainLogger.info('当前系统版本: ${Platform.operatingSystemVersion}');
  mainLogger.info('当前系统语言: ${Platform.localeName}');
}

/// 主程序类
class Application {
  static const String appName = 'Taskify';
  static const int versionCode = 20240204;
  static const String versionName = '0.0.3';
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
          UI.showBottomSheet(
            message: 'Unable to access system storage path! Please grant it.',
          );
          // if (isDebugMode) exit(0);
        },
      );

      getApplicationDocumentsDirectory().then((Directory directory) {
        generateConfigurations(savePath: '${directory.path}/$savePathName');
      });
    } else {
      generateConfigurations();
    }
  }

  static void generateConfigurations({String savePath = savePathName}) {
    _settings = JsonDriver(
      jsonFileNames[0],
      savePath: savePath,
      useDefault: !Platform.isAndroid,
    );

    _todoList = JsonDriver(
      jsonFileNames[1],
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

  static void reloadConfigurations() {
    _settings.initializeFile();
    _todoList.initializeFile();
  }

  static Category get defaultCategory {
    return _defaultCategory;
  }

  static Map<String, dynamic> get settings {
    return _settings.data;
  }

  static Map<String, dynamic> get todoList {
    return _todoList.data;
  }

  static JsonDriver userSettingsJson() {
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
    debug('应用程序文档目录：${directory.path}');

    // 获取应用程序缓存目录
    final cacheDirectory = await getTemporaryDirectory();
    debug('应用程序缓存目录：${cacheDirectory.path}');

    // 获取外部存储目录
    final externalDirectory = await getExternalStorageDirectory();
    if (externalDirectory != null) {
      debug('外部存储目录：${externalDirectory.path}');
    } else {
      debug('无法获取外部存储目录');
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

  static void openExternalLink(BuildContext context, String url) async {
    // ignore: deprecated_member_use
    if (!await launchUrl(Uri.parse(url))) {
      // ignore: use_build_context_synchronously
      UI.showBottomSheet(
        context: context,
        message: 'Cannot open the external link!',
      );
    }
  }
}

class UI {
  static const double minimalWidthForWindows = 450.0;
  static const double minimalExpandWidthForNavigation = 900.0;

  static EdgeInsets getStandardPaddingData() {
    return const EdgeInsets.symmetric(vertical: 10, horizontal: 20);
  }

  static ThemeData getTheme(BuildContext context) {
    return Theme.of(context);
  }

  static double getMaxWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static AppBar createAppBar(BuildContext context, String title) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
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
      {String title = 'Success',
      String content = 'Action done.',
      Function(BuildContext?)? actionCall}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (actionCall != null) {
                actionCall(context);
              }
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  static void showConfirmationDialog(BuildContext context,
      {String confirmMessage = '',
      Function? onCancelled,
      Function? onConfirmed}) {
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
                if (onCancelled != null) {
                  onCancelled();
                }
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onConfirmed != null) {
                  onConfirmed();
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

  static void showBottomSheet({
    BuildContext? context,
    String? message,
    Color? color,
  }) {
    Color backgroundColor = color ?? Colors.black.withOpacity(0.7);

    if ((Platform.isWindows || Platform.isLinux || Platform.isMacOS) &&
        (context != null)) {
      final snackBar = SnackBar(
        content: Text(message!),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      Fluttertoast.showToast(
        msg: message!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  static AnimatedSwitcher addAnimatedSwitcher(Widget widget) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: widget,
    );
  }

  static Ink decoratedContainer(Widget widget,
      {Function? onLongPressCall, Function? onTapCall}) {
    return Ink(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell(
        onLongPress: () => (onLongPressCall != null) ? onLongPressCall() : null,
        onTap: () => (onTapCall != null) ? onTapCall() : null,
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
                blurRadius: 3,
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

  static Future<DateTime?> selectDate(
      BuildContext context, DateTime selectedDate) async {
    return await showDatePicker(
      context: context,
      initialDate: selectedDate,
      currentDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
  }

  static Future<TimeOfDay?> selectTime(
      BuildContext context, TimeOfDay selectedTime) async {
    return await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
  }

  static ElevatedButton addPickDateButton(
      BuildContext context, DateTime selectedDate,
      {Function(DateTime?)? onResult}) {
    return ElevatedButton(
      onPressed: () {
        selectDate(context, selectedDate).then((value) {
          if (onResult != null) {
            onResult(value);
          }
        });
      },
      child: const Text('Pick Date'),
    );
  }

  static ElevatedButton addPickTimeButton(
      BuildContext context, TimeOfDay selectedTime,
      {Function(TimeOfDay?)? onResult}) {
    return ElevatedButton(
      onPressed: () {
        selectTime(context, selectedTime).then((value) {
          if (onResult != null) {
            onResult(value);
          }
        });
      },
      child: const Text('Pick Time'),
    );
  }

  static ElevatedButton addPickDateTimeButton(
      BuildContext context, DateTime selectedDateTime,
      {Function(DateTime?)? onResult}) {
    return ElevatedButton(
      onPressed: () async {
        await selectDate(context, selectedDateTime).then(
          (date) async {
            if (date == null) {
              return;
            }
            // ignore: use_build_context_synchronously
            await selectTime(context, TimeOfDay.now()).then(
              (time) {
                if (time == null) {
                  return;
                }
                DateTime pickedDate = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                );

                if (onResult != null) {
                  onResult(pickedDate);
                }
              },
            );
            return null;
          },
        );
      },
      child: const Text('Pick Time'),
    );
  }

  static DateTime dateMerger(DateTime? pickedDate, TimeOfDay? pickedTime) {
    pickedDate ??= DateTime.now();
    pickedTime ??= TimeOfDay.fromDateTime(DateTime.now());
    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }
}
