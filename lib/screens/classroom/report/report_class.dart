import 'package:flutter/material.dart';
import 'package:utc2_staff/screens/classroom/report/report_attenden_class.dart';
import 'package:utc2_staff/screens/classroom/report/report_info_class.dart';
import 'package:utc2_staff/screens/plash_sreen.dart';
import 'package:utc2_staff/service/firestore/class_database.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';

import 'package:utc2_staff/utils/utils.dart';

class ReportClassScreen extends StatefulWidget {
  final Teacher teacher;
  final Class classUtc;

  ReportClassScreen({this.teacher, this.classUtc});
  @override
  _ReportClassScreenState createState() => _ReportClassScreenState();
}

class _ReportClassScreenState extends State<ReportClassScreen> {
  List report = [
    {'title': 'Thông tin lớp', 'icon': 'assets/icons/info.png'},
    {'title': 'Điểm thành phần', 'icon': 'assets/icons/score.png'},
    {'title': 'Điểm danh', 'icon': 'assets/icons/check.png'},
    {'title': 'Điểm bài Test', 'icon': 'assets/icons/test.png'},
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: ColorApp.lightGrey,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: ColorApp.black,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'In báo cáo',
            style: TextStyle(color: ColorApp.black),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, ColorApp.lightGrey])),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(size.width * 0.01),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, ColorApp.lightGrey])),
                  child: GridView.count(
                    physics: BouncingScrollPhysics(),
                    crossAxisCount: 2,
                    children: List.generate(report.length, (index) {
                      return Center(
                          child: Item(
                        title: report[index]['title'],
                        icon: report[index]['icon'],
                        function: () {
                          if (index == 0) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReportInfoClass(
                                          teacher: widget.teacher,
                                          classUtc: widget.classUtc,
                                        )));
                          }
                          if (index == 1) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SplashScreen()));
                          }
                          if (index == 2) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReportAttendenClass(
                                          teacher: widget.teacher,
                                          classUtc: widget.classUtc,
                                        )));
                          }
                          if (index == 3) {
                            print('3');
                          }
                        },
                      ));
                    }),
                  ),
                ),
              ),
              Image.asset(
                'assets/images/path@2x.png',
                width: size.width,
                fit: BoxFit.fill,
              )
            ],
          ),
        ));
  }
}

class Item extends StatelessWidget {
  final String icon;
  final String title;
  final Function function;
  Item({this.icon, this.title, this.function});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextButton(
      onPressed: () {
        function();
      },
      child: Container(
        width: size.width,
        height: size.width / 2,
        alignment: Alignment.center,
        padding: EdgeInsets.all(size.width * 0.03),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: ColorApp.blue.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(1, 3), // changes position of shadow
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              width: 60,
            ),
            SizedBox(height: 10),
            Text(
              title,
              softWrap: true,
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
