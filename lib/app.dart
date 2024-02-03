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
 * @LastEditTime : 2024-01-26 21:49:35
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskify/main.dart';

import 'package:taskify/providers/todo_provider.dart';
import 'package:taskify/screens/screen_manager.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static void run() {
    runApp(const MyApp());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: MaterialApp(
        title: Application.appName,
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              fontFamily: 'Roboto',
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: UnderlineInputBorder(borderSide: BorderSide(width: 3.0)),
            filled: true,
            fillColor: Colors.white60,
            hintStyle: TextStyle(
              color: Colors.white54,
            ),
            contentPadding: EdgeInsets.all(12),
          ),
        ),
        home: const ScreenManager(),
      ),
    );
  }
}
