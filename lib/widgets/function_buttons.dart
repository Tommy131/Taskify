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
 * @LastEditTime : 2024-01-28 23:03:40
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// widgets/function_buttons.dart
import 'package:flutter/material.dart';

import 'package:taskify/widgets/task_dialogs.dart';

class FunctionButtons {
  static const List<String> functionLabels = [
    'Add Category',
    'Delete Category',
    'Add Task',
  ];

  static const List<Widget?> _dialogs = [
    AddCategoryDialog(),
    null,
    DeleteCategoryDialog(),
    null,
    AddTaskDialog(),
  ];

  static const List<Icon?> _buttonIcons = [
    Icon(Icons.playlist_add),
    null,
    Icon(Icons.delete_sweep),
    null,
    Icon(Icons.add),
  ];

  static List<Widget> buildList(BuildContext context) {
    return List.generate(
      _dialogs.length,
      (index) => _buildFloatingActionButton(
        context,
        _buttonIcons[index],
        _dialogs[index],
      ),
    );
  }

  static Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: buildList(context));
  }

  static Widget _buildFloatingActionButton(
      BuildContext context, Icon? icon, Widget? dialog) {
    return (dialog == null)
        ? const SizedBox(height: 10.0, width: 10.0)
        : FloatingActionButton(
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return dialog;
              },
            ),
            child: icon,
          );
  }
}
