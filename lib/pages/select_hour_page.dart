import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/services/database.dart';
import 'package:todo_app/utils.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class SelectHourPage extends StatefulWidget {
  final String title;
  final int id;

  const SelectHourPage({Key key, this.title, this.id}) : super(key: key);
  @override
  _SelectHourPageState createState() => _SelectHourPageState();
}

FixedExtentScrollController fixedExtentScrollController =
    new FixedExtentScrollController();

class _SelectHourPageState extends State<SelectHourPage> {
  DateTime _dateTime;
  String formattedDate;
  String formattedHours;
  DateTime latestDateTime;
  @override
  void initState() {
    tz.initializeTimeZones();
    //tz.setLocalLocation(tz.getLocation(DateTime.now().timeZoneName));
    super.initState();
    formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
            TimePickerSpinner(
              is24HourMode: true,
              normalTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color(0xFF72435C),
              ),
              highlightedTextStyle: TextStyle(
                  fontSize: 24,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
              spacing: 50,
              itemHeight: 80,
              isForce2Digits: true,
              onTimeChange: (time) {
                setState(() {
                  _dateTime = time;
                  formattedHours = DateFormat('kk:mm').format(_dateTime);
                });
              },
            ),
            Divider(height: 8.0, color: Colors.white),
            TextButton.icon(
              icon: Icon(
                Icons.alarm_add,
                size: 48,
                color: Color(0xFF72435C),
              ),
              onPressed: () {
                latestDateTime =
                    DateTime.parse("$formattedDate $formattedHours");
                scheduleAlarm(latestDateTime);
                DatabaseHelper.instance.insertAlarm({
                  DatabaseHelper.alarmColumnkDescription: widget.title,
                  DatabaseHelper.alarmColumnTime:
                      tz.TZDateTime.from(latestDateTime, tz.local).toString(),
                });
                DatabaseHelper.instance.update({
                  DatabaseHelper.columnId: widget.id,
                  DatabaseHelper.columnTaskIsAlarmSetted: "true"
                });
                print(DatabaseHelper.instance.queryAllAlarm());
                print(
                    "$formattedDate  $formattedHours ${DateTime.parse("$formattedDate $formattedHours")}");
                
                showSuccesToast("Alarm Scheduled Successfully");
              },
              label: Text(
                "Add Alarm",
                style: TextStyle(color: Color(0xFF72435C), fontSize: 32),
              ),
            )
          ],
        ),
      ),
    );
  }

  void scheduleAlarm(DateTime latestDateTime) async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 10));

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm notif',
      'alarm notif',
      '^Channel for Alarm Notification',
      icon: 'flutter_logo',
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        widget.title,
        widget.title,
        tz.TZDateTime.from(latestDateTime, tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  
    static void showSuccesToast(String title,
      {String subTitle,
      Color backColor = Colors.green,
      Color titleColor = Colors.white,
      Color subTitleColor = Colors.white70}) {
    BotToast.showSimpleNotification(
      title: title,
      subTitle: subTitle,
      align: Alignment.topCenter,
      hideCloseButton: false,
      enableSlideOff: true,
      closeIcon: Icon(
        Icons.check,
        color: Colors.white,
      ),
      backgroundColor: backColor,
      backButtonBehavior: BackButtonBehavior.close,
      subTitleStyle: TextStyle(color: subTitleColor),
      titleStyle: TextStyle(color: titleColor),
    );
  }
}
