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
 * @LastEditTime : 2024-02-07 21:05:15
 * @E-Mail       : support@owoblog.com
 * @Telegram     : https://t.me/HanskiJay
 * @GitHub       : https://github.com/Tommy131
 */
// core/notification_service.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:taskify/main.dart';

class NotificationService {
  static const owoChannel = 'com.owoblog.taskify';
  static final AwesomeNotifications _notification = AwesomeNotifications();

  static final Map<String, Map<String, Function>> _methodHandlers = {
    'onActionReceivedMethod': {},
    'onNotificationCreatedMethod': {},
    'onNotificationDisplayedMethod': {},
    'onDismissActionReceivedMethod': {},
  };

  static final Map<String, Timer> _timerList = {};

  static List<int> _dismissList = [];
  static List<int> get resetDismissList => _dismissList = [];

  static int _notificationId = 0;
  static int get nextNotificationId => _notificationId++;
  static int get resetNotificationId => _notificationId = 0;

  static AwesomeNotifications get instance {
    return _notification;
  }

  static void addTimer(
    String timerId, {
    Timer? timer,
    Duration? duration,
    Function? callback,
  }) {
    if (_timerList.containsKey(timerId)) {
      _timerList[timerId]!.cancel();
    }

    if (timer != null) {
      _timerList[timerId] = timer;
      return;
    }

    if ((duration != null) && (callback != null)) {
      _timerList[timerId] = Timer(duration, () {
        _timerList.remove(timerId);
        callback();
      });
    }
  }

  static void removeTimer(String timerId) {
    if (_timerList.containsKey(timerId)) {
      _timerList[timerId]!.cancel();
      _timerList.remove(timerId);
      Application.debug('Removed Timmer: $timerId');
    }
  }

  static Map<String, Map<String, Function>> get methodHandler {
    return _methodHandlers;
  }

  static void cleanMethodHandlers(String method) {
    if (_methodHandlers.containsKey(method)) {
      _methodHandlers[method] = {};
    }
  }

  static void addMethodHandler(String method, String tagName, Function handler) {
    if (_methodHandlers.containsKey(method)) {
      _methodHandlers[method]![tagName] = handler;
      Application.debug('Added Handler "$tagName" to "$method".');
    }
  }

  static void removeMethodHandler(String method, String tagName) {
    if (_methodHandlers.containsKey(method)) {
      _methodHandlers[method]!.remove(tagName);
    }
  }

  static void handleMethods(String method, ReceivedNotification _) {
    if (_methodHandlers.containsKey(method)) {
      _methodHandlers[method]!.forEach((
        String tagName,
        Function callable,
      ) {
        handleMethod(method, tagName, _);
      });
    }
  }

  static dynamic handleMethod(String method, String tagName, ReceivedNotification _) {
    if (_methodHandlers.containsKey(method)) {
      Map<String, Function> map = _methodHandlers[method]!;
      if (map.containsKey(tagName)) {
        return _methodHandlers[method]![tagName]!(_);
      }
    }
    return null;
  }

  static Future<void> _onActionReceivedMethod(ReceivedAction receivedAction) async {
    // print('onActionReceivedMethod');
    // print(receivedAction);
    handleMethods('onActionReceivedMethod', receivedAction);
  }

  static Future<void> _onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // print('onNotificationCreatedMethod');
    // print(receivedNotification);
    handleMethods('onNotificationCreatedMethod', receivedNotification);
  }

  static Future<void> _onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // print('onNotificationDisplayedMethod');
    // print(receivedNotification);
    handleMethods('onNotificationDisplayedMethod', receivedNotification);
  }

  static Future<void> _onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // print('onDismissActionReceivedMethod');
    // print(receivedAction);
    handleMethods('onDismissActionReceivedMethod', receivedAction);
  }

  static Future<void> initializeNotifications({
    String? appIconString,
    bool debug = isDebugMode,
  }) async {
    await _notification
        .initialize(
      appIconString,
      [
        NotificationChannel(
          channelGroupKey: 'com.owoblog.taskify.group',
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
          channelGroupKey: 'com.owoblog.taskify.group',
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

  static Future<bool> checkNotificationPermission(BuildContext context) async {
    return await _notification.isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        UI.showStandardDialog(
          context,
          title: '${Application.appName} wants send you notification.',
          content: 'Please grant this application the required permissions later.',
          actionCall: (context) async {
            await _notification.requestPermissionToSendNotifications().then((bool isGranted) {
              if (isGranted) {
                isAllowed = true;
                UI.showBottomSheet(
                  context: context,
                  message: 'Operation completed successfully.',
                );
              } else {
                UI.showBottomSheet(
                  context: context,
                  message: 'Failed to access notification permissions.',
                );
              }
            });
          },
        );
      }
      return isAllowed;
    });
  }

  static Future<bool> showNotification({
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
    bool scheduled = false,
    int? interval,
  }) async {
    if (NotificationService.inDismissList(id)) return false;

    return await _notification.isNotificationAllowed().then((isAllowed) async {
      if (isAllowed) {
        return _notification.createNotification(
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
          schedule: scheduled
              ? NotificationInterval(
                  interval: interval,
                  timeZone: await _notification.getLocalTimeZoneIdentifier(),
                  preciseAlarm: true,
                )
              : null,
        );
      } else {
        Application.debug('No Permission to show notification.');
        return isAllowed;
      }
    });
  }

  static Future<bool> showInboxNotification({
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

  static Future<bool> showBigTextNotification({
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

  static Future<bool> showBigTextWithActionNotification({
    int id = 0,
    String? title,
    String? body,
    String? summary,
    Map<String, String>? payload,
    List<NotificationActionButton>? actionButtons,
  }) async {
    return await showNotification(
      id: id,
      actionType: ActionType.Default,
      title: title,
      body: body,
      summary: summary,
      notificationLayout: NotificationLayout.BigText,
      payload: payload,
      actionButtons: actionButtons ??
          [
            NotificationActionButton(
              key: 'dismiss',
              label: 'Dismiss',
              color: Colors.red,
            ),
          ],
    );
  }

  static Future<bool> showBigPictureNotification({
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

  static Future<bool> showDownloadingStateNotification(
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

  static Future<void> dismiss(int id) async {
    _dismissList.add(id);
    return await _notification.dismiss(id);
  }

  static bool inDismissList(int id) {
    return _dismissList.contains(id);
  }
}
