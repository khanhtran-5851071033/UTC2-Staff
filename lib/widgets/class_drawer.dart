import 'package:utc2_staff/screens/classroom/report_class.dart';
import 'package:utc2_staff/service/firestore/class_database.dart';
import 'package:utc2_staff/utils/utils.dart';
import 'package:flutter/material.dart';

class ClassDrawer extends StatelessWidget {
  final List<Class> active;
  final Function(String classId, String name, String description) change;
  ClassDrawer({this.active, this.change});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
        child: Container(
      color: Colors.white,
      child: new ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
                margin: EdgeInsets.only(bottom: 7),
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03, vertical: size.width * 0.02),
                height: AppBar().preferredSize.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: ColorApp.blue.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('assets/images/logoUTC.png'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'UTC2  Lớp học',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                )),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            leading: Container(
                width: 30,
                child: Icon(
                  Icons.home_rounded,
                  color: ColorApp.black.withOpacity(.8),
                )),
            title: Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: ColorApp.black, width: .3))),
              child: Text(
                'Lớp học',
                style: TextStyle(
                    color: ColorApp.black.withOpacity(.9),
                    fontSize: size.width * 0.042,
                    wordSpacing: 1.2,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2),
              ),
            ),
          ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     Navigator.of(context).pop();
          //   },
          //   leading: Container(
          //       width: 30,
          //       child: Icon(
          //         Icons.fact_check_rounded,
          //         color: ColorApp.black.withOpacity(.8),
          //       )),
          //   title: Container(
          //     padding: EdgeInsets.symmetric(vertical: 15),
          //     decoration: BoxDecoration(
          //         border: Border(
          //             bottom: BorderSide(color: ColorApp.black, width: .3))),
          //     child: Text(
          //       'Điểm danh',
          //       style: TextStyle(
          //           color: ColorApp.black.withOpacity(.9),
          //           fontSize: size.width * 0.042,
          //           wordSpacing: 1.2,
          //           fontWeight: FontWeight.w500,
          //           letterSpacing: 0.2),
          //     ),
          //   ),
          // ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ReportClassScreen()));
            },
            leading: Container(
                width: 30,
                child: Icon(
                  Icons.print_rounded,
                  color: ColorApp.black.withOpacity(.8),
                )),
            title: Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: ColorApp.black, width: .3))),
              child: Text(
                'In báo cáo',
                style: TextStyle(
                    color: ColorApp.black.withOpacity(.9),
                    fontSize: size.width * 0.042,
                    wordSpacing: 1.2,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2),
              ),
            ),
          ),
          Container(
            height: size.height - AppBar().preferredSize.height * 2,
            decoration: BoxDecoration(color: Colors.white),
            child: ListView.builder(
              itemCount: active.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      change(active[index].id, active[index].name,
                          active[index].note);
                    },
                    leading: Container(
                      width: 30,
                      child: CircleAvatar(
                        child: Text(
                            active[index].name.substring(0, 1).toUpperCase()),
                      ),
                    ),
                    title: Text(
                      active[index].name,
                      style: TextStyle(
                          color: ColorApp.black.withOpacity(.8),
                          fontSize: size.width * 0.042,
                          wordSpacing: 1.2,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    ));
  }
}
