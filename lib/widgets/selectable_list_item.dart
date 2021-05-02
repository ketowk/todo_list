import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/list_item.dart';
import 'package:todo_app/pages/select_hour_page.dart';
import 'package:todo_app/services/database.dart';

class SelectableListItemWidget extends StatefulWidget {
  final ListItem _listItem;

  const SelectableListItemWidget(this._listItem);

  @override
  _SelectableListItemWidgetState createState() =>
      _SelectableListItemWidgetState();
}

class _SelectableListItemWidgetState extends State<SelectableListItemWidget>
    with TickerProviderStateMixin {
  String get _title => widget._listItem.title;
  String lastTitle;
  int dbId;
  String category;
  bool get _isSelected => widget._listItem.isSelected;
  AnimationController controller;
  Animation animation;
  int isSelectedInt = 0;
  String assetImage = "";
  String isAlarmSetted = "";

  @override
  void initState() {
    super.initState();
    lastTitle = _title.substring(0, _title.lastIndexOf(":"));
    dbId = int.parse(_title.substring(_title.lastIndexOf(":") + 1, _title.lastIndexOf(":") + 2));
    category = _title.substring(_title.lastIndexOf("*")+1, _title.lastIndexOf("/"));
    isAlarmSetted = _title.substring(_title.lastIndexOf("/")+1);
    print("last title : $lastTitle  database id : $dbId category : $category  isAlarmSetted : $isAlarmSetted");
    if(category == "Business") {
      assetImage = "assets/images/business_icon.png";
    }

    if(category == "Social") {
      assetImage = "assets/images/social_icon.png";
    }
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          print('element: $lastTitle has been clicked');
          widget._listItem.isSelected = !_isSelected;
          controller.forward(from: 0.0);
          if (_isSelected) {
            isSelectedInt = 1;
          } else {
            isSelectedInt = 0;
          }
        });

        DatabaseHelper.instance.update({
          DatabaseHelper.columnId: dbId,
          DatabaseHelper.columnIsTaskCompleted: isSelectedInt
        });
      },
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 32,
            right: MediaQuery.of(context).size.width / 12),
        child: Dismissible(
          key: UniqueKey(),
          onDismissed: (_) {
            DatabaseHelper.instance.delete(dbId);
            print(DatabaseHelper.instance.queryAll());
          },
          child: Card(
            elevation: 7,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height / 8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white,
                  border: Border.all(
                      style: BorderStyle.solid,
                      color: Theme.of(context).primaryColor)),
              transform: new Matrix4.identity()..scale(animation.value, 1.0),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Image.asset(assetImage)),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16, bottom: 8),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 2,
                                    child: AutoSizeText(lastTitle,
                                  style: TextStyle(
                                      decoration: _isSelected
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      color: Colors.black,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  16
                                      ,
                                      ),
                                      maxLines: 3,),
                  ),
                ),
                
                isAlarmSetted == "false" ? IconButton(icon: Icon(Icons.alarm_add), onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectHourPage(title: lastTitle, id: dbId)));
                  },) : IconButton(icon: Icon(Icons.alarm_on), onPressed: () {},)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
