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
 * @LastEditTime : 2024-02-01 01:28:38
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// models/dialog.dart
import 'package:flutter/material.dart';

class CustomDialog {
  late MainAxisAlignment mainAxisAlignment;
  late MainAxisSize mainAxisSize;
  late CrossAxisAlignment crossAxisAlignment;
  late TextDirection? textDirection;
  late VerticalDirection verticalDirection;
  late TextBaseline? textBaseline;

  static Widget buildAlertDialog({
    required BuildContext context,
    required String title,
    required List<Widget> content,
    required List<Widget> actions,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.min,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
  }) {
    double screenHeight = MediaQuery.of(context).size.height;
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        physics: screenHeight < 200
            ? const ClampingScrollPhysics()
            : const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          textDirection: textDirection,
          verticalDirection: verticalDirection,
          textBaseline: textBaseline,
          children: content,
        ),
      ),
      actions: actions,
      actionsOverflowDirection: VerticalDirection.up,
    );
  }
}
