import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/list_item.dart';
import 'package:todo_app/services/database.dart';
import 'package:todo_app/widgets/loading.dart';
import 'package:todo_app/widgets/previous_list_item.dart';
import 'package:todo_app/widgets/selectable_list_item.dart';

class PreviousTasksPage extends StatefulWidget {
  @override
  _PreviousTasksPageState createState() => _PreviousTasksPageState();
}

class _PreviousTasksPageState extends State<PreviousTasksPage> {
  var items = [];
  DateTime _now = DateTime.now();
  bool isLoading = false;
  List<Map<String, dynamic>> queryRows;

  queryAllRows() async {
    setState(() {
      isLoading = true;
    });

    queryRows = await DatabaseHelper.instance.queryAll();
    print(queryRows);
    setState(() {
      isLoading = false;
    });
    getAllTasks();
  }

  getAllTasks() async {
    setState(() {
      isLoading = true;
    });
    for (int i = 0; i < queryRows.length; i++) {
      print(queryRows[i]['taskTime'].toString());
      items.add(queryRows[i]['taskDescription'] +
          ":" +
          queryRows[i]['_id'].toString() +
          "*" +
          queryRows[i]['taskCategory'].toString() +
          "/" +
          queryRows[i]['taskTime'].toString());
    }
    print(items);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    queryAllRows();
    super.initState();
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
                      " Previous Tasks",
                      style: GoogleFonts.montserrat(
                        fontSize: MediaQuery.of(context).size.width / 12,
                        color: Color(0xFF72435C),
                      ),
                    ),
                  ),
                  Container(
                    child: Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SingleChildScrollView(
                        child: ListView(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          children: items
                              .map((item) =>
                                  PreviousListItemWidget(ListItem(item)))
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
