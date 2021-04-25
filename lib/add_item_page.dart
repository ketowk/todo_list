import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/database.dart';
import 'package:todo_app/home_page.dart';
import 'package:todo_app/utils.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  TextEditingController _controller = new TextEditingController();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  String category = "Social";
  Color buttonColorSocial = Colors.white;
  Color buttonColorBusiness = Colors.white;
  Color textColorSocial = Colors.grey;
  Color textColorBusiness = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        body: Container(
            child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
                  )
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
                  selectedDecoration:BoxDecoration(color: Color(0xFF72435C), shape: BoxShape.circle) ,
                  todayDecoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                  todayTextStyle: TextStyle(color: Colors.black),
                    markerDecoration:
                        BoxDecoration(color: Theme.of(context).primaryColor)),
              ),
              Container(
                padding: EdgeInsets.only(left: 30),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.475,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  color: Theme.of(context).primaryColor,
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Image.asset('assets/images/43029bg.png')),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: _controller,
                              style: TextStyle(color: Color(0xFF72435C), fontSize: 24),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left:
                                        MediaQuery.of(context).size.width / 6),
                                hintText: "Type The Task Here ...",
                                hintStyle: TextStyle(
                                    color: Color(0xFF72435C),
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold),
                                //border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Color(0xFF72435C),
                          thickness: 2.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "Please Select The Category",
                            style: TextStyle(color: Color(0xFF72435C), fontSize: 24),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 16),
                              child: TextButton.icon(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              buttonColorBusiness),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ))),
                                  onPressed: () {
                                    setState(() {
                                      buttonColorSocial = Colors.white;
                                      buttonColorBusiness =
                                          Color.fromRGBO(169, 191, 122, 1);
                                      textColorSocial = Colors.grey;
                                      textColorBusiness = Colors.white;
                                      category = "Business";
                                    });
                                  },
                                  icon: Icon(
                                    Icons.add_business,
                                    color: textColorBusiness,
                                  ),
                                  label: Text("Business",
                                      style: TextStyle(
                                        color: textColorBusiness,
                                      ))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 4),
                              child: TextButton.icon(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              buttonColorSocial),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ))),
                                  onPressed: () {
                                    setState(() {
                                      buttonColorSocial =
                                          Color.fromRGBO(169, 191, 122, 1);
                                      buttonColorBusiness = Colors.white;
                                      textColorSocial = Colors.white;
                                      textColorBusiness = Colors.grey;
                                      category = "Social";
                                    });
                                  },
                                  icon: Icon(
                                    Icons.celebration,
                                    color: textColorSocial,
                                  ),
                                  label: Text("Social",
                                      style: TextStyle(
                                        color: textColorSocial,
                                      ))),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width / 16,
                              top: MediaQuery.of(context).size.width / 24),
                          child: TextButton.icon(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xFF72435C)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              onPressed: () async {
                                DateTime now = DateTime.now();
                                int timeLeft =
                                    _selectedDay.millisecondsSinceEpoch -
                                        now.millisecondsSinceEpoch;
                                int i = await DatabaseHelper.instance.insert({
                                  DatabaseHelper.columnTaskDescription:
                                      _controller.text,
                                  DatabaseHelper.columnIsTaskCompleted: 0,
                                  DatabaseHelper.columnTaskCategory: category,
                                  DatabaseHelper.columnTaskTime:
                                      _selectedDay.millisecondsSinceEpoch
                                });

                                List<Map<String, dynamic>> queryRows =
                                    await DatabaseHelper.instance.queryAll();
                                print(queryRows);

                                print('the inserted id is $i');

                                print(
                                    "Selected Day : ${_selectedDay.millisecondsSinceEpoch} ${now.millisecondsSinceEpoch}");
                              },
                              icon: Icon(
                                Icons.add_circle,
                                color: Colors.white,
                              ),
                              label: Text("Add New Task ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24.0))),
                        ),
                      ],
                    )
                  ],
                ),
              )

              /*Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Enter New Task",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 24.0),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 42.0, top: 8.0),
                    child: TextButton.icon(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.grey)))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.grey,
                        ),
                        label: Text("Today",
                            style: TextStyle(
                              color: Colors.grey,
                            ))),
                  ),
                ],
              )*/
            ],
          ),
        )));
  }
}
