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
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:todolist_app/main.dart';
import 'package:todolist_app/models/task.dart';
import 'package:todolist_app/providers/todo_provider.dart';
import 'package:todolist_app/widgets/task_dialogs.dart';
import 'package:todolist_app/widgets/important_label.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    if (todoProvider.filteredTasks.isEmpty) {
      return const Center(
        child: Text('Here is nothing to do :)'),
      );
    } else {
      return ListView.builder(
        itemCount: todoProvider.filteredTasks.length,
        itemBuilder: (context, index) {
          Task task = todoProvider.filteredTasks[index];
          return TaskListItem(task: task);
        },
      );
    }
  }
}

class TaskListItem extends StatelessWidget {
  final Task task;

  const TaskListItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      UI.decoratedContainer(
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 15.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: task.isImportant
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: task.isCompleted
                            ? Colors.grey
                            : (task.isImportant ? Colors.red : Colors.black),
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Created on: ${DateFormat('yyyy-MM-dd').format(task.creationDate)}',
                      style: TextStyle(
                        color: task.isCompleted
                            ? Colors.grey
                            : (task.isImportant ? Colors.red : Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              TaskActions(task: task),
            ],
          ),
        ),
        onTapCall: () {
          TaskActions.showEditTaskDialog(context, task);
        },
      ),
      task.isImportant
          ? Positioned(
              left: 0,
              top: 2.0,
              child: ImportantLabel.put(
                color: !task.isCompleted ? Colors.red : Colors.grey,
              ),
            )
          : Container(),
    ]);
  }
}

class TaskActions extends StatelessWidget {
  final Task task;

  const TaskActions({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    double maxWidth = UI.getMaxWidth(context);

    return maxWidth >= 500
        ? buildActions(context, todoProvider, task)
        : buildPopupMenuButton(context, todoProvider, task);
  }

  Widget buildActions(
      BuildContext context, TodoProvider todoProvider, Task task) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIconButton(Icons.edit, () => showEditTaskDialog(context, task)),
        _buildIconButton(
            Icons.delete, () => showDeleteTaskDialog(context, task)),
        _buildIconButton(
          Icons.notification_important,
          () => todoProvider.toggleTaskImportance(task),
          color: task.isImportant ? Colors.red : Colors.grey.shade500,
        ),
        _buildIconButton(
          task.isCompleted ? Icons.task_alt : Icons.radio_button_unchecked,
          () => todoProvider.toggleTaskCompletion(task),
          color: task.isCompleted ? Colors.green : Colors.grey.shade500,
        ),
      ],
    );
  }

  Widget buildPopupMenuButton(
      BuildContext context, TodoProvider todoProvider, Task task) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        _buildPopupMenuItem(Icons.edit, "Edit", 0),
        _buildPopupMenuItem(Icons.delete, "Delete", 1),
        _buildPopupMenuItem(
          Icons.notification_important,
          task.isImportant ? "Mark as Normal" : "Mark as Important",
          2,
          color: task.isImportant ? Colors.red : Colors.grey.shade500,
        ),
        _buildPopupMenuItem(
          task.isCompleted ? Icons.task_alt : Icons.radio_button_unchecked,
          task.isCompleted ? "Mask as TODO" : "Mark as Completed",
          3,
          color: task.isCompleted ? Colors.green : Colors.grey.shade500,
        ),
      ],
      onSelected: (int value) {
        switch (value) {
          case 0:
            showEditTaskDialog(context, task);
            break;
          case 1:
            showDeleteTaskDialog(context, task);
            break;
          case 2:
            todoProvider.toggleTaskImportance(task);
            break;
          case 3:
            todoProvider.toggleTaskCompletion(task);
            break;
        }
      },
      child: const Icon(Icons.more_vert),
    );
  }

  Widget _buildIconButton(IconData icon, Function onPressed, {Color? color}) {
    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: onPressed as void Function()?,
    );
  }

  PopupMenuItem<int> _buildPopupMenuItem(IconData icon, String text, int value,
      {Color? color}) {
    return PopupMenuItem<int>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8.0),
          Text(text),
        ],
      ),
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
