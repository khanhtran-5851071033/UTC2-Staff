import 'package:flutter/material.dart';
import 'package:utc2_staff/utils/utils.dart';

class AddScheduleScreen extends StatefulWidget {
  @override
  _AddScheduleScreenState createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController controllerNameSchedule = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(context, () {}),
      body: Container(
        child: Column(
          children: [
            Container(
              width: size.width,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: ColorApp.blue.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03, vertical: size.width * 0.03),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 35,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue.withOpacity(.1),
                          child: Icon(
                            Icons.desktop_mac_rounded,
                            color: Colors.blue,
                            size: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: 35,
                            child: Text(
                              'Thông tin môn học',
                              style: TextStyle(
                                  color: ColorApp.black, fontSize: 18),
                            )),
                      ),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: controllerNameSchedule,
                      validator: (val) =>
                          val.isEmpty ? 'Vui lòng nhập tên môn học' : null,
                      style:
                          TextStyle(fontSize: 20, color: ColorApp.mediumBlue),
                      decoration: InputDecoration(
                          // border: InputBorder.none,
                          labelText: 'Tên lớp..',
                          labelStyle:
                              TextStyle(fontSize: 18, color: ColorApp.black)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.width * 0.03,
            ),
          ],
        ),
      ),
    );
  }
}

Widget appBar(BuildContext context, Function function) {
  return AppBar(
    leading: IconButton(
      color: ColorApp.lightGrey,
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.close_rounded,
        color: ColorApp.black,
      ),
    ),
    elevation: 0,
    backgroundColor: Colors.white,
    centerTitle: true,
    title: Text(
      'Lịch giảng mới',
      style: TextStyle(color: ColorApp.black),
    ),
    actions: [
      TextButton.icon(
          onPressed: function,
          icon: Icon(
            Icons.add_circle,
            size: 15,
          ),
          label: Text(
            'Tạo mới',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          )),
      SizedBox(
        width: 15,
      )
    ],
  );
}
