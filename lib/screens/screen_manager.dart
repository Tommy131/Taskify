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
 * @LastEditTime : 2024-02-07 03:41:22
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// screens/screen_manager.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:taskify/main.dart';
import 'package:taskify/core/update_checker.dart';
import 'package:taskify/models/task.dart';
import 'package:taskify/providers/todo_provider.dart';
import 'package:taskify/screens/donation_screen.dart';
import 'package:taskify/screens/todolist_screen.dart';
import 'package:taskify/screens/task_overview.dart';
import 'package:taskify/screens/focus_mode_screen.dart';
import 'package:taskify/screens/json_import_export_screen.dart';
import 'package:taskify/screens/bug_report_screen.dart';
import 'package:taskify/screens/about_screen.dart';
import 'package:taskify/screens/ester_egg_screen.dart';
import 'package:taskify/core/phone/phone.dart';
import 'package:taskify/screens/user_settings_screen.dart';

class ScreenManager extends StatefulWidget {
  const ScreenManager({super.key});

  @override
  State<ScreenManager> createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {
  int selectedIndex = 0;

  static const List<Widget> _pages = [
    TodolistScreen(),
    TaskOverViewScreen(),
    FocusModeScreen(),
    JsonImportExportScreen(),
    BugReportScreen(),
    DonationScreen(),
    AboutScreen(),
    UserSettingsScreen(),
    EsterEggScreen(),
  ];

  static const List<String> _pageTitles = [
    'Tasks',
    'Task Overview',
    'Focus Mode',
    'Import/Export Data',
    'Bug Report',
    'Donate HanskiJay :)',
    'About ${Application.appName}',
    'User Settings',
    isDebugMode ? 'Debug' : 'Rabbit :)',
  ];

  static const List<Icon> _pageIcons = [
    Icon(Icons.home),
    Icon(Icons.view_list),
    Icon(Icons.filter_center_focus),
    Icon(Icons.import_export),
    Icon(Icons.bug_report),
    Icon(Icons.volunteer_activism),
    Icon(Icons.info),
    Icon(Icons.settings),
    Icon(Icons.cruelty_free),
  ];

  @override
  void initState() {
    super.initState();
    // 先调用一次更新检测API, 以实现开启App后的第一次更新检测
    UpdateChecker.checkForUpdates(context);
    Timer.periodic(const Duration(hours: 1), (Timer timer) {
      UpdateChecker.checkForUpdates(context);
    });
    mainLogger.info('成功初始化更新检测服务.');

    // 初始化任务临期通知
    if (Platform.isAndroid || Platform.isIOS) {
      Map<String, dynamic> settings = Application.settings['notification']['settings'];
      Phone.notification.addNotification(
        'notificationTimer',
        timer: Timer.periodic(
          Duration(
            minutes: settings['frequencyInMinutes'] ?? 10,
            seconds: settings['frequencyInSeconds'] ?? 10,
          ),
          (Timer timer) {
            TodoProvider todoProvider = context.read<TodoProvider>();
            List<Task?> sortedTasks = [
              todoProvider.getUpcomingImportantTask(),
              todoProvider.getUpcomingTask(),
            ].where((element) => element != null).toList();
            if (sortedTasks.isNotEmpty) {
              if (Platform.isAndroid || Platform.isIOS) {
                for (Task? task in sortedTasks) {
                  if (task == null) return;
                  Phone.notification.showBigTextWithActionNotification(
                    title: 'Task "${task.title}" will expired soon!',
                    body: 'Click me to check more details.',
                    summary: '${task.category.name}\'s task will expired',
                    payload: {'navigate': 'true', 'taskInfo': jsonEncode(task.toJson())},
                  );
                }
              }
            }
          },
        ),
      );
      mainLogger.info('成功初始化任务临期通知.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Platform.isWindows
            ? (MediaQuery.of(context).size.width > UI.minimalWidthForWindows)
                ? _buildScreen(context, _screenOnWindows)
                : _buildScreen(context, _screenOnMobile)
            : _buildScreen(context, _screenOnMobile);
      },
    );
  }

  Scaffold _buildScreen(BuildContext context, Function(BuildContext) screenBuilder) {
    return screenBuilder(context) as Scaffold;
  }

  Scaffold _screenOnMobile(BuildContext context) {
    return Scaffold(
      appBar: UI.createAppBar(context, _pageTitles[selectedIndex]),
      body: UI.addAnimatedSwitcher(_pages[selectedIndex]),
      drawer: _buildDrawer(context),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade900,
            ),
            child: _buildDrawerHeaderContent(),
          ),
          ...List.generate(
            _pageTitles.length,
            (index) => _buildDrawerItem(context, index),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeaderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20.0),
        UI.getTaskifyLogo(),
        const Text(
          Application.appName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 10.0),
        const Text(
          'A free app developed by HanskiJay',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerItem(BuildContext context, int index) {
    return Container(
      color: selectedIndex == index ? Colors.lightBlue[100] : null,
      child: ListTile(
        leading: _pageIcons[index],
        title: Text(_pageTitles[index]),
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Scaffold _screenOnWindows(BuildContext context) {
    return Scaffold(
      // appBar: UI.createAppBar(context, _pageTitles[selectedIndex]),
      body: Row(
        children: [
          _buildNavigationRail(),
          Expanded(
            child: Container(
              color: UI.getTheme(context).colorScheme.primaryContainer,
              child: UI.addAnimatedSwitcher(_pages[selectedIndex]),
            ),
          ),
        ],
      ),
    );
  }

  LayoutBuilder _buildNavigationRail() {
    return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
                child: NavigationRail(
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(children: [
                      const SizedBox(width: 10.0),
                      const FlutterLogo(size: 32.0),
                      const Text(
                        '  +',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      UI.getTaskifyLogo(rounded: false, lowQuality: true),
                    ]),
                  ),
                ),
              ),
              elevation: 8.0,
              extended: MediaQuery.of(context).size.width >= UI.minimalExpandWidthForNavigation,
              selectedLabelTextStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              destinations: List.generate(
                _pageTitles.length,
                (index) => NavigationRailDestination(
                  icon: _pageIcons[index],
                  label: Text(_pageTitles[index]),
                ),
              ),
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) => setState(() => selectedIndex = value),
            )),
          ),
        );
      },
    );
  }
}
