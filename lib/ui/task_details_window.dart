/*
 *        _____   _          __  _____   _____   _       _____   _____
 *      /  _  \ | |        / / /  _  \ |  _  \ | |     /  _  \ /  ___|
 *      | | | | | |  __   / /  | | | | | |_| | | |     | | | | | |
 *      | | | | | | /  | / /   | | | | |  _  { | |     | | | | | |   _
 *      | |_| | | |/   |/ /    | |_| | | |_| | | |___  | |_| | | |_| |
 *      \_____/ |___/|___/     \_____/ |_____/ |_____| \_____/ \_____/
 *
 *  Copyright (c) 2023 by OwOTeam-DGMT (OwOBlog).
 * @Date         : 2024-02-07 03:35:05
 * @Author       : HanskiJay
 * @LastEditors  : HanskiJay
 * @LastEditTime : 2024-02-07 04:06:29
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// ui/task_details_window.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskify/core/phone/notification_service.dart';

import 'package:taskify/models/category.dart';
import 'package:taskify/providers/todo_provider.dart';
import 'package:taskify/widgets/custom_dialog_widget.dart';

class TaskDetailsWindow extends StatelessWidget {
  final String taskString;

  const TaskDetailsWindow({super.key, required this.taskString});

  @override
  Widget build(BuildContext context) {
    TodoProvider todoProvider = Provider.of<TodoProvider>(context);
    Map<String, dynamic> json = jsonDecode(taskString);
    Category? category = todoProvider.categories[json['category']];
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.5),
      body: CustomDialogWidget.build(
        context: context,
        title: json['title']!,
        content: [
          Text(
            'Category: ${category!.name}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Due Date: ${json['dueDate'].toString()}',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Remark: ${json['remark']}',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Go back'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              NotificationService.removeNotification('notificationTimer');
            },
            child: const Text('Do not show me again'),
          ),
        ],
      ),
    );
  }
}
