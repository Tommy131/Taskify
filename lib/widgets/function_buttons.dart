/*
 *        _____   _          __  _____   _____   _       _____   _____
 *      /  _  \ | |        / / /  _  \ |  _  \ | |     /  _  \ /  ___|
 *      | | | | | |  __   / /  | | | | | |_| | | |     | | | | | |
 *      | | | | | | /  | / /   | | | | |  _  { | |     | | | | | |   _
 *      | |_| | | |/   |/ /    | |_| | | |_| | | |___  | |_| | | |_| |
 *      \_____/ |___/|___/     \_____/ |_____/ |_____| \_____/ \_____/
 *
 *  Copyright (c) 2023 by OwOTeam-DGMT (OwOBlog).
 * @Date         : 2024-01-19 21:24:52
 * @Author       : HanskiJay
 * @LastEditors  : HanskiJay
 * @LastEditTime : 2024-01-19 22:18:08
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// widgets/function_buttons.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo_list_app/providers/todo_provider.dart';
import 'package:todo_list_app/widgets/task_dialogs.dart';

class FunctionButtons extends StatelessWidget {
  const FunctionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: () {
            _showAddCategoryDialog(context);
          },
          child: const Icon(Icons.playlist_add),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          onPressed: () {
            _showDeleteCategoryDialog(context);
          },
          child: const Icon(Icons.delete_sweep),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          onPressed: () {
            _showAddTaskDialog(context, todoProvider);
          },
          child: const Icon(Icons.add),
        ),
      ],
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

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddCategoryDialog();
      },
    );
  }

  void _showDeleteCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const DeleteCategoryDialog();
      },
    );
  }
}
