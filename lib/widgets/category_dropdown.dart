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
 * @LastEditTime : 2024-01-21 03:55:37
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// widgets/category_dropdown.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:taskify/models/category.dart';
import 'package:taskify/models/task.dart';
import 'package:taskify/providers/todo_provider.dart';

class CategoryDropdown extends StatelessWidget {
  static const int triggerNormal = 0;
  static const int triggerChangeTaskCategory = 1;

  final int triggerMode;
  final Task? task;

  const CategoryDropdown({super.key, this.triggerMode = 0, this.task});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: todoProvider.selectedCategory,
        onChanged: (String? newCategoryName) {
          if (newCategoryName != null) {
            todoProvider.changeCategory(newCategoryName);

            if (triggerMode == triggerChangeTaskCategory) {
              todoProvider.updateTaskDetails(
                task!,
                category: todoProvider.getCategoryByName(newCategoryName),
              );
            }
          }
        },
        items: todoProvider.categories.values.map<DropdownMenuItem<String>>(
          (Category category) {
            return DropdownMenuItem<String>(
              value: category.name,
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    color: category.color,
                  ),
                  const SizedBox(width: 8.0),
                  Text(category.name),
                ],
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
