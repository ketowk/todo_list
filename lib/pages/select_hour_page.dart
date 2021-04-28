import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/utils.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class SelectHourPage extends StatefulWidget {
  @override
  _SelectHourPageState createState() => _SelectHourPageState();
}
FixedExtentScrollController fixedExtentScrollController =
    new FixedExtentScrollController();

class _SelectHourPageState extends State<SelectHourPage> {
  DateTime _dateTime;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  String formattedDate;
  String formattedHours;
  DateTime latestDateTime;
  @override
  void initState() {
    tz.initializeTimeZones();
    //tz.setLocalLocation(tz.getLocation(DateTime.now().timeZoneName));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
                        SizedBox(height: 10,),
            Row(
              children: [
                IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.black,), onPressed: () {
                  Navigator.pop(context);
                }),
              ],
            ),
            TableCalendar(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                // Use `selectedDayPredicate` to determine which day is currently selected.
                // If this returns true, then `day` will be marked as selected.

                // Using `isSameDay` is recommended to disregard
                // the time-part of compared DateTime objects.
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDay);
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
              ),
              calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  selectedDecoration: BoxDecoration(
                      color: Color(0xFF72435C), shape: BoxShape.circle),
                  todayDecoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle),
                  todayTextStyle: TextStyle(color: Colors.black),
                  markerDecoration:
                      BoxDecoration(color: Theme.of(context).primaryColor)),
            ),
            Divider(
              height: 32.0,
              thickness: 4.0,
              color: Color(0xFF72435C),
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
            Divider(
              height: 32.0,
              thickness: 4.0,
              color: Colors.white
            ),
            TextButton.icon(
              icon: Icon(Icons.alarm_add, size: 48, color: Color(0xFF72435C),), onPressed: () {
                latestDateTime = DateTime.parse("$formattedDate $formattedHours");
                scheduleAlarm(latestDateTime);
                print("$formattedDate  $formattedHours ${DateTime.parse("$formattedDate $formattedHours")}");
              }, 
            label: Text("Add Alarm", style: TextStyle(color: Color(0xFF72435C), fontSize: 32),),)
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
  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics
  );
  await flutterLocalNotificationsPlugin.zonedSchedule(0, 'OFFICE', 'Good Morning Time For Office', tz.TZDateTime.from(latestDateTime,tz.local).add(const Duration(seconds: 5)), platformChannelSpecifics, androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
}

}
