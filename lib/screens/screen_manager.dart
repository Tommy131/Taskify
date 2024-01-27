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
 * @LastEditTime : 2024-01-26 00:52:18
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// screens/screen_manager.dart
import 'package:flutter/material.dart';
import 'package:todolist_app/main.dart';

import 'package:todolist_app/screens/about_screen.dart';
import 'package:todolist_app/screens/bug_report_screen.dart';
import 'package:todolist_app/screens/todolist_screen.dart';
import 'package:todolist_app/screens/widget_test_screen.dart';

class ScreenManager extends StatefulWidget {
  const ScreenManager({super.key});

  @override
  State<ScreenManager> createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {
  int selectedIndex = 0;

  static const Map<int, Widget> _pages = {
    0: TodolistScreen(),
    1: AboutScreen(),
    2: BugReportScreen(),
    3: WidgetTestScreen(),
  };

  static const List<NavigationRailDestination> destinations = [
    NavigationRailDestination(
      icon: Icon(Icons.home),
      label: Text('Todo List'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.help),
      label: Text('About'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.bug_report),
      label: Text('Bug Report'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.cruelty_free),
      label: Text('Widget Test'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              trailing: const Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: FlutterLogo(),
                  ),
                ),
              ),
              elevation: 8.0,
              extended: constraints.maxWidth >= 900.0,
              selectedLabelTextStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              destinations: destinations,
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
            Expanded(
              child: Container(
                color: UI.getTheme(context).colorScheme.primaryContainer,
                child: _pages[selectedIndex],
              ),
            ),
          ],
        ),
      );
    });
  }
}
