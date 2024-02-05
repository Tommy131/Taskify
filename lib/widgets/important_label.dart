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
// widgets/important_label.dart
import 'package:flutter/material.dart';

class ImportantLabel {
  static Center put({String text = 'Important', Color color = Colors.red}) {
    return Center(
      child: Stack(
        children: [
          // 左侧三角形
          Positioned(
            left: 0,
            top: 28,
            child: Transform.rotate(
              angle: -90 * 3.1415926535 / 180, // 旋转90度
              child: Container(
                width: 0,
                height: 0,
                decoration: BoxDecoration(
                  border: Border(
                    right:
                        const BorderSide(width: 15, color: Colors.transparent),
                    bottom:
                        const BorderSide(width: 15, color: Colors.transparent),
                    left:
                        const BorderSide(width: 15, color: Colors.transparent),
                    top: BorderSide(width: 15, color: color.withOpacity(0.5)),
                  ),
                ),
              ),
            ),
          ),
          // 主要按钮容器
          Container(
            width: 100,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
