import 'package:flutter/material.dart';
import 'package:taskify/main.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  late final Map<String, dynamic> _notificationSettings;
  late final Map<String, dynamic> _categorySettings;

  @override
  void initState() {
    super.initState();
    _notificationSettings = _userData['notification']['settings'];
    _categorySettings = _userData['categories']['settings'];
  }

  final Map<String, dynamic> _userData = Application.settings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSection(
              title: 'Notification Settings',
              content: _buildNotificationSettings(),
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: 'Category Settings',
              content: _buildCategorySettings(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        content,
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSettingTextField(
          label: 'Frequency (in minutes):',
          value: _notificationSettings['frequencyInMinutes'].toString(),
          onChanged: (value) {
            _updateSettings(() {
              _notificationSettings['frequencyInMinutes'] = int.tryParse(value) ?? 10;
            });
          },
        ),
        const SizedBox(height: 5),
        _buildSettingTextField(
          label: 'Frequency (in seconds):',
          value: _notificationSettings['frequencyInSeconds'].toString(),
          onChanged: (value) {
            _updateSettings(() {
              _notificationSettings['frequencyInSeconds'] = int.tryParse(value) ?? 10;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCategorySettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSettingTextField(
          label: 'Name:',
          value: _categorySettings['name'],
          onChanged: (value) {
            _updateSettings(() {
              _categorySettings['name'] = value;
            });
          },
        ),
        /* const SizedBox(height: 10),
        _buildSettingTextField(
          label: 'Color:',
          value: Color(_categorySettings['color']).toString(),
          onChanged: (value) {
            _updateSettings(() {
              _categorySettings['color'] = Color(int.tryParse(value) ?? Colors.blue.value).value;
            });
          },
        ),
        const SizedBox(height: 10),
        _buildSettingTextField(
          label: 'Priority:',
          value: _categorySettings['priority'].toString(),
          onChanged: (value) {
            _updateSettings(() {
              _categorySettings['priority'] = int.tryParse(value) ?? 0;
            });
          },
        ), */
      ],
    );
  }

  Widget _buildSettingTextField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextFormField(
          initialValue: value,
          keyboardType: TextInputType.number,
          onFieldSubmitted: onChanged,
        ),
      ],
    );
  }

  void _updateSettings(Function callable) {
    setState(() {
      callable();
      _userData['notification']['settings'] = _notificationSettings;
      _userData['categories']['settings'] = _categorySettings;
      Application.userSettingsJson().writeData(_userData);
      Application.reloadConfigurations();
      UI.showBottomSheet(context: context, message: 'The update is completed, please restart the App to take effect.');
    });
  }
}
