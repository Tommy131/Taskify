package com.owoblog.taskify

import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodCall
import android.service.notification.StatusBarNotification
import android.app.NotificationManager

class MainActivity : FlutterActivity() {
    private val CHANNEL = "android_version"
    private val NOTIFICATION_CHANNEL = "notification_checker"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler(
            object : MethodCallHandler {
                override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
                    if (call.method == "getAndroidVersion") {
                        val version = Build.VERSION.SDK_INT
                        result.success(version)
                    } else {
                        result.notImplemented()
                    }
                }
            }
        )

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NOTIFICATION_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "isNotificationPresent") {
                val notificationId: Int = call.argument("notificationId") ?: -1
                val isPresent = checkNotificationPresence(notificationId)
                result.success(isPresent)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun checkNotificationPresence(notificationId: Int): Boolean {
        val manager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        val activeNotifications: Array<StatusBarNotification> = manager.activeNotifications
        // Check if the notification with the specified ID is present in the active notifications
        for (notification in activeNotifications) {
            if (notification.getId() == notificationId) {
                return true
            }
        }
        return false
    }
}
