import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:utc2_staff/service/firestore/class_database.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';

import 'package:utc2_staff/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:image_gallery_saver/image_gallery_saver.dart';
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
  List user = [
    {
      'avatar':
          'https://images.pexels.com/photos/1987042/pexels-photo-1987042.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      'title': '5851071033@st.utc2.edu.vn',
      'isComplete': false
    },
    {
      'avatar':
          'https://images.unsplash.com/photo-1622060458125-8c9ae7d5f84d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
      'title': '5851071033@st.utc2.edu.vn',
      'isComplete': false
    },
    {
      'avatar':
          'https://images.pexels.com/photos/1987042/pexels-photo-1987042.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      'title': '5851071033@st.utc2.edu.vn',
      'isComplete': true
    },
    {
      'avatar':
          'https://images.pexels.com/photos/1987042/pexels-photo-1987042.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      'title': '5851071033@st.utc2.edu.vn',
      'isComplete': false
    },
    {
      'avatar':
          'https://images.pexels.com/photos/1987042/pexels-photo-1987042.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
      'title': '5851071033@st.utc2.edu.vn',
      'isComplete': false
    },
    {
      'avatar':
          'https://images.unsplash.com/photo-1622060458125-8c9ae7d5f84d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
      'title': '5851071033@st.utc2.edu.vn',
      'isComplete': false
    },
  ];

  GlobalKey globalKey = new GlobalKey();
  // String _dataString = "AziTask.com";

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage();
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      ImageGallerySaver.saveImage(pngBytes,
          name: DateTime.now().toString(), quality: 100);
      Fluttertoast.showToast(
          msg: "Đã lưu vào thư viện",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: ColorApp.mediumBlue,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _shareImage() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage();
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      // await Share.file('Chia sẻ mã QR', 'qr.png', pngBytes, 'image/png',
      //     text: 'QR của lớp học.');
    } catch (e) {
      print('error: $e');
    }
  }

  String idClass, nameClass, description, idTeacher;
  bool isNewClass = false;
  bool isAll = false;
  @override
  void initState() {
    idTeacher = widget.teacher.id;
    // TODO: implement initState
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: size.width * 0.2, vertical: 10),
            child: Text("Tạo mới",
                style: TextStyle(
                    fontSize: size.width * 0.045,
                    letterSpacing: 1,
                    wordSpacing: 1,
                    fontWeight: FontWeight.normal)),
          ),
          style: ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.padded,
              shadowColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Colors.transparent)))),
          onPressed: () async {
            // final pdfFile = await PdfParagraphApi.generate();
            // PdfApi.openFile(pdfFile);

            if (_formKey.currentState.validate()) {
              Map<String, String> dataClass = {
                'id': idClass,
                'name': nameClass,
                'note': description,
                'teacherId': idTeacher,
                'date':
                    DateFormat('HH:mm –  dd-MM-yyyy').format(DateTime.now()),
              };
              classdb.createClass(dataClass, idClass);

              Get.back();
            }
          }),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: size.width * 0.03, horizontal: size.width * 0.03),
              // child:
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
                        horizontal: size.width * 0.03,
                        vertical: size.width * 0.03),
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
                            style: TextStyle(
                                fontSize: 20, color: ColorApp.mediumBlue),
                            decoration: InputDecoration(
                                // border: InputBorder.none,
                                labelText: 'Tên lớp..',
                                labelStyle: TextStyle(
                                    fontSize: 18, color: ColorApp.black)),
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
                                              backgroundColor:
                                                  ColorApp.mediumBlue,
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
                                            data:
                                                idClass == null ? '' : idClass,
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
                                      Padding(
                                        padding: EdgeInsets.only(right: 16.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            _captureAndSharePng();
                                          },
                                          child: Text(
                                            'Lưu vào thư viện',
                                            style:
                                                TextStyle(color: ColorApp.blue),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _shareImage();
                                        },
                                        child: Text(
                                          'Chia sẻ',
                                          style:
                                              TextStyle(color: ColorApp.blue),
                                        ),
                                      )
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
                        horizontal: size.width * 0.03,
                        vertical: size.width * 0.03),
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
                            style: TextStyle(
                                fontSize: 20, color: ColorApp.mediumBlue),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Mô tả..',
                                labelStyle: TextStyle(
                                    fontSize: 18, color: ColorApp.black)),
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
                        horizontal: size.width * 0.03,
                        vertical: size.width * 0.03),
                    child: Column(
                      children: [
                        Container(
                          width: size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(bottom: BorderSide(width: .5))),
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
                              Text('Thêm',
                                  style: TextStyle(
                                      fontSize: 18, color: ColorApp.black)),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('Tất cả (' +
                                          user.length.toString() +
                                          ")"),
                                      Transform.scale(
                                        scale: 0.8,
                                        child: Checkbox(
                                          value: isAll,
                                          shape: CircleBorder(),
                                          activeColor: ColorApp.mediumBlue,
                                          checkColor: ColorApp.lightGrey,
                                          onChanged: (value) {
                                            setState(() {
                                              for (int i = 0;
                                                  i < user.length;
                                                  i++) {
                                                user[i]['isComplete'] = value;
                                              }
                                              isAll = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: size.height * 0.4,
                          decoration: BoxDecoration(color: Colors.white),
                          child: ListView.builder(
                            itemCount: user.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 35,
                                          decoration: BoxDecoration(
                                              color: ColorApp.lightGrey,
                                              shape: BoxShape.circle),
                                          padding: EdgeInsets.all(2),
                                          child: CircleAvatar(
                                            radius: 20.0,
                                            backgroundImage: NetworkImage(
                                                user[index]['avatar']),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          user[index]['title'],
                                          style: TextStyle(
                                              color: ColorApp.black
                                                  .withOpacity(.8),
                                              fontSize: 16,
                                              wordSpacing: 1.2,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.2),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Transform.scale(
                                          scale: 0.8,
                                          child: Checkbox(
                                            value: user[index]['isComplete'],
                                            activeColor: ColorApp.mediumBlue,
                                            checkColor: ColorApp.lightGrey,
                                            shape: CircleBorder(),
                                            onChanged: (value) {
                                              setState(() {
                                                setState(() {
                                                  user[index]['isComplete'] =
                                                      value;
                                                });
                                              });
                                            },
                                          ),
                                        ),
                                        Text(
                                          (index + 1).toString(),
                                          style: TextStyle(
                                              fontSize: 9,
                                              color: user[index]['isComplete']
                                                  ? Colors.transparent
                                                  : ColorApp.blue),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
