import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/alarm_list_item.dart';
import 'package:todo_app/services/database.dart';
import 'package:todo_app/widgets/all_alarms_item.dart';
import 'package:todo_app/widgets/loading.dart';

class AllAlarmsPage extends StatefulWidget {
  @override
  _AllAlarmsPageState createState() => _AllAlarmsPageState();
}

class _AllAlarmsPageState extends State<AllAlarmsPage> {
  bool isLoading = false;
  var items = [];
  List<Map<String, dynamic>> queryRows;
  getAllTasks() async {
    setState(() {
      isLoading = true;
    });
    print(DatabaseHelper.instance.queryAllAlarm());
    queryRows = await DatabaseHelper.instance.queryAllAlarm();
    for (int i = 0; i < queryRows.length; i++) {
      print(queryRows[i]['alarmTime'].toString().substring(0,queryRows[i]['alarmTime'].toString().length - 14) );
      if(queryRows[i]['alarmTime'].toString().substring(0,queryRows[i]['alarmTime'].toString().length - 14) == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      print(queryRows[i]['_id']);
      items.add(queryRows[i]['alarmDescription'] +
          ":" +
          queryRows[i]['_id'].toString() +
          "*" +
          queryRows[i]['alarmTime'].toString());
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllTasks();
    print(DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
            backgroundColor: Theme.of(context).canvasColor,
            body: Container(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      " Today's Alarms",
                      style: GoogleFonts.montserrat(
                        fontSize: MediaQuery.of(context).size.width / 12,
                        color: Color(0xFF72435C),
                      ),
                    ),
                  ),
                  Container(
                    child: Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: SingleChildScrollView(
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(24.0),
                          physics: BouncingScrollPhysics(),
                          children: items
                              .map((item) =>
                                  AllAlarmsItem(AlarmListItem(item)))
                              .toList(),
                          
                        ),
                      ),
                    )),
                  )
                ],
              ),
            ),
          )
        : Loading();
  }
}
