import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
return ClipRRect(
          borderRadius: BorderRadius.circular(50),
        child: Drawer(
          child: Container(
            color: Theme.of(context).canvasColor,
            child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.only(left: 55),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 43.3,
                      ),
                      GestureDetector(
                        onTap: () {
                          //Modular.to.pushReplacementNamed('/user/activity');
                        },
                        child: Container(
                          height: 22,
                          child: Text(
                            'Activity',
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              color: Color(0xFF72435C),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 33.8,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 55, 0),
                        child: Container(
                          height: 1,
                          color: const Color(0xff23475d),
                        ),
                      ),
                      Container(
                        height: 33.8,
                      ),
                      GestureDetector(
                        onTap: () {
                          print("Button2 clicked");
                        },
                        child: Container(
                          height: 22,
                          child: Text(
                            'My Wallet',
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              color: Color(0xFF72435C)
                            ),
                          ),
                        ),
                      ),
                            ],
                  ),
                ),
                Container(
                  height: 50,
                ),
              ],
            ),
            ),
          ),
        ),
        );

  }
}