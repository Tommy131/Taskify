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
 * @LastEditTime : 2024-02-05 22:27:21
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// app.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskify/main.dart';

import 'package:taskify/providers/todo_provider.dart';
import 'package:taskify/screens/screen_manager.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();

  static void run() {
    runApp(const MyApp());
  }
}

class _MyAppState extends State<MyApp> {
  bool _canPop = false;

  void _togglePopState() {
    setState(() {
      _canPop = !_canPop;
    });
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
        home: PopScope(
          canPop: _canPop,
          onPopInvoked: (didPop) async {
            if (didPop) {
              return;
            }

            if (_canPop) {
              Navigator.of(context).pop(true);
            } else {
              UI.showBottomSheet(
                context: context,
                message: 'Please confirm your process once again to exit the app.',
              );
            }
            _togglePopState();
            // 如果用户2秒后没有进行同样的操作, 触发该规则
            Timer(const Duration(seconds: 2), () => _togglePopState());
          },
          child: const ScreenManager(),
        ),
      ),
    );
  }
}
