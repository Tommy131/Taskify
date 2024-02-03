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
 * @LastEditTime : 2024-02-01 02:07:28
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// widgets/task_dialogs.dart
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import 'package:taskify/main.dart';
import 'package:taskify/models/category.dart';
import 'package:taskify/models/task.dart';
import 'package:taskify/widgets/custom_dialog.dart';
import 'package:taskify/providers/todo_provider.dart';
import 'package:taskify/widgets/category_dropdown.dart';

class TaskDialog extends StatelessWidget {
  final String title;
  final List<Widget> content;
  final void Function()? onPressed;
  final CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center;

  const TaskDialog({
    Key? key,
    required this.title,
    required this.content,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog.buildAlertDialog(
      context: context,
      title: title,
      content: content,
      crossAxisAlignment: crossAxisAlignment,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onPressed ?? () {},
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

class AddTaskDialog extends StatelessWidget {
  const AddTaskDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    TextEditingController titleController = TextEditingController();
    TextEditingController remarkController = TextEditingController();
    TextEditingController dueDateController = TextEditingController();

    remarkController.text = 'No Remark';
    DateTime dueDate = DateTime.now().add(const Duration(days: 2));
    dueDateController.text = dueDate.toString();

    return TaskDialog(
      title: 'Add Task',
      content: [
        TextField(
          controller: titleController,
          decoration: UI.input('Enter task title'),
        ),
        const SizedBox(height: 10.0),
        TextField(
          maxLines: 5,
          controller: remarkController,
          decoration: UI.input('Add a Remark...'),
        ),
        const SizedBox(height: 10.0),
        const Text('Due to Date:'),
        const SizedBox(height: 5.0),
        TextField(
          controller: dueDateController,
          decoration: UI.input('Pick a due date...'),
        ),
        const SizedBox(height: 10.0),
        UI.addPickDateTimeButton(context, dueDate, onResult: (value) {
          dueDate = value ?? dueDate;
          dueDateController.text = dueDate.toString();
        }),
      ],
      onPressed: () {
        String taskTitle = titleController.text;
        if (taskTitle.isNotEmpty) {
          Task newTask = Task(
            title: taskTitle,
            remark: remarkController.text,
            category: todoProvider.getCurrentCategory(),
            creationDate: DateTime.now(),
            dueDate: dueDate,
          );
          todoProvider.addTask(newTask);
          Navigator.of(context).pop();
          UI.showBottomSheet(context: context, message: 'Success.');
        }
      },
    );
  }
}

class EditTaskDialog extends StatelessWidget {
  final Task task;

  const EditTaskDialog({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    double maxWidth = UI.getMaxWidth(context);
    final todoProvider = Provider.of<TodoProvider>(context);

    TextEditingController titleController = TextEditingController(
      text: task.title,
    );
    TextEditingController remarkController = TextEditingController(
      text: task.remark,
    );
    TextEditingController dueDateController = TextEditingController(
      text: (task.dueDate).toString(),
    );
    DateTime dueDate = DateTime.now().add(const Duration(days: 2));

    List<Widget> children = [
      const Text('Change Category to: '),
      const SizedBox(width: 10),
      CategoryDropdown(
        triggerMode: CategoryDropdown.triggerChangeTaskCategory,
        task: task,
      ),
    ];

    return TaskDialog(
      title: 'Edit Task',
      content: [
        TextField(
          controller: titleController,
          decoration: UI.input('Edit title'),
        ),
        const SizedBox(height: 10.0),
        TextField(
          maxLines: 5,
          controller: remarkController,
          decoration: UI.input('Edit remark'),
        ),
        maxWidth >= 460
            ? Row(children: children)
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [const SizedBox(height: 10.0), ...children],
              ),
        const Text('Due to Date:'),
        const SizedBox(height: 5.0),
        TextField(
          controller: dueDateController,
          decoration: UI.input('Pick a due date...'),
        ),
        const SizedBox(height: 10.0),
        UI.addPickDateTimeButton(context, dueDate, onResult: (value) {
          dueDate = value ?? dueDate;
          dueDateController.text = dueDate.toString();
        }),
      ],
      onPressed: () {
        String newTitle = titleController.text;
        String remark = remarkController.text;
        if (newTitle.isNotEmpty) {
          todoProvider.updateTaskDetails(
            task,
            title: newTitle,
            remark: remark,
            dueDate: dueDate,
          );
          UI.showBottomSheet(context: context, message: 'Success.');
        }
        Navigator.of(context).pop();
      },
    );
  }
}

class DeleteTaskDialog extends StatelessWidget {
  final Task task;

  const DeleteTaskDialog({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return TaskDialog(
      title: 'Delete Task',
      content: const [
        Text('Are you sure you want to delete this task?'),
      ],
      onPressed: () {
        todoProvider.deleteTask(task);
        Navigator.of(context).pop();
        UI.showBottomSheet(context: context, message: 'Success.');
      },
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

    return TaskDialog(
      title: 'Add Category',
      content: [
        TextField(
          controller: controller,
          decoration: UI.input('Enter category name'),
        ),
        const SizedBox(height: 10.0),
        BlockPicker(
          pickerColor: selectedColor,
          onColorChanged: (color) {
            selectedColor = color;
          },
        ),
      ],
      onPressed: () {
        String categoryName = controller.text;
        if (categoryName.isNotEmpty) {
          Category newCategory =
              Category(name: categoryName, color: selectedColor);
          todoProvider.addCategory(newCategory);
          todoProvider.changeCategory(categoryName);
          Navigator.of(context).pop();
          UI.showStandardDialog(context);
        }
      },
    );
  }
}

class DeleteCategoryDialog extends StatelessWidget {
  const DeleteCategoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final categories = todoProvider.categories;

    return TaskDialog(
      title: 'Delete Category',
      content: [
        const Text('Select a category to delete:'),
        const SizedBox(height: 10.0),
        DropdownButton<String>(
          value:
              todoProvider.selectedCategory == Application.defaultCategory.name
                  ? null
                  : todoProvider.selectedCategory,
          onChanged: (String? selectedCategory) {
            if (selectedCategory != null) {
              todoProvider.changeCategory(selectedCategory);
            }
          },
          items: categories.entries
              .where(
                  (element) => element.key != Application.defaultCategory.name)
              .map<DropdownMenuItem<String>>(
            (MapEntry element) {
              return DropdownMenuItem<String>(
                value: element.value.name,
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20.0,
                      color: element.value.color,
                    ),
                    const SizedBox(width: 8.0),
                    Text(element.key),
                  ],
                ),
              );
            },
          ).toList(),
        ),
      ],
      onPressed: todoProvider.selectedCategory ==
              Application.defaultCategory.name
          ? null // Disable the button if there is only one category
          : () {
              Navigator.of(context).pop();
              UI.showConfirmationDialog(
                context,
                confirmMessage:
                    'Delete Category: "${todoProvider.selectedCategory}"',
                onConfirmed: () {
                  todoProvider
                      .deleteCategoryWithName(todoProvider.selectedCategory);
                },
              );
            },
    );
  }
}
