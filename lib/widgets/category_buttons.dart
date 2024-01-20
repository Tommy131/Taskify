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
// widgets/category_buttons.dart
import 'package:flutter/material.dart';
import 'package:todo_list_app/widgets/task_dialogs.dart';

class CategoryButtons extends StatelessWidget {
  const CategoryButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            _showAddCategoryDialog(context);
          },
          child: const Text('Add Category'),
        ),
        ElevatedButton(
          onPressed: () {
            _showDeleteCategoryDialog(context);
          },
          child: const Text('Delete Category'),
        ),
      ],
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
