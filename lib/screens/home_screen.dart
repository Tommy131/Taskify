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
 * @LastEditTime : 2024-01-21 02:15:24
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// screens/home_screen.dart
import 'package:flutter/material.dart';

import 'package:todolist_app/main.dart';
import 'package:todolist_app/widgets/category_dropdown.dart';
import 'package:todolist_app/widgets/function_buttons.dart';
import 'package:todolist_app/widgets/task_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UI.createAppBar(context, 'Todo List'),
      backgroundColor: Colors.white30,
      body: Container(
        padding: UI.getStandardPaddingData(),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryDropdown(),
            Expanded(
              child: TaskList(),
            ),
          ],
        ),
      ),
      floatingActionButton: const FunctionButtons(),
    );
  }
}
