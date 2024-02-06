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
 * @LastEditTime : 2024-02-05 18:15:18
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// screens/about_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:taskify/core/update_checker.dart';
import 'package:taskify/core/utils.dart';
import 'package:taskify/main.dart';
import 'package:taskify/widgets/capsule_tag.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  AboutScreenState createState() => AboutScreenState();
}

class AboutScreenState extends State<AboutScreen> {
  static Color labelColor = Colors.blue.shade700;
  static String storageInfo = 'Fetching storage info...';

  @override
  void initState() {
    super.initState();
    getStorageInfo();
  }

  Future<void> getStorageInfo() async {
    try {
      storageInfo = await Utils.getStorageInfo();
    } catch (e) {
      storageInfo = 'Failed to fetch storage info';
    } finally {
      if (mounted) {
        setState(() {
          storageInfo = storageInfo;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const String versionString =
        'v${Application.versionName} - (Build Version ${Application.buildVersion})';

    return Scaffold(
      backgroundColor: Colors.white30,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0),
            _buildSection('App Information', [
              createCard([
                _buildInfoListTile(Icons.translate, Platform.localeName),
                _buildInfoListTile(
                    Icons.folder, Application.userSettingsJson().savePath),
                _buildInfoListTile(Icons.api, Platform.operatingSystemVersion),
                _buildInfoListTile(Icons.storage, storageInfo),
                _buildIconListTile(
                  Icons.info_outline,
                  const CapsuleTag(
                      text: versionString,
                      textAlign: TextAlign.center,
                      fontSize: 14),
                ),
                _buildIconListTile(
                  Icons.update,
                  ElevatedButton(
                    onPressed: () => _checkForUpdates(context),
                    style: ElevatedButton.styleFrom(primary: Colors.blue[100]),
                    child: const Text('Check Update'),
                  ),
                ),
                _buildIconListTile(
                  Icons.settings,
                  ElevatedButton(
                    onPressed: () {
                      if (Platform.isAndroid) {
                        openAppSettings();
                      } else if (Platform.isWindows) {
                        Process.run('cmd.exe', ['/c', 'start', 'control'])
                            .then((ProcessResult result) {
                          if (result.exitCode == 0) {
                            UI.showBottomSheet(
                              context: context,
                              message: 'Successfully opened control panel.',
                            );
                          } else {
                            UI.showBottomSheet(
                              context: context,
                              message:
                                  '${Application.appName} cannot open control panel, reason: ${result.exitCode}',
                            );
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.blue[100]),
                    child: const Text('Open System Settings'),
                  ),
                ),
              ]),
            ]),
            const SizedBox(height: 20.0),
            _buildSection('Developer Information', [
              const SizedBox(height: 10.0),
              _buildDeveloperListTile(
                name: 'Jay Hanski',
                subtitle: 'Student',
                email: 'hanskijay@owoblog.com',
                website: 'https://owoblog.com/blog',
                imageAsset: 'assets/images/hanskijay.jpg',
                githubUsername: 'Tommy131 (HanskiJay)',
                githubIcon: 'assets/images/github_mark.svg',
                instagramUsername: 'jay.jay2045',
                instagramIcon: 'assets/images/instagram_icon.svg',
              ),
              const SizedBox(height: 16.0),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        ...children,
      ],
    );
  }

  Widget _buildDeveloperListTile({
    String name = '',
    String subtitle = '',
    String email = '',
    String website = '',
    String imageAsset = '',
    String githubUsername = '',
    String githubIcon = '',
    String instagramUsername = '',
    String instagramIcon = '',
  }) {
    return createCard([
      ListTile(
        leading: Image.asset(imageAsset, width: 64.0, height: 64.0),
        title: Text(
          name,
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 16.0)),
        contentPadding: const EdgeInsets.all(5.0),
      ),
      const Divider(color: Colors.black38),
      _buildStringListTile(Icon(Icons.email, color: labelColor), email),
      _buildStringListTile(Icon(Icons.public, color: labelColor), website),
      _buildStringListTile(
        SvgPicture.asset(githubIcon,
            width: 24.0, height: 24.0, color: labelColor),
        githubUsername,
      ),
      _buildStringListTile(
        SvgPicture.asset(instagramIcon,
            width: 24.0, height: 24.0, color: labelColor),
        instagramUsername,
      ),
    ]);
  }

  Widget _buildCustomListTile(Widget leading, Widget title) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      leading: leading,
      title: title,
    );
  }

  Widget _buildStringListTile(Widget leading, String title) {
    return _buildCustomListTile(
      leading,
      Text(title, style: const TextStyle(fontSize: 16.0)),
    );
  }

  Widget _buildInfoListTile(IconData icon, String title) {
    return _buildStringListTile(Icon(icon, color: labelColor), title);
  }

  Widget _buildIconListTile(IconData leading, Widget title) {
    bool alignLeft =
        MediaQuery.of(context).size.width > UI.minimalWidthForWindows;
    return _buildCustomListTile(
      Icon(leading, color: labelColor),
      alignLeft
          ? Align(
              alignment: Alignment.centerLeft,
              child: title,
            )
          : title,
    );
  }

  Card createCard(List<Widget> children) {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  void _checkForUpdates(BuildContext context) {
    UI.showBottomSheet(
      context: context,
      message: 'Sending request to Server...',
    );
    UpdateChecker.checkForUpdates(context, unnecessaryInfo: true);
  }
}
