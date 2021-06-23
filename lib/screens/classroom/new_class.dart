import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:utc2_staff/screens/classroom/invite_student.dart';
import 'package:utc2_staff/service/firestore/class_database.dart';
import 'package:utc2_staff/service/firestore/student_database.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/service/push_noti_firebase.dart';
import 'package:utc2_staff/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';

class NewClass extends StatefulWidget {
  final Teacher teacher;

  const NewClass({Key key, this.teacher}) : super(key: key);
  @override
  _NewClassState createState() => _NewClassState();
}

class _NewClassState extends State<NewClass> {
  ClassDatabase classdb = ClassDatabase();
  final _formKey = GlobalKey<FormState>();

  GlobalKey globalKey = new GlobalKey();

  // Future<void> _captureAndSharePng() async {
  //   RenderRepaintBoundary boundary =
  //       globalKey.currentContext.findRenderObject();
  //   ui.Image image = await boundary.toImage();
  //   ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //   Uint8List pngBytes = byteData.buffer.asUint8List();
  //   ImageGallerySaver.saveImage(pngBytes,
  //       name: DateTime.now().toString(), quality: 100);

  //   // Fluttertoast.showToast(
  //   //     msg: "Đã lưu vào thư viện",
  //   //     toastLength: Toast.LENGTH_SHORT,
  //   //     gravity: ToastGravity.CENTER,
  //   //     timeInSecForIosWeb: 1,
  //   //     backgroundColor: ColorApp.mediumBlue,
  //   //     textColor: Colors.white,
  //   //     fontSize: 16.0);
  // }

  // Future<void> _shareImage() async {
  //   try {
  //     RenderRepaintBoundary boundary =
  //         globalKey.currentContext.findRenderObject();
  //     ui.Image image = await boundary.toImage();
  //     final directory = (await getExternalStorageDirectory()).path;
  //     ByteData byteData =
  //         await image.toByteData(format: ui.ImageByteFormat.png);
  //     Uint8List pngBytes = byteData.buffer.asUint8List();
  //     File imgFile = new File('$directory/$DateTime' + '.png');
  //     imgFile.writeAsBytes(pngBytes);
  //     // await Share.file('Chia sẻ mã QR', 'qr.png', pngBytes, 'image/png',
  //     //     text: 'QR của lớp học.');
  //   } catch (e) {
  //     print('error: $e');
  //   }
  // }

  List<Student> listInvite = [];
  String idClass, nameClass, description, idTeacher;
  bool isNewClass = false;
  bool isAll = false;
  @override
  void initState() {
    idTeacher = widget.teacher.id;
    super.initState();
  }

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
            Icons.close_rounded,
            color: ColorApp.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Lớp học mới',
          style: TextStyle(color: ColorApp.black),
        ),
        actions: [
          TextButton.icon(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                     await FirebaseMessaging.instance.subscribeToTopic(idClass);
                  Map<String, String> dataClass = {
                    'id': idClass,
                    'name': nameClass,
                    'note': description ?? '',
                    'teacherId': idTeacher,
                    'date': DateTime.now().toString()
                  };
                  classdb.createClass(dataClass, idClass);
                   PushNotiFireBaseAPI.pushNotiTopic(
                      nameClass,
                      idClass,
                      {
                        "idNoti": 'newClass',
                        "msg": idClass,
                        "idChannel": idClass,
                        "className": nameClass,
                        "classDescription": description ?? '',
                        "nameTeacher": widget.teacher.name,
                        "content": "Đã tạo lớp mới: " +
                            nameClass +
                            "\n" +
                            "Mã lớp : " +
                            idClass,
                        "avatar": widget.teacher.avatar,
                        "name": widget.teacher.name,
                      },
                      idClass);
                  if (listInvite.isNotEmpty) {
                    for (var e in listInvite) {
                      PushNotiFireBaseAPI.pushNotiToken(
                          nameClass,
                          idClass,
                          {
                            "idNoti": 'newClass',
                            "msg": idClass,
                            "idChannel": idClass,
                            "className": nameClass,
                            "classDescription": description ?? '',
                            "nameTeacher": widget.teacher.name,
                            "content": "Đã tạo lớp mới: " +
                                nameClass +
                                "\n" +
                                "Mã lớp : " +
                                idClass,
                            "avatar": widget.teacher.avatar,
                            "name": widget.teacher.name,
                          },
                          e.token);
                    }
                  }

               
                 
                  Get.back();
                }
              },
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
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: size.width * 0.03, horizontal: size.width * 0.03),
          child: Column(
            children: [
              Container(
                width: size.width,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: ColorApp.blue.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
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
                                'Thông tin lớp học',
                                style: TextStyle(
                                    color: ColorApp.black, fontSize: 18),
                              )),
                        ),
                      ],
                    ),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: (val) =>
                            val.isEmpty ? 'Vui lòng nhập tên lớp' : null,
                        onChanged: (value) {
                          if (value.length > 0) {
                            setState(() {
                              idClass = generateRandomString(5);
                              isNewClass = true;
                              nameClass = value;
                            });
                          } else {
                            setState(() {
                              idClass = value;
                              isNewClass = false;
                              nameClass = value;
                            });
                          }
                        },
                        style:
                            TextStyle(fontSize: 20, color: ColorApp.mediumBlue),
                        decoration: InputDecoration(
                            // border: InputBorder.none,
                            labelText: 'Tên lớp..',
                            labelStyle:
                                TextStyle(fontSize: 18, color: ColorApp.black)),
                      ),
                    ),
                    AnimatedCrossFade(
                        secondChild: Container(),
                        crossFadeState: isNewClass
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: Duration(milliseconds: 300),
                        firstChild: Container(
                          width: size.width,
                          margin: EdgeInsets.only(top: 15),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Mã lớp :'),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    idClass == null ? '' : idClass,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(
                                          ClipboardData(text: idClass));
                                      Fluttertoast.showToast(
                                          msg: "Đã sao chép " + idClass,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: ColorApp.mediumBlue,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    },
                                    child: Icon(
                                      Icons.copy_rounded,
                                      size: 15,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Mã QR :'),
                                  RepaintBoundary(
                                    key: globalKey,
                                    child: Container(
                                      color: Colors.white,
                                      child: QrImage(
                                        data: idClass == null ? '' : idClass,
                                        embeddedImage: AssetImage(
                                            'assets/images/logoUTC.png'),
                                        version: QrVersions.auto,
                                        size: 120,
                                        gapless: false,
                                        embeddedImageStyle:
                                            QrEmbeddedImageStyle(
                                          size: Size(15, 15),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: EdgeInsets.only(right: 16.0),
                                  //   child: TextButton(
                                  //     onPressed: () {
                                  //       _captureAndSharePng();
                                  //     },
                                  //     child: Text(
                                  //       'Lưu vào thư viện',
                                  //       style:
                                  //           TextStyle(color: ColorApp.blue),
                                  //     ),
                                  //   ),
                                  // ),
                                  // TextButton(
                                  //   onPressed: () {
                                  //     _shareImage();
                                  //   },
                                  //   child: Text(
                                  //     'Chia sẻ',
                                  //     style:
                                  //         TextStyle(color: ColorApp.blue),
                                  //   ),
                                  // )
                                ],
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: size.width * 0.03,
              ),
              Container(
                width: size.width,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: ColorApp.blue.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03, vertical: size.width * 0.03),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 35,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue.withOpacity(.1),
                        child: Icon(
                          Icons.edit,
                          color: Colors.blue,
                          size: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (val) {
                          setState(() {
                            description = val;
                          });
                        },
                        style:
                            TextStyle(fontSize: 20, color: ColorApp.mediumBlue),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Mô tả..',
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
              Container(
                width: size.width,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: ColorApp.blue.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03, vertical: size.width * 0.03),
                child: Column(
                  children: [
                    Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 35,
                            child: CircleAvatar(
                              backgroundColor: Colors.blue.withOpacity(.1),
                              child: Icon(
                                Icons.group_add,
                                color: Colors.blue,
                                size: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Text('Thêm',
                                style: TextStyle(
                                    fontSize: 18, color: ColorApp.black)),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                InviteStudentScreen()))
                                    .then((value) {
                                  if (value != null) {
                                    if (listInvite.isNotEmpty) {
                                      for (Student item in value) {
                                        bool trung = false;
                                        for (var st in listInvite) {
                                          if (item.id == st.id) {
                                            trung = true;
                                            break;
                                          }
                                        }
                                        if (!trung) {
                                          setState(() {
                                            listInvite.add(item);
                                          });
                                        }
                                      }
                                    } else {
                                      for (Student item in value) {
                                        setState(() {
                                          listInvite.add(item);
                                        });
                                      }
                                    }
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.add_circle_rounded,
                                color: ColorApp.mediumBlue,
                              )),
                        ],
                      ),
                    ),
                    listInvite != null
                        ? Container(
                            width: size.width,
                            height: 500,
                            child: ListView.builder(
                              itemCount: listInvite.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: index.isEven
                                          ? ColorApp.lightBlue.withOpacity(.05)
                                          : ColorApp.lightGrey.withOpacity(.2)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(listInvite[index].name),
                                      Text(
                                        listInvite[index].id + '   ',
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
