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
 * @LastEditTime : 2024-02-02 00:07:37
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
/// widgets/color_transition.dart
import 'package:flutter/material.dart';

class ColorTransition {
  late ColorTween colorTween;
  late AnimationController _controller;

  ColorTransition(TickerProvider vsync) {
    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 1),
    );

    colorTween = ColorTween(
      begin: Colors.red[900],
      end: Colors.red[400],
    );

    _controller.repeat(reverse: true);
    _controller.addListener(() {
      // Here you can use _controller.value to access the current animation value
      // For example: Color currentColor = colorTween.evaluate(_controller);
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.forward();
  }

  Animation<Color?> get colorAnimation => colorTween.animate(_controller);

  void dispose() {
    _controller.dispose();
  }
}
