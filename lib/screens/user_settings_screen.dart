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
 * @LastEditTime : 2024-02-07 22:21:26
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// screens/user_settings_screen.dart
import 'package:flutter/material.dart';

import 'package:taskify/main.dart';
import 'package:taskify/core/phone/notification_service.dart';
import 'package:taskify/widgets/card_builder_widget.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  static const Map<String, dynamic> _defaultNotificationPayload = {
    'settings': {
      'frequencyInMinutes': 10,
      'frequencyInSeconds': 10,
    },
  };
  late Map<String, dynamic> _userData;
  late final Map<String, dynamic> _notificationSettings;
  late final Map<String, dynamic> _categorySettings;

  @override
  void initState() {
    super.initState();
    _userData = Application.settings;
    _notificationSettings = Map.from(_userData['notification']['settings'] ?? _defaultNotificationPayload);
    _categorySettings = Map.from(_userData['categories']['settings']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSection(
              title: 'Notification Settings',
              content: _buildNotificationSettings(),
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: 'Category Settings',
              content: _buildCategorySettings(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        content,
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CardBuilderWidget.buildWithNumberPicker(
          title: 'Minimum dismiss in days:',
          currentValue: _notificationSettings['minimumDismissDay'],
          minValue: 1,
          maxValue: 30,
          onNumberChanged: (value) {
            setState(() {
              _notificationSettings['minimumDismissDay'] = value;
            });
          },
          onDataSave: () => _updateSettings(),
        ),
        const SizedBox(height: 5),
        CardBuilderWidget.buildWithNumberPicker(
          title: 'Frequency (in minutes):',
          currentValue: _notificationSettings['frequencyInMinutes'],
          onNumberChanged: (value) {
            setState(() {
              _notificationSettings['frequencyInMinutes'] = value;
            });
          },
          onDataSave: () => _updateSettings(),
        ),
        const SizedBox(height: 5),
        CardBuilderWidget.buildWithNumberPicker(
          title: 'Frequency (in seconds):',
          currentValue: _notificationSettings['frequencyInSeconds'],
          onNumberChanged: (value) {
            setState(() {
              _notificationSettings['frequencyInSeconds'] = value;
            });
          },
          onDataSave: () => _updateSettings(),
        ),
        const SizedBox(height: 5),
        CardBuilderWidget.buildStandard(
          title: 'Reset Notification Counter [BETA]',
          widget: ElevatedButton(
            onPressed: () {
              NotificationService.instance.resetGlobalBadge();
              UI.showBottomSheet(
                context: context,
                message: 'Operation completed successfully.',
              );
            },
            child: const Text('Clear'),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CardBuilderWidget.buildWithField(
          title: 'Name:',
          currentValue: _categorySettings['name'],
          onChanged: (value) {
            setState(() {
              _categorySettings['name'] = value;
            });
          },
          onDataSave: () => _updateSettings(),
        ),
        const SizedBox(height: 10),
        CardBuilderWidget.buildWithColorPicker(
          title: 'Color:',
          subtitle: _categorySettings['color'].toString(),
          currentColor: Color(_categorySettings['color']),
          onColorChanged: (color) {
            setState(() {
              _categorySettings['color'] = color.value;
            });
          },
          onDataSave: () => _updateSettings(),
        ),
        const SizedBox(height: 10),
        CardBuilderWidget.buildWithNumberPicker(
          title: 'Priority:',
          currentValue: _categorySettings['priority'],
          maxValue: 5,
          onNumberChanged: (value) {
            setState(() {
              _categorySettings['priority'] = value;
            });
          },
          onDataSave: () => _updateSettings(),
        ),
      ],
    );
  }

  void _updateSettings({Function? callable}) {
    setState(() {
      if (callable != null) callable();
      _userData['notification']['settings'] = _notificationSettings;
      _userData['categories']['settings'] = _categorySettings;
      Application.userSettingsJson().writeData(_userData);
      Application.reloadConfigurations();
      UI.showBottomSheet(
        context: context,
        message: 'The update is completed, please restart the App to take effect.',
      );
    });
  }
}
