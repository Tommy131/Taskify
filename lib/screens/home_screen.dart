/*
 *        _____   _          __  _____   _____   _       _____   _____
 *      /  _  \ | |        / / /  _  \ |  _  \ | |     /  _  \ /  ___|
 *      | | | | | |  __   / /  | | | | | |_| | | |     | | | | | |
 *      | | | | | | /  | / /   | | | | |  _  { | |     | | | | | |   _
 *      | |_| | | |/   |/ /    | |_| | | |_| | | |___  | |_| | | |_| |
 *      \_____/ |___/|___/     \_____/ |_____/ |_____| \_____/ \_____/
 *
 *  Copyright (c) 2023 by OwOTeam-DGMT (OwOBlog).
 * @Date         : 2024-01-19 21:26:22
 * @Author       : HanskiJay
 * @LastEditors  : HanskiJay
 * @LastEditTime : 2024-01-19 22:42:39
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo_list_app/providers/todo_provider.dart';
import 'package:todo_list_app/widgets/category_dropdown.dart';
import 'package:todo_list_app/widgets/category_buttons.dart';
import 'package:todo_list_app/widgets/task_list.dart';
import 'package:todo_list_app/widgets/task_dialogs.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List App'),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryDropdown(),
            CategoryButtons(),
            Expanded(
              child: TaskList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context, todoProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, TodoProvider todoProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddTaskDialog();
      },
    );
  }
}
