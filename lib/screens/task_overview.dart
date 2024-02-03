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
 * @LastEditTime : 2024-02-02 18:07:34
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
/// screens/task_overview.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskify/models/task.dart';
import 'package:taskify/providers/todo_provider.dart';
import 'package:taskify/widgets/task_tile_builder.dart';

class TaskOverViewScreen extends StatefulWidget {
  const TaskOverViewScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TaskOverViewScreenState createState() => _TaskOverViewScreenState();
}

class _TaskOverViewScreenState extends State<TaskOverViewScreen> {
  late TodoProvider _todoProvider;

  @override
  Widget build(BuildContext context) {
    _todoProvider = context.read<TodoProvider>();
    final sortedTasks = _todoProvider.reorderTasks();

    if (sortedTasks.isEmpty) {
      return const Center(child: Text('Here is nothing to do :)'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Here are all the tasks:'),
      ),
      body: ListView.builder(
        itemCount: sortedTasks.length,
        itemBuilder: (context, index) {
          Task task = sortedTasks[index];
          return TaskTileBuilder.buildTaskTile(context, task);
        },
      ),
    );
  }
}
