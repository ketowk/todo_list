import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todo_app/list_item.dart';
import 'package:todo_app/pages/add_item_page.dart';
import 'package:todo_app/services/database.dart';
import 'package:todo_app/widgets/drawer_widget.dart';
import 'package:todo_app/widgets/selectable_list_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  var items = [];
  bool completed = false;
  AnimationController controller;
  Animation animation;
  double value = 0;
  List<Map<String, dynamic>> queryRows;
  DateTime _now = DateTime.now();
  int businessTasks;
  int socialTasks;
  int businessDone;
  int socialDone;
  double businessPercent;
  double socialPercent;
  int businessPc;
  int socialPc;
  @override
  void initState() {
    super.initState();
    //deleteAllTasks();
    businessTasks = 0;
    socialTasks = 0;
    businessDone = 0;
    socialDone = 0;
    businessPercent = 0;
    socialPercent = 0;

    getAllTasks();
    controller = new AnimationController(
      duration: new Duration(milliseconds: 225),
      vsync: this,
    );

    final CurvedAnimation curve =
        new CurvedAnimation(parent: controller, curve: Curves.easeOut);

    animation = new Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() => setState(() {}));
    controller.forward(from: 0.0);
  }

  deleteAllTasks() async {
    queryRows = await DatabaseHelper.instance.queryAll();
    for (int i = 0; i < queryRows.length + 1; i++) {
      DatabaseHelper.instance.delete(i);
    }
  }

  getAllTasks() async {
    queryRows = await DatabaseHelper.instance.queryAll();
    for (int i = 0; i < queryRows.length; i++) {
      if (_now.millisecondsSinceEpoch > queryRows[i]['taskTime'] &&
          _now.millisecondsSinceEpoch < queryRows[i]['taskTime'] + 86400000) {
        print(queryRows[i]['_id']);
        items.add(queryRows[i]['taskDescription'] +
            ":" +
            queryRows[i]['_id'].toString() +
            "*" +
            queryRows[i]['taskCategory'].toString());

        if (queryRows[i]['taskCategory'] == 'Business') {
          businessTasks++;
          if (queryRows[i]['isTaskCompleted'] == 1) {
            businessDone++;
          }
        }

        if (queryRows[i]['taskCategory'] == 'Social') {
          socialTasks++;
          if (queryRows[i]['isTaskCompleted'] == 1) {
            socialDone++;
          }
        }
      }
    }
    if (businessDone > 0 && businessTasks > 0) {
      businessPercent = businessDone / businessTasks;
    }
    if (socialDone > 0 && socialTasks > 0) {
      socialPercent = socialDone / socialTasks;
    }
    businessPc = (businessPercent * 100).toInt();
    socialPc = (socialPercent * 100).toInt();
  }

  void callback(int done, String category) {
    setState(() {
      if (category == "Business") {
        if (done == 0) {
          businessDone--;
        }
        businessPercent = businessDone / businessTasks;
        businessPc = (businessPercent * 100).toInt();
      }
      if (category == "Social") {
        if (done == 0) {
          socialDone--;
        }
        socialPercent = socialDone / socialTasks;
        socialPc = (socialPercent * 100).toInt();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("TODO APP"),
        centerTitle: true,
      ),
      drawer: DrawerWidget(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddItemPage()));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Color(0xFF72435C)),
      backgroundColor: Theme.of(context).accentColor,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0, bottom: 24.0),
                child: Row(
                  children: [
                    Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        color: Color(0xFF72435C),
                        child: Column(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                height: MediaQuery.of(context).size.height / 5,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 6,
                                    ),
                                    Column(children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Business',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          alignment: Alignment.topCenter,
                                          //wdi
                                          child: Image.asset(
                                              "assets/images/business_icon.png")),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          businessTasks.toString() + " Tasks",
                                          style: GoogleFonts.montserrat(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                24,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      /* CircularPercentIndicator(
                                        radius:
                                            MediaQuery.of(context).size.width / 8,
                                        lineWidth: 5.0,
                                        percent: 0.5,
                                        center: new Text(
                                          "50%",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  32),
                                        ),
                                        progressColor: Colors.green,
                                      ),*/
                                    ]),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 6,
                                    ),
                                    Column(children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Social',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          alignment: Alignment.topCenter,
                                          //wdi
                                          child: Image.asset(
                                              "assets/images/social_icon.png")),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          socialTasks.toString() + " Tasks",
                                          style: GoogleFonts.montserrat(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                24,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      /*Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0, top: 8.0),
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    "Social",
                                                    style: TextStyle(
                                                        fontSize: 24.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),*/
                                      //SizedBox(height: 5),
                                      /*CircularPercentIndicator(
                                        radius:
                                            MediaQuery.of(context).size.width / 8,
                                        lineWidth: 5.0,
                                        percent: 0.5,
                                        center: new Text(
                                          "50%",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  32),
                                        ),
                                        progressColor: Colors.green,
                                      )*/
                                    ]),
                                  ],
                                )),
                          ],
                        )),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(left: 30),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.66,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          //topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)),
                      color: Theme.of(context).canvasColor),
                  child: Stack(children: [
                    Column(children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 24,
                            right: MediaQuery.of(context).size.width / 16),
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              "TODAY'S TASKS",
                              style: GoogleFonts.montserrat(
                                fontSize:
                                    MediaQuery.of(context).size.width / 12,
                                color: Color(0xFF72435C),
                              ),
                            )),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SingleChildScrollView(
                            child: ListView(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              children: items
                                  .map((item) =>
                                      SelectableListItemWidget(ListItem(item)))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ])
                  ])),
            ],
          ),
        ),
      ),
    );
  }
}
