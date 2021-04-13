import 'dart:math';

import 'package:UTC2_Staff/utils/utils.dart';
import 'package:flutter/material.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  List<List<Color>> colors = [
    [
      ColorApp.blue,
      ColorApp.mediumBlue,
    ],
    [
      Color(0xff009FFF),
      Color(0xffec2F4B),
    ],
    [
      Color(0xffFF416C),
      Color(0xffFF4B2B),
    ],
    [
      Color(0xfff5af19),
      ColorApp.red,
    ],
    [
      Color(0xff8360c3),
      Color(0xff2ebf91),
    ],
    [
      Color(0xffc31432),
      Color(0xfff12711),
    ],
    [
      Color(0xff659999),
      Color(0xfff4791f),
    ]
  ];
  List activity = [
    {
      'title': 'Đồ án tốt nghiệp',
      'name': 'Phạm Thị Miên',
      'subAct': ['Báo Cáo tiến độ']
    },
    {
      'title': 'AI.GTVT.2.20-21',
      'name': 'Nguyễn Đình Hiển',
      'subAct': [
        'BT1 (Nhóm) : Tìm hiểu về AI',
        'BT2 (Nhóm) : Thuật Giải Heuristic',
        'BT3 (Nhóm) : Phương pháp tìm kiếm'
      ]
    },
    {
      'title': 'Phân tích thiết kế hướng đối tượng (k58-utc2)',
      'name': 'Nguyễn Quang Phúc',
      'subAct': []
    },
    {'title': 'data minning 20-21', 'name': 'Trần Phong Nhã', 'subAct': []},
  ];

  showAlertDialog(BuildContext context, String name) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Thoát"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Rời khỏi"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(name),
      content: Text("Bạn có muốn rời khỏi lớp học này ?"),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          child: Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: activity.length,
              itemBuilder: (context, index) {
                return customList(size, context, activity[index]['title'],
                    activity[index]['name'], activity[index]['subAct']);
              },
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            splashColor: ColorApp.mediumBlue,
            hoverColor: ColorApp.red,
            foregroundColor: ColorApp.blue,
            onPressed: () {},
            child: Icon(Icons.add),
          ),
        )
      ],
    );
  }

  Widget customList(Size size, BuildContext context, String className,
      String teacherName, List sub) {
    return Container(
      margin: EdgeInsets.all(size.width * 0.03),
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          border: Border.all(color: ColorApp.lightGrey, width: 1.5)),
      child: Column(
        children: [
          Container(
            height: 150,
            width: size.width,
            padding: EdgeInsets.all(size.width * 0.03),
            decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: colors[Random().nextInt(colors.length)],
                  stops: [0.0, 1.0],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomRight,
                  tileMode: TileMode.repeated),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        className.toUpperCase(),
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          showAlertDialog(context, className.toUpperCase());
                        },
                        icon: Icon(
                          Icons.more_horiz_rounded,
                          color: Colors.white,
                        )),
                  ],
                ),
                Text(
                  teacherName,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          ),
          sub.isNotEmpty
              ? Container(
                  width: size.width,
                  padding: EdgeInsets.all(size.width * 0.03),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      border: Border.all(color: ColorApp.lightGrey, width: 1)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(sub.length, (index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(sub[index].toString()),
                          index == sub.length - 1
                              ? Container()
                              : Divider(
                                  color: ColorApp.black,
                                )
                        ],
                      );
                    }),
                  ))
              : Container(),
        ],
      ),
    );
  }
}
