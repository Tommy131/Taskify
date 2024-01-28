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
 * @LastEditTime : 2024-01-26 21:45:10
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// screens/about_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todolist_app/core/update_checker.dart';
import 'package:todolist_app/main.dart';

class AboutScreen extends StatelessWidget {
  static Color labelColor = Colors.blue.shade700;
  static const EdgeInsets defaultMargin =
      EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0);

  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UI.createAppBar(context, 'About'),
      backgroundColor: Colors.white30,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10.0),
          _buildSection('App Information', [
            const Text(
              'Version: v${Application.version}',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 5.0),
            ElevatedButton(
              onPressed: () {
                UI.showBottomSheet(
                  context: context,
                  message: 'Sending request to Server...',
                );
                UpdateChecker().checkForUpdates(context, Application.version);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue.shade500,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Check Update'),
            ),
          ]),
          const SizedBox(height: 20.0),
          _buildSection('Developer Information', [
            Card(
              color: Colors.white.withOpacity(0.5),
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              // margin: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10.0),
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
                  const Divider(color: Colors.black38),
                  _buildListTile(
                    Icon(
                      Icons.email,
                      color: labelColor,
                    ),
                    'hanskijay@owoblog.com',
                  ),
                  _buildListTile(
                    Icon(
                      Icons.public,
                      color: labelColor,
                    ),
                    'https://owoblog.com/blog',
                  ),
                  _buildListTile(
                    SvgPicture.asset(
                      'assets/images/github_mark.svg',
                      width: 24.0,
                      height: 24.0,
                      color: labelColor,
                    ),
                    'Tommy131 (HanskiJay)',
                  ),
                  _buildListTile(
                    SvgPicture.asset(
                      'assets/images/instagram_icon.svg',
                      width: 24.0,
                      height: 24.0,
                      color: labelColor,
                    ),
                    'jay.jay2045',
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: defaultMargin,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 2.0, color: Colors.black26),
            ),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(margin: defaultMargin, child: Column(children: children)),
      ],
    );
  }

  Widget _buildListTile(Widget leading, String title) {
    return ListTile(
      leading: leading,
      title: Text(title),
    );
  }
}
