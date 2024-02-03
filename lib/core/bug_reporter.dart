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
 * @LastEditTime : 2024-01-28 03:30:34
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
/// core/bug_reporter.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taskify/main.dart';

class ReportPayload {
  String email;
  String title;
  String category;
  String content;

  ReportPayload({
    required this.email,
    required this.title,
    required this.category,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'title': title,
      'category': category,
      'content': content,
    };
  }
}

class BugReporter {
  final BuildContext context;

  const BugReporter({required this.context});

  Future<void> send(ReportPayload payload) async {
    const apiUrl = 'https://owoblog.com/todolist/api/bug-report'; // 替换为实际的服务器地址

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode(payload.toJson()),
      );

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        UI.showBottomSheet(
          context: context,
          message: 'Bug Report sent successfully',
        );
      } else {
        Application.debug(
            'Failed to send Bug Report. Status code: ${response.statusCode}');
      }
    } catch (e) {
      Application.debug('Error sending Bug Report: $e');
    }
  }
}
