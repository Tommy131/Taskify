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
 * @LastEditTime : 2024-02-02 16:23:29
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
/// widgets/task_tile_builder.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskify/models/task.dart';
import 'package:taskify/widgets/capsule_tag.dart';

class TaskTileBuilder {
  static Container buildTaskTile(BuildContext context, Task task,
      {bool withIcon = true}) {
    Color tileColor = task.category.color;
    TextStyle textStyle = getTextStyle(task);

    return Container(
      color: getTileColor(task, tileColor),
      child: ListTile(
        title: buildTitle(context, task),
        subtitle: Text(
          'Due: ${DateFormat('yyyy-MM-dd').format(task.dueDate)}',
          style: textStyle,
        ),
        trailing: withIcon ? buildTaskIconButton(task) : null,
      ),
    );
  }

  static Widget buildTitle(BuildContext context, Task task) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 300;

    List<Widget> importantTag = [
      if (task.isImportant)
        buildCapsuleTag(
          'Important',
          task.isCompleted ? Colors.grey : Colors.red,
        ),
      if (task.isImportant && !isSmallScreen) const SizedBox(width: 10.0),
    ];
    CapsuleTag categoryTag = buildCapsuleTag(
      task.category.name,
      task.isCompleted ? Colors.grey : task.category.color,
    );
    Text text = Text(
      task.title,
      style: getTextStyle(task),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !isSmallScreen
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...importantTag,
                  categoryTag,
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...importantTag,
                  const SizedBox(height: 10.0),
                  categoryTag,
                ],
              ),
        const SizedBox(width: 10.0),
        text,
      ],
    );
  }

  static CapsuleTag buildCapsuleTag(String text, Color textColor) {
    return CapsuleTag(
      text: text,
      textColor: textColor,
      backgroundColor: Colors.white,
      fontWeight: FontWeight.bold,
    );
  }

  static Color getTileColor(Task task, Color tileColor) {
    if (task.isCompleted) {
      return tileColor.withOpacity(0.5);
    } else {
      return tileColor.withOpacity(!task.isImportant ? 0.8 : 1);
    }
  }

  static TextStyle getTextStyle(
    Task task, {
    double? fontSize,
    FontStyle? fontStyle,
  }) {
    Color textColor =
        task.isCompleted ? Colors.black.withOpacity(0.6) : Colors.white;
    FontWeight fontWeight =
        task.isImportant ? FontWeight.bold : FontWeight.normal;
    TextDecoration decoration =
        task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none;

    return TextStyle(
      color: textColor,
      fontSize: fontSize,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
      decoration: decoration,
    );
  }

  static IconButton buildTaskIconButton(Task task) {
    return IconButton(
      icon: Icon(
        task.isCompleted ? Icons.task_alt : Icons.radio_button_unchecked,
      ),
      onPressed: () {},
      color: task.isCompleted ? Colors.green : Colors.white,
    );
  }
}
