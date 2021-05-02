import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/alarm_list_item.dart';

class AllAlarmsItem extends StatefulWidget {
final AlarmListItem _listItem;

  const AllAlarmsItem(this._listItem);
  @override
  _AllAlarmsItemState createState() => _AllAlarmsItemState();
}

class _AllAlarmsItemState extends State<AllAlarmsItem> {

    String get _title => widget._listItem.title;
    String title;
    int dbId;
    String time;

    @override
  void initState() {
    super.initState();
    print(_title);
    title = _title.substring(0, _title.indexOf(":"));
    dbId = int.parse(_title.substring(_title.indexOf(":") + 1, _title.indexOf("*")));
    time = _title.substring(_title.lastIndexOf("*")+1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff000000).withOpacity(0.25),
                    blurRadius: 15.0, // has the effect of softening the shadow
                    spreadRadius: 0.5, // has the effect of extending the shadow
                    offset: Offset(
                      0.0, // horizontal, move right 10
                      10.0, // vertical, move down 10
                    ),
                  ),
                ],
                color: const Color(0xff1c3a4d),
                borderRadius: BorderRadius.circular(15)),
            width: MediaQuery.of(context).size.width / 1.25,
            height: MediaQuery.of(context).size.height / 6,
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 5, 25, 0),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Icon(Icons.alarm_on, color: Colors.white, size: 64,)
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 24.0, left: 24.0),
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                            "$title",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffeeeeee),
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height / 20),
                        Container(
                          child: Text(
                            "${time.substring(0,time.length-8)}",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffeeeeee),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
