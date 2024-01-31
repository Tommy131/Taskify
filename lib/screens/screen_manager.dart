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
 * @LastEditTime : 2024-01-29 16:18:24
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// screens/screen_manager.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:todolist_app/main.dart';
import 'package:todolist_app/core/update_checker.dart';
import 'package:todolist_app/screens/about_screen.dart';
import 'package:todolist_app/screens/bug_report_screen.dart';
import 'package:todolist_app/screens/json_import_export_screen.dart';
import 'package:todolist_app/screens/todolist_screen.dart';
import 'package:todolist_app/screens/ester_egg_screen.dart';

class ScreenManager extends StatefulWidget {
  const ScreenManager({super.key});

  @override
  State<ScreenManager> createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {
  int selectedIndex = 0;

  static const List<Widget> _pages = [
    TodolistScreen(),
    JsonImportExportScreen(),
    BugReportScreen(),
    AboutScreen(),
    EsterEggScreen(),
  ];

  static const List<String> _pageTitles = [
    'To-Do List',
    'Import/Export Data',
    'Bug Report',
    'About this App',
    isDebugMode ? 'Debug' : 'Rabbit :)',
  ];

  static const List<Icon> _pageIcons = [
    Icon(Icons.home),
    Icon(Icons.import_export),
    Icon(Icons.bug_report),
    Icon(Icons.info),
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
    Application.debug('成功初始化更新检测服务.');
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

  Scaffold _buildScreen(
      BuildContext context, Function(BuildContext) screenBuilder) {
    return screenBuilder(context) as Scaffold;
  }

  Scaffold _screenOnMobile(BuildContext context) {
    return Scaffold(
      appBar: UI.createAppBar(context, _pageTitles[selectedIndex]),
      body: UI.addAnimatedSwitcher(_pages[selectedIndex]),
      drawer: _buildDrawer(context),
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

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TodoList App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        SizedBox(height: 10),
        Text(
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

  Row _buildNavigationRail() {
    return Row(
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
          extended: MediaQuery.of(context).size.width >=
              UI.minimalExpandWidthForNavigation,
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
          onDestinationSelected: (value) =>
              setState(() => selectedIndex = value),
        ),
      ],
    );
  }
}
