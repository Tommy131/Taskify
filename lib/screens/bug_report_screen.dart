// ignore_for_file: library_private_types_in_public_api

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
import 'package:taskify/core/bug_reporter.dart';
import 'package:taskify/main.dart';

class BugReportScreen extends StatefulWidget {
  const BugReportScreen({Key? key}) : super(key: key);

  @override
  _BugReportScreenState createState() => _BugReportScreenState();
}

class _BugReportScreenState extends State<BugReportScreen> {
  late TextEditingController emailController;
  late TextEditingController titleController;
  late TextEditingController categoryController;
  late TextEditingController textController;

  bool isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController()..addListener(updateButtonState);
    titleController = TextEditingController()..addListener(updateButtonState);
    categoryController = TextEditingController()
      ..addListener(updateButtonState);
    textController = TextEditingController()..addListener(updateButtonState);
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
            const SizedBox(height: 10.0),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0),
                child: Column(
                  children: [
                    _buildTextField('E-Mail', Icons.email, emailController),
                    _buildTextField('Title', Icons.title, titleController),
                    _buildTextField(
                      'Bug Category',
                      Icons.category,
                      categoryController,
                    ),
                    _buildTextField(
                      'Write something here...',
                      Icons.text_fields,
                      textController,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: isButtonDisabled ? null : (() => submitForm(context)),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue.shade500,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String labelText, IconData icon, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          icon: Icon(icon),
        ),
        maxLines: maxLines,
      ),
    );
  }
}
