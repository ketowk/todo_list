import 'dart:isolate';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_app/pages/home_page.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


void printHello() {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    final int helloAlarmID = 0;
  await AndroidAlarmManager.initialize();

  var initializationSettingsAndroid =
      AndroidInitializationSettings('flutter_logo');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});

  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String payload) async {
    if(payload != null) {
      debugPrint('notification payload : '+payload);
    }
  });

  runApp(MyApp());
   //await AndroidAlarmManager.oneShotAt(DateTime, helloAlarmID, printHello);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter Demo',
      builder: BotToastInit(),
      theme: ThemeData(
        primaryColor: Color.fromRGBO(215, 215, 255, 1),
        accentColor: Color.fromRGBO(249, 250, 255, 1),
        canvasColor: Color.fromRGBO(217, 223, 248, 1),
      ),
      home: HomePage(),
    );
  }
}
