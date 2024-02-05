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
 * @LastEditTime : 2024-01-31 22:23:39
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// screens/widget_test_screen.dart
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:taskify/main.dart';
import 'package:taskify/tests/test_widget.dart';
import 'package:taskify/tests/tic_tac_toe_game.dart';

class EsterEggScreen extends StatefulWidget {
  const EsterEggScreen({super.key});

  @override
  State<EsterEggScreen> createState() => _EsterEggState();
}

class _EsterEggState extends State<EsterEggScreen> {
  final TextEditingController answerController = TextEditingController();
  final int randomNumber = Random().nextInt(100);
  final int today = DateTime.now().day;

  @override
  Widget build(BuildContext context) {
    return isDebugMode
        ? const TestWidget()
        : Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInstructionText(),
                const SizedBox(height: 20.0),
                _buildMathProblemText(),
                const SizedBox(height: 20.0),
                _buildPromptWordText(),
                const SizedBox(height: 20.0),
                _buildAnswerTextField(),
                const SizedBox(height: 20.0),
                _buildUnlockButton(context),
              ],
            ),
          );
  }

  // Widget to display instruction text
  Widget _buildInstructionText() {
    return const Text(
      'To unlock the game, solve the math problem:',
      style: TextStyle(fontSize: 16),
    );
  }

  // Widget to display the math problem
  Widget _buildMathProblemText() {
    return Text(
      '$randomNumber + dd = ?',
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  // Widget to display prompt word text
  Widget _buildPromptWordText() {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'dd',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: ' is usually defined as a day (in number) :)',
            style: TextStyle(color: Colors.black),
          ),
          // Add more TextSpan for additional styling
        ],
      ),
    );
  }

  // Widget for the answer text field
  Widget _buildAnswerTextField() {
    return TextField(
      controller: answerController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'Enter your answer',
      ),
    );
  }

  // Widget for the unlock button
  Widget _buildUnlockButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _checkAnswer(context),
      child: const Text('Unlock Game'),
    );
  }

  // Function to check the answer and navigate accordingly
  void _checkAnswer(BuildContext context) {
    int userAnswer = int.tryParse(answerController.text) ?? -1;

    if (userAnswer == (randomNumber + today)) {
      UI.showStandardDialog(
        context,
        title: 'Bingo~',
        content: 'You have successfully unlocked the game!',
        actionCall: (context) {
          Navigator.pushReplacement(
            context!,
            MaterialPageRoute(
              builder: (context) => const TicTacToeGame(),
            ),
          );
        },
      );
    } else {
      UI.showStandardDialog(
        context,
        title: 'Incorrect Answer!',
        content: 'Try again!',
      );
    }
  }
}
