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
 * @LastEditTime : 2024-01-27 01:50:56
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// widgets/task_dialogs.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:todolist_app/main.dart';

import 'package:todolist_app/models/category.dart';
import 'package:todolist_app/models/task.dart';
import 'package:todolist_app/providers/todo_provider.dart';
import 'package:todolist_app/widgets/category_dropdown.dart';

class AddTaskDialog extends StatelessWidget {
  const AddTaskDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    TextEditingController titleController = TextEditingController();
    TextEditingController remarkController = TextEditingController();

    return AlertDialog(
      title: const Text('Add Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: UI.input('Enter task title'),
          ),
          const SizedBox(height: 10),
          TextField(
            maxLines: 2,
            controller: remarkController,
            decoration: UI.input('Add a Remark...'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            String taskTitle = titleController.text;
            if (taskTitle.isNotEmpty) {
              Task newTask = Task(
                title: taskTitle,
                remark: remarkController.text,
                category: todoProvider.getCurrentCategory(),
                creationDate: DateTime.now(),
              );
              todoProvider.addTask(newTask);
            }
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class EditTaskDialog extends StatelessWidget {
  final Task task;

  const EditTaskDialog({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    TextEditingController titleController =
        TextEditingController(text: task.title);
    TextEditingController remarkController =
        TextEditingController(text: task.remark);
    double maxWidth = UI.getMaxWidth(context);

    List<Widget> children = [
      const Text('Change Category to: '),
      const SizedBox(width: 10),
      CategoryDropdown(
        triggerMode: CategoryDropdown.triggerChangeTaskCategory,
        task: task,
      ),
    ];

    return AlertDialog(
      title: const Text('Edit Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: UI.input('Edit title'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: remarkController,
            decoration: UI.input('Edit remark'),
          ),
          maxWidth >= 460
              ? Row(children: children)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [const SizedBox(height: 10), ...children],
                ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            String newTitle = titleController.text;
            String remark = remarkController.text;
            if (newTitle.isNotEmpty) {
              todoProvider.updateTaskDetails(
                task,
                title: newTitle,
                remark: remark,
              );
            }
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class DeleteTaskDialog extends StatelessWidget {
  final Task task;

  const DeleteTaskDialog({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return AlertDialog(
      title: const Text('Delete Task'),
      content: const Text('Are you sure you want to delete this task?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            todoProvider.deleteTask(task);
            Navigator.of(context).pop();
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

class AddCategoryDialog extends StatelessWidget {
  const AddCategoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    TextEditingController controller = TextEditingController();
    Color selectedColor = Colors.blue; // Default color

    return AlertDialog(
      title: const Text('Add Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration: UI.input('Enter category name'),
          ),
          const SizedBox(height: 10),
          BlockPicker(
            pickerColor: selectedColor,
            onColorChanged: (color) {
              selectedColor = color;
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            String categoryName = controller.text;
            if (categoryName.isNotEmpty) {
              Category newCategory =
                  Category(name: categoryName, color: selectedColor);
              todoProvider.addCategory(newCategory);
              todoProvider.changeCategory(categoryName);
            }
            Navigator.of(context).pop();
            UI.showStandardDialog(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class DeleteCategoryDialog extends StatelessWidget {
  const DeleteCategoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final categories = todoProvider.categories;

    return AlertDialog(
      title: const Text('Delete Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Select a category to delete:'),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: todoProvider.selectedCategory ==
                    Application.defaultCategory.name
                ? null
                : todoProvider.selectedCategory,
            onChanged: (String? selectedCategory) {
              if (selectedCategory != null) {
                todoProvider.changeCategory(selectedCategory);
              }
            },
            items: categories.entries
                .where((element) =>
                    element.key != Application.defaultCategory.name)
                .map<DropdownMenuItem<String>>(
              (MapEntry element) {
                return DropdownMenuItem<String>(
                  value: element.value.name,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: element.value.color,
                      ),
                      const SizedBox(width: 8),
                      Text(element.key),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: todoProvider.selectedCategory ==
                  Application.defaultCategory.name
              ? null // Disable the button if there is only one category
              : () {
                  Navigator.of(context).pop();
                  UI.showConfirmationDialog(context,
                      confirmMessage:
                          'Delete Category: "${todoProvider.selectedCategory}"',
                      onCall: () {
                    todoProvider
                        .deleteCategoryWithName(todoProvider.selectedCategory);
                  });
                },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
