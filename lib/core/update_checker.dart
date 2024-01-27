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
 * @LastEditTime : 2024-01-27 02:59:20
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
/// core/update_checker.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:todolist_app/main.dart';

class UpdateChecker {
  static const String _serverUrl =
      'http://rdp.owoserver.com:19999/api/check-update';

  Future<void> checkForUpdates(
      BuildContext context, String currentVersion) async {
    try {
      final response = await http.get(Uri.parse(_serverUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final int latestVersionCode = data['versionCode'];
        final String latestVersionName = data['versionName'];
        final String updateMessage = data['updateMessage'];
        final String downloadUrl = data['downloadUrl'];

        if (latestVersionCode > getVersionCode(currentVersion)) {
          showUpdateDialog(
              context, latestVersionName, updateMessage, downloadUrl);
        } else {
          UI.showStandardDialog(
            context,
            title: 'Update Checker',
            content: 'No available update.',
          );
        }
      } else {
        UI.showBottomSheet(
          context: context,
          message: 'Failed to fetch version information',
        );
      }
    } catch (e) {
      UI.showBottomSheet(
        context: context,
        message: 'Error during version check: $e',
      );
    }
  }

  int getVersionCode(String versionName) {
    final parts = versionName.split('.');
    if (parts.length >= 2) {
      return int.parse(parts[0]) * 100 + int.parse(parts[1]);
    }
    return 0;
  }

  void showUpdateDialog(
    BuildContext context,
    String latestVersionName,
    String updateMessage,
    String downloadUrl,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Found new version: $latestVersionName!'),
        content: Text(updateMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Application.openExternalLink(context, downloadUrl);
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            child: const Text('Update Now!'),
          ),
        ],
      ),
    );
  }
}
