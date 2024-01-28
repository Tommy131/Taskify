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
 * @LastEditTime : 2024-01-28 23:28:34
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

class TodolistScreen extends StatefulWidget {
  const TodolistScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TodolistScreenState createState() => _TodolistScreenState();
}

class _TodolistScreenState extends State<TodolistScreen> {
  bool isListVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isListVisible ? 200 : 0,
            curve: Curves.easeInOut,
            child: Visibility(
              visible: isListVisible,
              child: FunctionButtons.build(context),
            ),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                isListVisible = !isListVisible;
              });
            },
            child: Icon(isListVisible ? Icons.expand_more : Icons.expand_less),
          ),
        ],
      ),
    );
  }
}
