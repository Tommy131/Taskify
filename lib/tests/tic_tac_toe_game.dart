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
 * @LastEditTime : 2024-02-01 00:08:28
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// screens/tic_tac_toe_game.dart
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:taskify/app.dart';
import 'package:taskify/widgets/animated_app_bar.dart';

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  // Use constants for better readability
  static const int boardSize = 3;
  static const String playerXSymbol = 'X';
  static const String playerOSymbol = 'O';
  int playerXScore = 0;
  int playerOScore = 0;

  // Use a 2D List for the game board
  List<List<String>> board =
      List.generate(boardSize, (_) => List.filled(boardSize, ''));

  bool playerX = true; // true: X, false: O

  Color _randomColor = Colors.blue;
  late Timer _colorChangeTimer;

  void _changeColor() {
    // 生成随机颜色
    final random = Random();
    setState(() {
      _randomColor = Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1.0,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _startColorChangingTimer();
  }

  void _startColorChangingTimer() {
    _colorChangeTimer =
        Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _changeColor();
    });
  }

  @override
  void dispose() {
    _colorChangeTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AnimatedAppBar(
        duration: const Duration(seconds: 1),
        color: _randomColor,
        title: const Text(
          'Tic Tac Toe',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MyApp(),
              ),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildScorePanel('Player X', playerXScore),
            const SizedBox(height: 20.0),
            for (int i = 0; i < boardSize; i++) buildRow(i),
            const SizedBox(height: 20.0),
            buildScorePanel('Player O', playerOScore, angle: 0.0),
          ],
        ),
      ),
    );
  }

  Widget buildScorePanel(String player, int score, {double? angle}) {
    return Transform.rotate(
      angle: angle ?? 3.14, // 180° in radians
      child: Transform.translate(
        offset: const Offset(0.0, 100.0),
        child: Column(
          children: [
            Text(
              '$player Score: $score',
              style: const TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: _resetGame,
              child: const Text('Reset Game'),
            ),
          ],
        ),
      ),
    );
  }

  // Extracted method to build a row of tiles
  Widget buildRow(int row) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(boardSize, (col) => buildTile(row, col)),
    );
  }

  Widget buildTile(int row, int col) {
    return GestureDetector(
      onTap: () => _onTileTap(row, col),
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.all(1.0),
        decoration: _tileDecoration(),
        child: Center(
          child: Text(
            board[row][col],
            style: const TextStyle(
              fontSize: 20,
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _tileDecoration() {
    return BoxDecoration(
      color: Colors.black.withOpacity(0.5),
      borderRadius: BorderRadius.circular(8),
    );
  }

  void _onTileTap(int row, int col) {
    if (board[row][col].isEmpty) {
      setState(() {
        board[row][col] = playerX ? playerXSymbol : playerOSymbol;
        playerX = !playerX;
      });

      if (_checkWinner()) {
        _showWinnerDialog();
      } else if (_isBoardFull()) {
        _showDrawDialog();
      }
    }
  }

  bool _checkWinner() {
    for (int i = 0; i < boardSize; i++) {
      if (_checkLine(board[i][0], board[i][1], board[i][2]) ||
          _checkLine(board[0][i], board[1][i], board[2][i])) {
        return true;
      }
    }

    return _checkLine(board[0][0], board[1][1], board[2][2]) ||
        _checkLine(board[0][2], board[1][1], board[2][0]);
  }

  bool _checkLine(String a, String b, String c) {
    return a.isNotEmpty && a == b && b == c;
  }

  bool _isBoardFull() {
    return board.every((row) => row.every((cell) => cell.isNotEmpty));
  }

  void _resetGame() {
    setState(() {
      board = List.generate(boardSize, (_) => List.filled(boardSize, ''));
      playerX = true;
    });
  }

  void _showWinnerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        !playerX ? playerXScore++ : playerOScore++;
        return _buildGameOverDialog(
            'Player ${!playerX ? playerXSymbol : playerOSymbol} wins!');
      },
    );
  }

  void _showDrawDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildGameOverDialog("It's a draw!");
      },
    );
  }

  // Extracted method to build the game over dialog
  Widget _buildGameOverDialog(String message) {
    Future.delayed(Duration.zero, () => _resetGame());
    return AlertDialog(
      title: const Text('Game Over'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Play Again'),
        ),
      ],
    );
  }
}
