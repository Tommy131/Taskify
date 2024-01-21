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
 * @LastEditTime : 2024-01-21 02:43:37
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// widgets/task_list.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo_list_app/main.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/providers/todo_provider.dart';
import 'package:todo_list_app/widgets/task_dialogs.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return ListView.builder(
      itemCount: todoProvider.filteredTasks.length,
      itemBuilder: (context, index) {
        Task task = todoProvider.filteredTasks[index];
        return TaskListItem(task: task);
      },
    );
  }
}

class TaskListItem extends StatelessWidget {
  final Task task;

  const TaskListItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return UI.decoratedContainer(
        ListTile(
          title: Text(
            task.isImportant ? '${task.title} (Important)' : task.title,
            style: TextStyle(
              fontWeight:
                  task.isImportant ? FontWeight.bold : FontWeight.normal,
              color: task.isCompleted
                  ? Colors.grey
                  : (task.isImportant ? Colors.red : Colors.black),
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            'Created on: ${task.creationDate.toString()}',
          ),
          trailing: TaskActions(task: task),
        ), onTapCall: () {
      TaskActions.showEditTaskDialog(context, task);
    });
  }
}

class TaskActions extends StatelessWidget {
  final Task task;

  const TaskActions({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        /* IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            showEditTaskDialog(context, task);
          },
        ), */
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            showDeleteTaskDialog(context, task);
          },
        ),
        IconButton(
          icon: Icon(Icons.notification_important,
              color: task.isImportant ? Colors.red : Colors.grey.shade500),
          onPressed: () {
            todoProvider.toggleTaskImportance(task);
          },
        ),
        IconButton(
          icon: Icon(
              task.isCompleted ? Icons.task_alt : Icons.radio_button_unchecked,
              color: task.isCompleted ? Colors.green : Colors.grey.shade500),
          onPressed: () {
            todoProvider.toggleTaskCompletion(task);
          },
        ),
      ],
    );
  }

  static void showEditTaskDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditTaskDialog(task: task);
      },
    );
  }

  static void showDeleteTaskDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteTaskDialog(task: task);
      },
    );
  }
}
