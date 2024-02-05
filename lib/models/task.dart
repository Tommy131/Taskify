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
 * @LastEditTime : 2024-01-31 20:55:26
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// models/task.dart

import 'package:taskify/models/category.dart';

class Task {
  static final DateTime defaultDate = DateTime(1990, 1, 1);
  String title;
  String remark;
  Category category;
  DateTime creationDate;
  DateTime dueDate;
  bool isCompleted;
  bool isImportant;

  Task({
    required this.title,
    required this.category,
    required this.creationDate,
    required this.dueDate,
    this.remark = 'No Remark',
    this.isCompleted = false,
    this.isImportant = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      remark: json['remark'],
      category: Category.fromJson(json),
      creationDate: DateTime.parse(json['creationDate']),
      dueDate: DateTime.parse(json['dueDate']),
      isCompleted: json['isCompleted'],
      isImportant: json['isImportant'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'remark': remark,
      'category': category.name,
      'creationDate': creationDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
      'isImportant': isImportant,
    };
  }

  void updateTaskDetails({
    String? title,
    String? remark,
    DateTime? dueDate,
    bool? isCompleted,
    bool? isImportant,
    Category? category,
  }) {
    this.title = title ?? this.title;
    this.remark = remark ?? this.remark;
    this.dueDate = dueDate ?? this.dueDate;
    this.isCompleted = isCompleted ?? this.isCompleted;
    this.isImportant = isImportant ?? this.isImportant;
    this.category = category ?? this.category;
  }
}
