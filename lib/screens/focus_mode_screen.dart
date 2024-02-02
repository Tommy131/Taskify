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
 * @LastEditTime : 2024-02-02 00:58:55
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
/// screens/focus_mode_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_app/models/task.dart';
import 'package:todolist_app/providers/todo_provider.dart';
import 'package:todolist_app/widgets/capsule_tag.dart';
import 'package:todolist_app/widgets/color_transition.dart';

class FocusModeScreen extends StatefulWidget {
  const FocusModeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FocusModeScreenState createState() => _FocusModeScreenState();
}

class _FocusModeScreenState extends State<FocusModeScreen>
    with TickerProviderStateMixin {
  late Timer _timer;
  late DateTime? _dueDate;
  late Duration? _timeUntilExpiry;
  late ColorTransition _colorTransition;
  late String _countdownText;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTime);
    _colorTransition = ColorTransition(this);
  }

  void _updateTime(Timer timer) {
    if (_dueDate == null || _timeUntilExpiry == null) {
      return;
    }

    DateTime now = DateTime.now();
    if (now.isBefore(_dueDate!)) {
      _timeUntilExpiry = _dueDate?.difference(now);
    } else {
      _timeUntilExpiry = Duration.zero;
      _timer.cancel();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        Task? importantTask = todoProvider.getUpcomingImportantTask();
        Task? normalTask = todoProvider.getUpcomingTask();
        return (importantTask == null)
            ? _buildWellDoneContainer()
            : _buildTaskContainer(importantTask, normalTask);
      },
    );
  }

  Widget _buildWellDoneContainer() {
    return _buildContainer(
      Colors.green,
      icon: Icons.task_alt,
      text: 'Perfect! You have completed all your tasks~',
    );
  }

  Widget _buildTaskContainer(Task task, Task? normalTask) {
    _dueDate = task.dueDate;
    _timeUntilExpiry = _dueDate?.difference(DateTime.now());

    int days = _timeUntilExpiry?.inDays ?? 0;
    int hours = (_timeUntilExpiry?.inHours ?? 0) % 24;
    int minutes = (_timeUntilExpiry?.inMinutes ?? 0) % 60;
    int seconds = (_timeUntilExpiry?.inSeconds ?? 0) % 60;

    _countdownText =
        '$days Day(s) ${hours.toString().padLeft(2, '0')} hour(s) ${minutes.toString().padLeft(2, '0')} minute(s) ${seconds.toString().padLeft(2, '0')} seconds';

    bool closeToDeadline = (days == 0) && (hours == 0) && (minutes <= 30);
    _colorTransition.colorTween = ColorTween(
      begin: closeToDeadline
          ? Colors.red[900]
          : _timer.isActive
              ? Colors.blue
              : Colors.amber[900],
      end: closeToDeadline
          ? Colors.red[400]
          : _timer.isActive
              ? Colors.yellow
              : Colors.yellow[700],
    );

    return _buildContainer(task.category.color,
        widget: buildTaskWidget(task, normalTask, closeToDeadline));
  }

  Widget buildTaskWidget(Task task, Task? normalTask, bool closeToDeadline) {
    List<Widget> buildNormalTask() {
      if (normalTask == null) {
        return [Container()];
      }
      return [
        const Divider(
          thickness: 2.0,
          color: Colors.white,
        ),
        const SizedBox(height: 20.0),
        _buildTagAndTitleRow(normalTask, fontWeight: FontWeight.normal),
        _buildTextContent('Due to date: ${normalTask.dueDate}', fontSize: 12.0),
      ];
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTagAndTitleRow(task),
        _buildTextContent('Due to date: ${task.dueDate}', fontSize: 12.0),
        const SizedBox(height: 10.0),
        _buildAnimatedContainer(closeToDeadline, _timer, _colorTransition),
        const SizedBox(height: 20.0),
        ...buildNormalTask(),
      ],
    );
  }

  Widget _buildTagAndTitleRow(Task task,
      {FontWeight fontWeight = FontWeight.bold}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 0,
          child: CapsuleTag(
            text: task.isImportant ? 'Important' : 'Normal',
            backgroundColor: Colors.white,
            textColor: task.isImportant ? Colors.red : Colors.blue,
            fontWeight: fontWeight,
          ),
        ),
        Expanded(
          child: _buildTextContent(
            '${task.category.name}: ${task.title}',
            fontWeight: fontWeight,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedContainer(
      bool closeToDeadline, Timer timer, ColorTransition colorTransition) {
    return AnimatedBuilder(
      animation: colorTransition.colorAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: colorTransition.colorAnimation.value,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: (closeToDeadline ? Colors.red : Colors.grey)
                    .withOpacity(0.5),
                offset: const Offset(1.0, 2.0),
              ),
            ],
          ),
          child: _buildTextContent(
            timer.isActive
                ? _countdownText
                : 'Is your mission accomplished? ? ?',
            color: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildContainer(
    Color color, {
    IconData? icon,
    String? text,
    Widget? widget,
  }) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      color: color,
      child: Center(
        child: ListView(
          children: [
            SizedBox(height: (height <= 600) ? 0 : (height / 4)),
            widget ??
                (text != null
                    ? icon != null
                        ? _buildIconContent(icon, text)
                        : _buildTextContent(text)
                    : Container()),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContent(IconData icon, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 100.0,
        ),
        const SizedBox(height: 20.0),
        _buildTextContent(text),
      ],
    );
  }

  Widget _buildTextContent(
    String text, {
    Color color = Colors.white,
    double fontSize = 30.0,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _colorTransition.dispose();
    super.dispose();
  }
}
