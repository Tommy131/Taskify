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

import 'package:todolist_app/widgets/task_dialogs.dart';

class FunctionButtons extends StatelessWidget {
  const FunctionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildFloatingActionButton(
          context,
          Icons.playlist_add,
          const AddCategoryDialog(),
        ),
        const SizedBox(height: 10),
        _buildFloatingActionButton(
          context,
          Icons.delete_sweep,
          const DeleteCategoryDialog(),
        ),
        const SizedBox(height: 10),
        _buildFloatingActionButton(
          context,
          Icons.add,
          const AddTaskDialog(),
        ),
      ],
    );
  }

  FloatingActionButton _buildFloatingActionButton(
      BuildContext context, IconData icon, Widget dialog) {
    return FloatingActionButton(
      onPressed: () => _showDialog(context, dialog),
      child: Icon(icon),
    );
  }

  void _showDialog(BuildContext context, Widget widget) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return widget;
      },
    );
  }
}
