// ignore_for_file: use_build_context_synchronously

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
 * @LastEditTime : 2024-01-29 14:33:32
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
/// core/update_checker.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pub_semver/pub_semver.dart';

import 'package:taskify/main.dart';

class UpdateChecker {
  static const String _serverUrl =
      'https://owoblog.com/todolist/api/check-update';

  static Future<Map<String, dynamic>> getRawData() async {
    try {
      final response = await http.get(Uri.parse(_serverUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to fetch version information');
      }
    } catch (e) {
      throw Exception('Error during version check: $e');
    }
  }

  static void checkForUpdates(BuildContext context,
      {bool unnecessaryInfo = false}) async {
    try {
      final data = await getRawData();

      final int latestVersionCode = data['versionCode'];
      final String latestVersionName = data['versionName'];
      final String updateMessage = data['updateMessage'];
      final String downloadUrl = data['downloadUrl'];

      Version appVersion = Version.parse(Application.versionName);
      Version remoteVersion = Version.parse(latestVersionName);

      if ((appVersion < remoteVersion) ||
          (Application.versionCode < latestVersionCode)) {
        showUpdateDialog(
            context, latestVersionName, updateMessage, downloadUrl);
      } else {
        if (unnecessaryInfo) {
          UI.showStandardDialog(
            context,
            title: 'Update Checker',
            content: 'No available update.',
          );
        }
      }
    } catch (e) {
      UI.showBottomSheet(
        context: context,
        message: e.toString(),
      );
    }
  }

  static void showUpdateDialog(
    BuildContext context,
    String latestVersionName,
    String updateMessage,
    String downloadUrl,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Found new version: v$latestVersionName!'),
        content: Text(updateMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Application.openExternalLink(context, downloadUrl);
            },
            child: const Text('Update Now!'),
          ),
        ],
      ),
    );
  }
}
