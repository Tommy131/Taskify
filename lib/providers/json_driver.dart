/*
 *        _____   _          __  _____   _____   _       _____   _____
 *      /  _  \ | |        / / /  _  \ |  _  \ | |     /  _  \ /  ___|
 *      | | | | | |  __   / /  | | | | | |_| | | |     | | | | | |
 *      | | | | | | /  | / /   | | | | |  _  { | |     | | | | | |   _
 *      | |_| | | |/   |/ /    | |_| | | |_| | | |___  | |_| | | |_| |
 *      \_____/ |___/|___/     \_____/ |_____/ |_____| \_____/ \_____/
 *
 *  Copyright (c) 2023 by OwOTeam-DGMT (OwOBlog).
 * @Date         : 2024-01-19 00:57:02
 * @Author       : HanskiJay
 * @LastEditors  : HanskiJay
 * @LastEditTime : 2024-01-19 18:40:17
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// models/json_driver.dart

import 'dart:convert';
import 'dart:io';

import 'package:todo_list_app/main.dart';

class JsonDriver {
  late String _fileName;
  late String _savePath;
  late String _filePath;
  late Map<dynamic, dynamic> _data;

  JsonDriver(String fileName, {String savePath = ''}) {
    _savePath = '${savePath.isEmpty ? Directory.current.path : savePath}/';
    _fileName = fileName;
    _filePath = '$_savePath$_fileName.json';
    _data = {};

    Application.createDirectory(_savePath);
    _initializeFile();
  }

  /// 静态调用方法
  static JsonDriver fromFile(String fileName, {String savePath = ''}) {
    JsonDriver jsonDriver = JsonDriver(fileName, savePath: savePath);
    jsonDriver._loadData();
    return jsonDriver;
  }

  void _initializeFile() {
    File file = File(_filePath);

    if (!file.existsSync()) {
      file.writeAsStringSync('{}');
    } else {
      _loadData();
    }
  }

  Map<dynamic, dynamic> get data {
    return _data;
  }

  void _loadData() {
    String contents = File(_filePath).readAsStringSync();
    _data = json.decode(contents);
  }

  void _saveData() {
    File file = File(_filePath);
    file.writeAsStringSync(json.encode(_data));
  }

  void updateSavePath(String path) {
    if (Application.moveFile(_filePath, path)) {
      _savePath = path;
      _filePath = '$_savePath$_fileName.json';
    }
    _loadData();
  }

  bool isEmpty() {
    return _data.isEmpty;
  }

  void writeData(Map<dynamic, dynamic> data) {
    _loadData();
    _data = data;
    _saveData();
  }

  void setData(dynamic index, dynamic newData) {
    _loadData();
    _data[index] = newData;
    _saveData();
  }

  void updateData(dynamic index, dynamic updatedData) {
    _loadData();

    if (_data.containsKey(index)) {
      _data[index] = updatedData;
      _saveData();
    } else {
      mainLogger.warning('Index {$index} out of bounds.');
    }
  }

  void deleteData(dynamic index) {
    _loadData();

    if (index >= 0 && index < _data.length) {
      _data.remove(index);
      _saveData();
    } else {
      mainLogger.warning('Index {$index} out of bounds.');
    }
  }

  dynamic getData(dynamic index) {
    _loadData();

    if (index >= 0 && index < _data.length) {
      return _data[index];
    } else {
      mainLogger.warning('Index out of bounds.');
      return null;
    }
  }

  static void generateMockData() {
    // 实例化对象时会创建一个本地 json 文件
    JsonDriver myJsonDriver = JsonDriver('myData');

    // 覆盖写入数据
    myJsonDriver.writeData({'name': 'John', 'age': 25});

    // 追加写入数据
    myJsonDriver.setData('gender', 'male');

    // 修改数据
    myJsonDriver.updateData('age', '30');

    // 获取数据
    dynamic retrievedData = myJsonDriver.getData('name');
    mainLogger.info('Retrieved Data: $retrievedData');

    // 删除数据
    myJsonDriver.deleteData(0);

    // 静态调用，从本地 json 文件读取数据并返回实例化 JSON 对象
    JsonDriver newJsonDriver = JsonDriver.fromFile('myData');
    mainLogger.info(newJsonDriver._data);
  }
}
