import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:utc2_staff/screens/classroom/new_quiz.dart';
import 'package:utc2_staff/service/firestore/post_database.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/utils/utils.dart';

class NewNotify extends StatefulWidget {
  final String idClass;
  final Teacher teacher;

  const NewNotify({Key key, this.idClass, this.teacher}) : super(key: key);
  @override
  _NewNotifyState createState() => _NewNotifyState();
}

class _NewNotifyState extends State<NewNotify> {
  bool expaned = false;
  String idAtent = '';
  int _selectedTime = 10;
  PostDatabase postDatabase = PostDatabase();
  String title, content;

  GlobalKey globalKey = new GlobalKey();

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
          'Thông báo mới',
          style: TextStyle(color: ColorApp.black),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final response = await http.post(
                  Uri.parse('https://fcm.googleapis.com/fcm/send'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization':
                        'key=AAAAYogee34:APA91bFuj23NLRj88uqP9J-aRCehCgVSo8QgUOIPZy8CzBE-Xbubx58trUepsb2SABoIGsPYbONqa2jjS03l1fW5r2aQywmKkYN6L3RXHIML6795xTHyamls_ZwLSt-_n3AJ8av82CiW',
                  },
                  body: jsonEncode({
                    "to": "/topics/fcm_test",
                    "data": {"msg": "Hello"},
                    "notification": {
                      "title": title,
                      "body": content,
                    }
                  }));
              if (response.statusCode == 200) {
                print('success');
                Navigator.pop(context);
              } else
                print('faile');
              var idPost = generateRandomString(5);

              Map<String, String> dataPost = {
                'id': idPost,
                'idClass': widget.idClass,
                'title': title,
                'content': content,
                'date':
                    DateFormat('HH:mm –  dd-MM-yyyy').format(DateTime.now()),
              };
              postDatabase.createPost(dataPost, widget.idClass, idPost);
            },
            child: Text("Đăng    ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                padding: EdgeInsets.symmetric(
                    vertical: size.width * 0.03, horizontal: size.width * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 35,
                        child: TextField(
                          onChanged: (val) {
                            setState(() {
                              title = val;
                            });
                          },
                          style: TextStyle(
                              fontSize: 20, color: ColorApp.mediumBlue),
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              isCollapsed: true,
                              hintText: 'Tiêu đề',
                              hintStyle: TextStyle(
                                  fontSize: 16, color: ColorApp.black)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: size.width * 0.03, horizontal: size.width * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 35,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue.withOpacity(.1),
                        child: Icon(
                          Icons.note_add,
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
                        child: TextField(
                          onChanged: (val) {
                            setState(() {
                              content = val;
                            });
                          },
                          style: TextStyle(
                              fontSize: 20, color: ColorApp.mediumBlue),
                          decoration: InputDecoration(
                              // border: InputBorder.none,
                              isCollapsed: true,
                              hintText: 'Chia sẻ với lớp học của bạn',
                              hintStyle: TextStyle(
                                  fontSize: 16, color: ColorApp.black)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.width * 0.02,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: size.width * 0.03, horizontal: size.width * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 35,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue.withOpacity(.1),
                        child: Icon(
                          Icons.attachment,
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
                          child: Text('Tệp đính kèm')),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.width * 0.02,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: size.width * 0.03, horizontal: size.width * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
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
                              Icons.fact_check_rounded,
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
                              child: Text('Điểm danh')),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                expaned ? expaned = false : expaned = true;
                                if (expaned) idAtent = generateRandomString(5);
                              });
                            },
                            icon: Icon(
                              expaned
                                  ? Icons.remove_circle
                                  : Icons.add_circle_rounded,
                              color: ColorApp.mediumBlue,
                            ))
                      ],
                    ),
                    AnimatedCrossFade(
                      firstChild: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'Mã điểm danh: ',
                                    style: TextStyle(
                                        color: ColorApp.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: idAtent,
                                          style: TextStyle(
                                              color: ColorApp.red,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text('Hiệu lực:  '),
                                    DropdownButton<int>(
                                      value: _selectedTime,
                                      items: <int>[10, 15, 20, 30]
                                          .map((int value) {
                                        return new DropdownMenuItem<int>(
                                          value: value,
                                          child: new Text(
                                              value.toString() + ' Phút'),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedTime = newValue;
                                        });
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                            RepaintBoundary(
                              key: globalKey,
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorApp.blue.withOpacity(0.09),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          2, 3), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(0),
                                  // border:
                                  //     Border.all(color: ColorApp.lightGrey)
                                ),
                                child: QrImage(
                                  data: idAtent,
                                  embeddedImage:
                                      AssetImage('assets/images/logoUTC.png'),
                                  version: QrVersions.auto,
                                  size: 120,
                                  gapless: false,
                                  embeddedImageStyle: QrEmbeddedImageStyle(
                                    size: Size(15, 15),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      secondChild: Container(),
                      crossFadeState: expaned
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: Duration(milliseconds: 300),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: size.width * 0.02,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: size.width * 0.03, horizontal: size.width * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 35,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue.withOpacity(.1),
                        child: Icon(
                          Icons.dns_rounded,
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
                          child: Text('Bài tập trắc nghiệm')),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewQuiz()));
                        },
                        icon: Icon(
                          Icons.add_circle_rounded,
                          color: ColorApp.mediumBlue,
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
