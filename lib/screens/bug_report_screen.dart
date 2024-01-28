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
 * @LastEditTime : 2024-01-26 01:45:49
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// screens/bug_report_screen.dart
import 'package:flutter/material.dart';
import 'package:todolist_app/core/bug_reporter.dart';

import 'package:todolist_app/main.dart';

class BugReportScreen extends StatefulWidget {
  const BugReportScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BugReportScreenState createState() => _BugReportScreenState();
}

class _BugReportScreenState extends State<BugReportScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController textController = TextEditingController();

  bool isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    emailController.addListener(updateButtonState);
    titleController.addListener(updateButtonState);
    categoryController.addListener(updateButtonState);
    textController.addListener(updateButtonState);
  }

  void updateButtonState() {
    setState(() {
      isButtonDisabled = emailController.text.isEmpty ||
          titleController.text.isEmpty ||
          categoryController.text.isEmpty ||
          textController.text.isEmpty ||
          !Application.isValidEmail(emailController.text);
    });
  }

  void submitForm(BuildContext context) {
    BugReporter(context: context).send(
      ReportPayload(
        email: emailController.text,
        title: titleController.text,
        category: categoryController.text,
        content: textController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UI.createAppBar(context, 'Bug Report'),
      backgroundColor: Colors.white30,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Here is Bug Report / Feature Feedback site. You can send me a feedback here.',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'E-Mail',
                icon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                icon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Bug Category',
                icon: Icon(Icons.category),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                  labelText: 'Write something here...',
                  icon: Icon(
                    Icons.text_fields,
                  )),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: isButtonDisabled ? null : (() => submitForm(context)),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue.shade500, // 设置按钮文本颜色
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // 设置按钮圆角
                ),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
