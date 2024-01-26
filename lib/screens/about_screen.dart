// ignore_for_file: deprecated_member_use

/*
 *        _____   _          __  _____   _____   _       _____   _____
 *      /  _  \ | |        / / /  _  \ |  _  \ | |     /  _  \ /  ___|
 *      | | | | | |  __   / /  | | | | | |_| | | |     | | | | | |
 *      | | | | | | /  | / /   | | | | |  _  { | |     | | | | | |   _
 *      | |_| | | |/   |/ /    | |_| | | |_| | | |___  | |_| | | |_| |
 *      \_____/ |___/|___/     \_____/ |_____/ |_____| \_____/ \_____/
 *
 *  Copyright (c) 2023 by OwOTeam-DGMT (OwOBlog).
 * @Date         : 2024-01-19 21:26:22
 * @Author       : HanskiJay
 * @LastEditors  : HanskiJay
 * @LastEditTime : 2024-01-26 18:03:47
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// screens/about_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:todolist_app/main.dart';

class AboutScreen extends StatelessWidget {
  static Color labelColor = Colors.blue.shade700;
  static const EdgeInsets defaultMargin =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0);

  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UI.createAppBar(context, 'About'),
      backgroundColor: Colors.white30,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10.0),
          Container(
            margin: defaultMargin,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 2.0, color: Colors.black26),
              ),
            ),
            child: const Text(
              'Application Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: defaultMargin,
            child: const Text('Version: v${Application.version}'),
          ),
          const SizedBox(height: 20.0),
          Container(
            margin: defaultMargin,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 2.0, color: Colors.black26),
              ),
            ),
            child: const Text(
              'Developer Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            elevation: 1.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Image.asset(
                    'assets/images/hanskijay.jpg',
                    width: 64.0,
                    height: 64.0,
                  ),
                  title: const Text(
                    'Jay Hanski',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Student',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.email, color: labelColor),
                  title: const Text('hanskijay@owoblog.com'),
                ),
                ListTile(
                  leading: Icon(Icons.public, color: labelColor),
                  title: const Text('https://owoblog.com/blog'),
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/images/github_mark.svg',
                    width: 24.0,
                    height: 24.0,
                    color: labelColor,
                  ),
                  title: const Text('Tommy131 (HanskiJay)'),
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/images/instagram_icon.svg',
                    width: 24.0,
                    height: 24.0,
                    color: labelColor,
                  ),
                  title: const Text('jay.jay2045'),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
