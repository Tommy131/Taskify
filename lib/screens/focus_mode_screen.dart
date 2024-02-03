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
 * @LastEditTime : 2024-02-03 23:18:44
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
import 'package:todolist_app/widgets/color_transition.dart';
import 'package:todolist_app/widgets/task_tile_builder.dart';

class FocusModeScreen extends StatefulWidget {
  const FocusModeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FocusModeScreenState createState() => _FocusModeScreenState();
}

class _FocusModeScreenState extends State<FocusModeScreen>
    with TickerProviderStateMixin {
  late Timer _timer;
  late ColorTransition _colorTransition;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
    _colorTransition = ColorTransition(this);
  }

  @override
  void dispose() {
    _timer.cancel();
    _colorTransition.dispose();
    super.dispose();
  }

  void _updateTimer(Timer timer) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TodoProvider todoProvider = context.read<TodoProvider>();
    List<Task?> sortedTasks = [
      todoProvider.getUpcomingImportantTask(),
      todoProvider.getUpcomingTask(),
    ].where((element) => element != null).toList();

    return _buildFocusModeContainer(sortedTasks);
  }

  Widget _buildFocusModeContainer(List<Task?> tasks) {
    double height = MediaQuery.of(context).size.height;
    return tasks.isEmpty
        ? _buildWellDoneContainer()
        : _buildTaskListView(tasks, height);
  }

  Widget _buildTaskListView(List<Task?> tasks, double height) {
    return ListView.builder(
      itemCount: tasks.length,
      itemExtent: _calculateItemExtent(height),
      itemBuilder: (context, index) {
        Task task = tasks[index]!;
        Duration remainingTime = task.dueDate.difference(DateTime.now());
        _colorTransition.colorTween = _getColorTween();

        return _buildTaskContainer(task, remainingTime);
      },
    );
  }

  double _calculateItemExtent(double height) {
    // print(height);
    return height /
        (height > 730 ? 2 : (height > 550 ? 1.5 : (height > 275 ? 0.75 : 0.5)));
  }

  Widget _buildTaskContainer(Task task, Duration remainingTime) {
    return Container(
      color: task.category.color,
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
              child: Icon(
                _isMissionFailed(remainingTime)
                    ? Icons.sentiment_very_dissatisfied
                    : Icons.work_history,
                color: task.category.color,
                size: 48.0,
              ),
            ),
            const SizedBox(height: 10.0),
            TaskTileBuilder.buildCapsuleTag(
              task.isImportant ? 'Important' : 'Primary',
              task.category.color,
            ),
            const SizedBox(height: 10.0),
            _buildTaskText(task, fontSize: 14.0, text: task.category.name),
            _buildTaskText(task, fontSize: 30.0),
            const SizedBox(height: 20.0),
            _buildTaskText(task, fontSize: 20.0, text: task.remark),
            const SizedBox(height: 10.0),
            _buildTaskText(
              task,
              fontSize: 12.0,
              text: 'Due to: ${task.dueDate.toString()}',
              fontStyle: FontStyle.italic,
            ),
            const SizedBox(height: 10.0),
            _buildAnimatedContainer(remainingTime),
            (remainingTime.inMinutes <= 30)
                ? const SizedBox(height: 10.0)
                : const SizedBox(height: 0.0),
            _isMissionFailed(remainingTime)
                ? _buildTaskText(
                    task,
                    text: '👆 Have you finished your task?👆',
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  bool _isMissionFailed(Duration remainingTime) {
    return remainingTime.inMinutes <= 0;
  }

  Widget _buildTaskText(
    Task task, {
    String? text,
    double fontSize = 14.0,
    TextStyle? textStyle,
    FontStyle? fontStyle,
  }) {
    return Text(
      text ?? task.title,
      textAlign: TextAlign.center,
      style: textStyle ??
          TaskTileBuilder.getTextStyle(
            task,
            fontSize: fontSize,
            fontStyle: fontStyle,
          ),
    );
  }

  Widget _buildAnimatedContainer(Duration remainingTime) {
    return AnimatedBuilder(
      animation: _colorTransition.colorAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
            color: _colorTransition.colorAnimation.value,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: _calculateBoxShadowColor(remainingTime),
                offset: const Offset(1.0, 2.0),
              ),
            ],
          ),
          child: Text(
            _formatDuration(remainingTime),
            style: TextStyle(
              color: _calculateTextColor(remainingTime),
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Color _calculateBoxShadowColor(Duration remainingTime) {
    return (remainingTime.inMinutes <= 30 ? Colors.red : Colors.grey)
        .withOpacity(0.5);
  }

  Color _calculateTextColor(Duration remainingTime) {
    return remainingTime.inMinutes <= 30 ? Colors.red : Colors.cyan;
  }

  ColorTween _getColorTween() {
    return ColorTween(
      begin: Colors.white,
      end: Colors.white70,
    );
  }

  String _formatDuration(Duration duration) {
    int minutes = duration.inMinutes % 60;
    int hours = duration.inHours % 24;
    int days = duration.inDays;
    int secs = duration.inSeconds % 60;

    _(int num) => [0, 1].contains(num);
    String dayCorrective = _(days) ? 'day' : 'days';
    String hourCorrective = _(hours) ? 'hour' : 'hours';
    String minuteCorrective = _(minutes) ? 'minute' : 'minutes';
    String secsCorrective = _(secs) ? 'second' : 'seconds';

    return '$days $dayCorrective, $hours $hourCorrective, $minutes $minuteCorrective $secs $secsCorrective';
  }

  Widget _buildWellDoneContainer() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      color: Colors.green,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              color: Colors.white,
              size: 100.0,
            ),
            SizedBox(height: 20.0),
            Text(
              'Perfect! You have completed all your tasks~',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
