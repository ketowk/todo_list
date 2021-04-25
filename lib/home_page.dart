import 'dart:math';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todo_app/add_item_page.dart';
import 'package:todo_app/database.dart';
import 'package:todo_app/selectable_list_item.dart';

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
          if(queryRows[i]['isTaskCompleted'] == 1) {
            businessDone++;
          }
        }

        if (queryRows[i]['taskCategory'] == 'Social') {
          socialTasks++;
          if(queryRows[i]['isTaskCompleted'] == 1) {
            socialDone++;
          }
        }

        
      }
    }
    if(businessDone > 0 && businessTasks > 0) {
    businessPercent = businessDone / businessTasks;
    }
    if(socialDone > 0 && socialTasks > 0) {
    socialPercent = socialDone / socialTasks;
    }
    businessPc = (businessPercent * 100).toInt();
    socialPc = (socialPercent * 100).toInt();
  }

  void callback(int done, String category) {
    setState(() {
    if(category == "Business") {
      if(done == 0) {
        businessDone--;
      }
      businessPercent = businessDone / businessTasks;
      businessPc = (businessPercent * 100).toInt();
    }
    if(category == "Social") {
    if(done == 0) {
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
                  floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddItemPage()));
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
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: Icon(
                                  Icons.menu_rounded,
                                  size: 42,
                                ),
                                color: Colors.black,
                                onPressed: () {
                                  setState(() {
                                    value == 0 ? value = 1 : value = 0;
                                  });
                                },
                              ),
                            ),
                          ),
                          /*Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text("WELCOME TO TODO APP",
                                    style: TextStyle(
                                        fontFamily: 'Kind',
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                5.9)),
                              ],
                            ),
                          ),*/

                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 36),
                                  child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      color: Color(0xFF72435C),
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width /
                                                  2.5,
                                          height:
                                              MediaQuery.of(context).size.height /
                                                  4.5,
                                          child: Column(children: [
                                          
                                            Container(
                                                //height: MediaQuery.of(context).size.height * 0.2,
                                                child: Image.asset(
                                                    "assets/images/business_icon.png")),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0, bottom: 8.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  businessTasks.toString() +
                                                      " Tasks",
                                                  style: TextStyle(
                                                      color: Colors.white, fontSize: 24),
                                                ),
                                              ),
                                            ),
                                            CircularPercentIndicator(
                                              radius: 60,
                                              lineWidth: 5.0,
                                              percent: businessPercent,
                                              center: new Text(businessPc.toString(),style: TextStyle(color: Colors.white),),
                                              progressColor:
                                                  Colors.green,
                                            )
                                          ]))),
                                ),
                                Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    color: Color(0xFF72435C),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.5,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4.5,
                                        child: Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Container(
                                                //height: MediaQuery.of(context).size.height * 0.2,
                                                //wdi
                                                child: Image.asset(
                                                    "assets/images/social_icon.png")),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0, bottom: 8.0),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                  socialTasks.toString() +
                                                      " Tasks",
                                                      style: TextStyle(
                                                    color: Colors.white, fontSize: 24)),
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
                                          CircularPercentIndicator(
                                            radius: 60,
                                            lineWidth: 5.0,
                                            percent: 0.5,
                                            center: new Text("50%",style: TextStyle(color: Colors.white),),
                                            progressColor:
                                                Colors.green,
                                          )
                                        ]))),
                              ],
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 30),
                              width: MediaQuery.of(context).size.width,
                              height:
                                  MediaQuery.of(context).size.height * 0.635,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      //topLeft: Radius.circular(50),
                                      topRight: Radius.circular(50)),
                                  color: Theme.of(context).canvasColor),
                              child: Stack(children: [
                                Column(children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height /
                                                24,
                                        right:
                                            MediaQuery.of(context).size.width /
                                                16),
                                    child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                          "TODAY'S TASKS",
                                          style: TextStyle(
                                            fontSize: 42.0,
                                            fontFamily: 'Kind',
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
                                                  SelectableListItemWidget(
                                                      ListItem(item)))
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
