import 'dart:io';

import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileInfo extends StatefulWidget {
  final Teacher teacher;

  ProfileInfo({Key key, this.teacher}) : super(key: key);
  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  File _image;
  String linkImage = '';
  @override
  void initState() {
    linkImage = widget.teacher.avatar;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
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
          'Thông tin cá nhân',
          style: TextStyle(color: ColorApp.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, ColorApp.lightGrey])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(top: 10),
                child: Center(child: _avatar(_image, size, linkImage))),
            SizedBox(
              height: 20,
            ),
            _name(widget.teacher.name, size),
            SizedBox(
              height: 7,
            ),
            info('Ngày sinh : ', '00/00/2021', size),
            SizedBox(
              height: 7,
            ),
            info('Mã : ', widget.teacher.id, size),
            SizedBox(
              height: 7,
            ),
            info('Chức vụ: ', 'Giảng viên', size),
            SizedBox(
              height: 7,
            ),
            _email(widget.teacher.email, size),
          ],
        ),
      ),
    );
  }
}

Widget info(String info, String day, Size size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(info),
      Text(day,
          style: TextStyle(
              color: ColorApp.black,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.normal)),
    ],
  );
}

Widget _email(String email, Size size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text('Email : '),
      Text(email,
          style: TextStyle(
              color: ColorApp.lightBlue,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.normal)),
    ],
  );
}

Widget _name(String name, Size size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text('Họ và tên : '),
      Text(name,
          style: TextStyle(
              color: ColorApp.black,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.w600)),
    ],
  );
}

Widget _avatar(File path, Size size, String imageLink) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        width: size.width * 0.26,
        height: size.width * 0.26,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                width: 1, color: Colors.green, style: BorderStyle.solid),
          ),
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
          image: (imageLink != null)
              ? DecorationImage(
                  image: NetworkImage(
                    imageLink,
                  ),
                  fit: BoxFit.cover,
                )
              : (path == null)
                  ? DecorationImage(
                      image: AssetImage('assets/images/gv.jpg'),
                      fit: BoxFit.cover)
                  : DecorationImage(
                      image: Image.file(path).image, fit: BoxFit.cover),
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: GestureDetector(
          onTap: () {},
          child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                Icons.add_a_photo,
                color: Colors.grey,
                size: 16,
              )),
        ),
      )
    ],
  );
}
