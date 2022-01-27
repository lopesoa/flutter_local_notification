import 'dart:isolate';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class ForeGroundTask {
  ReceivePort? _receivePort;

  static Future<void> initForegroundTask() async {
    await FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
        buttons: [
          const NotificationButton(id: 'sendButton', text: 'Send'),
          const NotificationButton(id: 'testButton', text: 'Test'),
        ],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        autoRunOnBoot: true,
        allowWifiLock: true,
      ),
      printDevLog: true,
    );
  }

  static Future<bool> startForegroundTask(String title, String text) async {
    // You can save data using the saveData function.
    //await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');

    ReceivePort? receivePort;
    if (await FlutterForegroundTask.isRunningService) {
      receivePort = await FlutterForegroundTask.restartService();
    } else {
      receivePort = await FlutterForegroundTask.startService(
        notificationTitle: title,
        notificationText: text,
        callback: startCallback,
      );
    }

    if (receivePort != null) {
      return true;
    }

    return false;
  }

  static void startCallback(String title, String text) {
  // The setTaskHandler function must be called to handle the task in the background.
    FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
  }

  static Future<bool> stopForegroundTask() async {
    return await FlutterForegroundTask.stopService();
  }

}

class FirstTaskHandler extends TaskHandler{
  @override
  Future<void> onDestroy(DateTime timestamp) {
    // TODO: implement onDestroy
    throw UnimplementedError();
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) {
    // TODO: implement onEvent
    throw UnimplementedError();
  }

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) {
    // TODO: implement onStart
    throw UnimplementedError();
  }
  
  void onButtonPressed(String id) {
    // Called when the notification button on the Android platform is pressed.
    print('onButtonPressed >> $id');
  }
}