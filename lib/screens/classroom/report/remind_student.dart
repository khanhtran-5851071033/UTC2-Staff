import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:utc2_staff/service/firestore/class_database.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/utils/utils.dart';

class Score {
  String id;
  String avatar;
  String name;
  String email;
  double score;

  Score({this.id, this.score, this.avatar, this.name, this.email});
}

class Remind extends StatefulWidget {
  final Teacher teacher;

  final Class classUtc;
  final List<Score> listStudent;

  Remind({
    this.teacher,
    this.classUtc,
    this.listStudent,
  });

  @override
  _RemindState createState() => _RemindState();
}

class _RemindState extends State<Remind> {
  List user = [];
  bool isAll = true;
  List<String> listInvite = [];
  List<Score> listScore = [];

  @override
  void initState() {
    for (int i = 0; i < widget.listStudent.length; i++) {
      user.add(true);
    }
    print(widget.listStudent.length);
    super.initState();
  }

  Future<void> send(String nameClass, List<String> listEmail) async {
    final Email email = Email(
      body: 'Cố gắng đi học đều nha em',
      subject: nameClass,
      recipients: listEmail,
      // attachmentPaths: attachments,
      isHTML: true,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
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
              Icons.arrow_back_ios,
              color: ColorApp.black,
            ),
          ),
          elevation: 3,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Danh sách sinh viên',
            style: TextStyle(color: ColorApp.black),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (listInvite.isNotEmpty) {
                  send(widget.classUtc.name, listInvite);
                }
              },
              child: Text('Gửi nhắc nhở'),
            ),
          ],
        ),
        body: Container(
          height: size.height,
          width: size.width,
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'Note : Sinh viên có tỷ lệ nghỉ học trên 50%. Gửi email nhắc nhở đi học.'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Transform.scale(
                  scale: 0.8,
                  child: Checkbox(
                    value: isAll,
                    shape: CircleBorder(),
                    activeColor: ColorApp.mediumBlue,
                    checkColor: ColorApp.lightGrey,
                    onChanged: (value) {
                      setState(() {
                        listInvite = [];

                        for (int i = 0; i < user.length; i++) {
                          user[i] = value;
                          value
                              ? listInvite.add(widget.listStudent[i].email)
                              : listInvite = [];
                        }

                        isAll = value;
                      });
                    },
                  ),
                ),
                Text('Tất cả')
              ],
            ),
            Expanded(
              child: Container(
                width: size.width,
                padding: EdgeInsets.all(size.width * 0.03),
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
                child: widget.listStudent.length > 0
                    ? ListView.builder(
                        itemCount: widget.listStudent.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 7),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: index.isEven
                                    ? ColorApp.lightBlue.withOpacity(.05)
                                    : ColorApp.lightGrey.withOpacity(.2)),
                            child: Row(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Transform.scale(
                                      scale: 0.8,
                                      child: Checkbox(
                                        value: user[index],
                                        activeColor: ColorApp.mediumBlue,
                                        checkColor: ColorApp.lightGrey,
                                        shape: CircleBorder(),
                                        onChanged: (value) {
                                          setState(() {
                                            isAll = false;
                                            user[index] = value;
                                          });
                                          if (value) {
                                            setState(() {
                                              listInvite.add(widget
                                                  .listStudent[index].email);
                                            });
                                          } else {
                                            setState(() {
                                              listInvite.remove(
                                                  widget.listStudent[index].id);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    Text(
                                      (index + 1).toString(),
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: user[index]
                                              ? Colors.transparent
                                              : ColorApp.blue),
                                    )
                                  ],
                                ),
                                Container(
                                  width: 35,
                                  decoration: BoxDecoration(
                                      color: ColorApp.lightGrey,
                                      shape: BoxShape.circle),
                                  padding: EdgeInsets.all(2),
                                  child: CircleAvatar(
                                    radius: 20.0,
                                    backgroundImage: NetworkImage(
                                        widget.listStudent[index].avatar),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          widget.listStudent[index].name ?? ''),
                                      Text(
                                        widget.listStudent[index].id ?? '',
                                        style: TextStyle(
                                            color:
                                                ColorApp.black.withOpacity(.8),
                                            fontSize: 16,
                                            wordSpacing: 1.2,
                                            letterSpacing: 0.2),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      (widget.listStudent[index].score * 100)
                                              .toStringAsFixed(1)
                                              .toString() +
                                          ' %'),
                                )
                              ],
                            ),
                          );
                        },
                      )
                    : Text('Chưa có danh sách'),
              ),
            ),
          ]),
        ));
  }
}
