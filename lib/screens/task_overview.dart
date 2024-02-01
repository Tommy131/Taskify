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
 * @LastEditTime : 2024-02-01 22:02:18
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
/// screens/task_overview.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todolist_app/models/task.dart';
import 'package:todolist_app/providers/todo_provider.dart';
import 'package:todolist_app/widgets/capsule_tag.dart';

class TaskOverViewScreen extends StatefulWidget {
  const TaskOverViewScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TaskOverViewScreenState createState() => _TaskOverViewScreenState();
}

class _TaskOverViewScreenState extends State<TaskOverViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Here are all the tasks:'),
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          final sortedTasks = _sortTasks(todoProvider.tasks);

          return ListView.builder(
            itemCount: sortedTasks.length,
            itemBuilder: (context, index) {
              Task task = sortedTasks[index];
              Color tileColor = task.category.color;
              TextStyle textStyle = _getTextStyle(task);

              return Container(
                color: _getTileColor(task, tileColor),
                child: ListTile(
                  title: Row(
                    children: [
                      task.isImportant
                          ? CapsuleTag(
                              text: 'Important',
                              textColor:
                                  task.isCompleted ? Colors.grey : Colors.red,
                              backgroundColor: Colors.white,
                              fontWeight: FontWeight.bold,
                            )
                          : Container(),
                      task.isImportant
                          ? const SizedBox(width: 10.0)
                          : Container(),
                      CapsuleTag(
                        text: task.category.name,
                        textColor: task.isCompleted
                            ? Colors.grey
                            : task.category.color,
                        backgroundColor: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        task.title,
                        style: textStyle,
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'Due: ${DateFormat('yyyy-MM-dd').format(task.dueDate)}',
                    style: TextStyle(
                      color: task.isCompleted ? Colors.black45 : Colors.white,
                    ),
                  ),
                  trailing: _buildTaskIconButton(task),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<Task> _sortTasks(List<Task> tasks) {
    return tasks
      ..sort((a, b) {
        int completionComparison = a.isCompleted ? 1 : -1;
        int dateComparison = a.dueDate.compareTo(b.dueDate);
        int importanceComparison = a.isImportant ? -1 : 1;

        return completionComparison != 0
            ? completionComparison
            : dateComparison != 0
                ? dateComparison
                : importanceComparison;
      });
  }

  Color _getTileColor(Task task, Color tileColor) {
    if (task.isCompleted) {
      return tileColor.withOpacity(0.5);
    } else {
      return tileColor.withOpacity(!task.isImportant ? 0.8 : 1);
    }
  }

  TextStyle _getTextStyle(Task task) {
    Color textColor = Colors.black;
    FontWeight fontWeight = FontWeight.normal;
    TextDecoration decoration = TextDecoration.none;

    if (task.isCompleted) {
      textColor = textColor.withOpacity(0.6);
      decoration = TextDecoration.lineThrough;
      if (task.isImportant) {
        fontWeight = FontWeight.bold;
      }
    } else {
      textColor = Colors.white;
      if (task.isImportant) {
        fontWeight = FontWeight.bold;
      }
    }

    return TextStyle(
      color: textColor,
      fontWeight: fontWeight,
      decoration: decoration,
    );
  }

  Widget _buildTaskIconButton(Task task) {
    return IconButton(
      icon: Icon(
        task.isCompleted ? Icons.task_alt : Icons.radio_button_unchecked,
      ),
      onPressed: () {},
      color: task.isCompleted ? Colors.green : Colors.white,
    );
  }
}
