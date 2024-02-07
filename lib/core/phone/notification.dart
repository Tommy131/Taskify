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
 * @LastEditTime : 2024-02-07 01:30:28
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// core/notification.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:taskify/main.dart';

class Notification {
  static const owoChannel = 'com.owoblog.taskify';

  final AwesomeNotifications _notification = AwesomeNotifications();

  // ignore: prefer_final_fields
  Map<String, Map<String, Function(ReceivedNotification)?>> _methodHandlers = {
    'onActionReceivedMethod': {},
    'onNotificationCreatedMethod': {},
    'onNotificationDisplayedMethod': {},
    'onDismissActionReceivedMethod': {},
  };

  // ignore: prefer_final_fields
  Map<String, Timer> _notificationList = {};

  void addNotification(String notificationId, {Timer? timer, Duration? duration, Function? callback}) {
    if (_notificationList.containsKey(notificationId)) {
      _notificationList[notificationId]!.cancel();
    }

    if (timer != null) {
      _notificationList[notificationId] = timer;
      return;
    }

    if ((duration != null) && (callback != null)) {
      _notificationList[notificationId] = Timer(duration, () {
        _notificationList.remove(notificationId);
        callback();
      });
    }
  }

  void removeNotification(String notificationId) {
    if (_notificationList.containsKey(notificationId)) {
      _notificationList[notificationId]!.cancel();
      _notificationList.remove(notificationId);
      Application.debug('Removed Timmer: $notificationId');
    }
  }

  Map<String, Map<String, Function(ReceivedNotification)?>> get methodHandler {
    return _methodHandlers;
  }

  void cleanMethodHandlers(String method) {
    if (_methodHandlers.containsKey(method)) {
      _methodHandlers[method] = {};
    }
  }

  void addMethodHandler(String method, String tagName, Function(ReceivedNotification) handler) {
    if (_methodHandlers.containsKey(method)) {
      _methodHandlers[method]![tagName] = handler;
      Application.debug('Added Handler "$tagName" to "$method".');
    }
  }

  void removeMethodHandler(String method, String tagName) {
    if (_methodHandlers.containsKey(method)) {
      _methodHandlers[method]!.remove(tagName);
    }
  }

  void handleMethods(String method, ReceivedNotification _) {
    if (_methodHandlers.containsKey(method)) {
      _methodHandlers[method]!.forEach((
        String tagName,
        Function(ReceivedNotification)? callable,
      ) {
        handleMethod(method, tagName, _);
      });
    }
  }

  dynamic handleMethod(String method, String tagName, ReceivedNotification _) {
    if (_methodHandlers.containsKey(method)) {
      Map<String, Function(ReceivedNotification)?> map = _methodHandlers[method]!;
      if (map.containsKey(tagName)) {
        return _methodHandlers[method]![tagName]!(_);
      }
    }
    return null;
  }

  Future<void> _onActionReceivedMethod(ReceivedAction receivedAction) async {
    // print('onActionReceivedMethod');
    // print(receivedAction);
    handleMethods('onActionReceivedMethod', receivedAction);
  }

  Future<void> _onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // print('onNotificationCreatedMethod');
    // print(receivedNotification);
    handleMethods('onNotificationCreatedMethod', receivedNotification);
  }

  Future<void> _onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // print('onNotificationDisplayedMethod');
    // print(receivedNotification);
    handleMethods('onNotificationDisplayedMethod', receivedNotification);
  }

  Future<void> _onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // print('onDismissActionReceivedMethod');
    // print(receivedAction);
    handleMethods('onDismissActionReceivedMethod', receivedAction);
  }

  Future<void> initializeNotifications({
    String? appIconString,
    bool debug = isDebugMode,
  }) async {
    await _notification
        .initialize(
      appIconString,
      [
        NotificationChannel(
          channelGroupKey: 'com.owoblog.group.taskify',
          channelKey: owoChannel,
          channelName: 'Taskify',
          channelDescription: 'Taskify\'s Notification channel',
          defaultColor: Colors.blue,
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        )
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'com.owoblog.group.taskify',
          channelGroupName: 'Taskify\'s Notification channel Group',
        ),
      ],
      debug: debug,
    )
        .then(
      (value) async {
        return await _notification.setListeners(
          onActionReceivedMethod: _onActionReceivedMethod,
          onNotificationCreatedMethod: _onNotificationCreatedMethod,
          onNotificationDisplayedMethod: _onNotificationDisplayedMethod,
          onDismissActionReceivedMethod: _onDismissActionReceivedMethod,
        );
      },
    ).then((value) => Application.debug('Notification Service initialized.'));
  }

  Future<bool> checkNotificationPermission(BuildContext context) async {
    return await _notification.isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        UI.showConfirmationDialog(
          context,
          noticeText: '${Application.appName} wants send you notification.',
          confirmMessage: 'Please grant this application the required permissions later.',
          onConfirmed: () {
            _notification.requestPermissionToSendNotifications().then((bool isGranted) {
              if (isGranted) {
                isAllowed = true;
                Navigator.of(context).pop();
              } else {
                UI.showBottomSheet(
                  context: context,
                  message: 'Failed to access notification permissions.',
                );
              }
            });
          },
          onCancelled: () {
            UI.showBottomSheet(
              context: context,
              message: 'You denied the pop-up notification permission request.',
            );
          },
        );
      }
      return isAllowed;
    });
  }

  Future<bool> showNotification({
    NotificationContent? notificationContent,
    int id = 0,
    ActionType actionType = ActionType.KeepOnTop,
    String? title,
    String? body,
    String? summary,
    String? icon = 'resource://mipmap/ic_launcher',
    String? largeIcon,
    Color color = Colors.white,
    Color backgroundColor = Colors.blue,
    NotificationLayout notificationLayout = NotificationLayout.Default,
    Map<String, String>? payload,
    bool showWhen = true,
    String? bigPicture,
    double? progressValue,
    List<NotificationActionButton>? actionButtons,
  }) async {
    return await _notification.createNotification(
      content: notificationContent ??
          NotificationContent(
            id: id,
            channelKey: owoChannel,
            actionType: actionType,
            title: title ?? 'Taskify Broadcast Message',
            body: body ?? 'Hello World! This is a test message.',
            summary: summary ?? 'Taskify sent you a notification!',
            icon: icon,
            largeIcon: largeIcon,
            color: color,
            backgroundColor: backgroundColor,
            notificationLayout: notificationLayout,
            payload: payload,
            showWhen: showWhen,
            bigPicture: bigPicture,
            progress: progressValue,
          ),
      actionButtons: actionButtons,
    );
  }

  Future<bool> showInboxNotification({
    int id = 0,
    String? title,
    String? body,
    String? summary,
  }) async {
    return await showNotification(
      id: id,
      title: title,
      body: body,
      summary: summary,
      notificationLayout: NotificationLayout.Inbox,
    );
  }

  Future<bool> showBigTextNotification({
    int id = 0,
    String? title,
    String? body,
    String? summary,
  }) async {
    return await showNotification(
      id: id,
      title: title,
      body: body,
      summary: summary,
      notificationLayout: NotificationLayout.BigText,
    );
  }

  Future<bool> showBigTextWithActionNotification({
    int id = 0,
    String? title,
    String? body,
    String? summary,
    Map<String, String>? payload = const {'navigate': 'true'},
  }) async {
    return await showNotification(
      id: id,
      actionType: ActionType.Default,
      title: title,
      body: body,
      summary: summary,
      notificationLayout: NotificationLayout.BigText,
      payload: payload,
      actionButtons: [
        NotificationActionButton(
          key: 'check',
          label: 'Check it out',
          color: Colors.yellow,
        )
      ],
    );
  }

  Future<bool> showBigPictureNotification({
    int id = 0,
    String? title,
    String? body,
    String? summary,
    String? bigPicture = 'asset://assets/images/test.png',
  }) async {
    return await showNotification(
      id: id,
      title: title,
      body: body,
      summary: summary,
      notificationLayout: NotificationLayout.BigPicture,
      bigPicture: bigPicture,
    );
  }

  Future<bool> showDownloadingStateNotification(
    double value, {
    int id = 0,
    String title = 'Downloading...',
    String? body,
    String? summary,
  }) async {
    return await showNotification(
      id: id,
      title: title,
      body: body,
      summary: summary,
      notificationLayout: NotificationLayout.ProgressBar,
      progressValue: value,
    );
  }
}