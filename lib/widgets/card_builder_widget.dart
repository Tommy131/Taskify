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
 * @LastEditTime : 2024-02-07 15:37:47
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// widgets/card_builder_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:numberpicker/numberpicker.dart';

class CardBuilderWidget {
  static Widget buildStandard({
    required String title,
    Widget? widget,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: widget,
        ),
      ),
    );
  }

  static Widget buildStandardColumn({
    required String title,
    required List<Widget> children,
  }) {
    return buildStandard(
      title: title,
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  static Widget buildWithCustomWidget({
    required String title,
    required Widget widget,
    String subtitle = '',
    void Function()? onPressed,
    String buttonText = 'Save',
  }) {
    return buildStandardColumn(
      title: title,
      children: [
        Text(subtitle),
        widget,
        const SizedBox(height: 10.0),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: onPressed,
            child: Text(buttonText),
          ),
        ),
      ],
    );
  }

  static Widget buildWithNumberPicker({
    required String title,
    required int currentValue,
    String subtitle = '',
    int minValue = 0,
    int maxValue = 100,
    required void Function(int) onNumberChanged,
    void Function()? onDataSave,
  }) {
    return buildWithCustomWidget(
      title: title,
      subtitle: subtitle,
      widget: NumberPicker(
        axis: Axis.horizontal,
        value: currentValue,
        minValue: minValue,
        maxValue: maxValue,
        onChanged: onNumberChanged,
      ),
      onPressed: onDataSave,
    );
  }

  static Widget buildWithColorPicker({
    required String title,
    required Color currentColor,
    required void Function(Color) onColorChanged,
    String subtitle = '',
    void Function()? onDataSave,
  }) {
    return buildWithCustomWidget(
      title: title,
      subtitle: subtitle,
      widget: SizedBox(
        height: 150.0,
        child: BlockPicker(
          pickerColor: currentColor,
          onColorChanged: onColorChanged,
        ),
      ),
      onPressed: onDataSave,
    );
  }

  static Widget buildWithField({
    required String title,
    required String currentValue,
    String subtitle = '',
    void Function(String)? onChanged,
    void Function()? onDataSave,
  }) {
    return buildWithCustomWidget(
      title: title,
      subtitle: subtitle,
      widget: TextFormField(
        initialValue: currentValue,
        keyboardType: TextInputType.text,
        onChanged: onChanged,
      ),
      onPressed: onDataSave,
    );
  }
}
