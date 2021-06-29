import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:utc2_staff/blocs/test_bloc/test_bloc.dart';
import 'package:utc2_staff/blocs/test_bloc/test_event.dart';
import 'package:utc2_staff/blocs/test_bloc/test_state.dart';

import 'package:utc2_staff/screens/classroom/report/report_attenden_class.dart';
import 'package:utc2_staff/screens/classroom/report/report_info_class.dart';
import 'package:utc2_staff/screens/classroom/report/report_test.dart';
import 'package:utc2_staff/service/firestore/class_database.dart';
import 'package:utc2_staff/service/firestore/post_database.dart';
import 'package:utc2_staff/service/firestore/quiz_database.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';

import 'package:utc2_staff/utils/utils.dart';

class ReportClassScreen extends StatefulWidget {
  final Teacher teacher;
  final Class classUtc;
  final List<Post> listPost;

  ReportClassScreen({this.teacher, this.classUtc, this.listPost});
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
  List<Post> listPost1 = [];
  List<Post> listPost = [];

  TestBloc testBloc = new TestBloc();
  @override
  void initState() {
    listPost =
        widget.listPost.where((element) => element.idQuiz != null).toList();
    testBloc = BlocProvider.of<TestBloc>(context);
    testBloc.add(GetTestEvent(widget.classUtc.id, listPost));
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
                        function: () async {
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
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => SplashScreen()));
                          }
                          if (index == 2) {
                            listPost1 = widget.listPost
                                .where((element) => element.idAtten != null)
                                .toList();
                            listPost1.isNotEmpty
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ReportAttendenClass(
                                              teacher: widget.teacher,
                                              classUtc: widget.classUtc,
                                              listPost: listPost,
                                            )))
                                : print('Chua co lịch điểm danh');
                          }
                          if (index == 3) {
                            if (listPost.isNotEmpty) {
                              List<Quiz> listQuiz = [];
                              for (int i = 0; i < listPost.length; i++) {
                                var quiz = await QuizDatabase.getOneQuiz(
                                    widget.teacher.id, listPost[i].idQuiz);
                                listQuiz.add(quiz);
                              }

                              if (listQuiz.length == listPost.length) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BlocBuilder<TestBloc, TestState>(
                                              builder: (context, state) {
                                                if (state is LoadingTest)
                                                  return Container(
                                                    child: Center(
                                                        child:
                                                            SpinKitThreeBounce(
                                                      color: Colors.lightBlue,
                                                      size: size.width * 0.06,
                                                    )),
                                                  );
                                                else if (state is LoadedTest) {
                                                  return ReportTestScreen(
                                                      teacher: widget.teacher,
                                                      classUtc: widget.classUtc,
                                                      listPostQuiz: listPost,
                                                      listQuiz: listQuiz,
                                                      listTest: state.list);
                                                } else if (state
                                                    is LoadErrorTest) {
                                                  return Center(
                                                    child: Text(
                                                      state.error,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20),
                                                    ),
                                                  );
                                                } else {
                                                  return Container(
                                                    child: Center(
                                                        child:
                                                            SpinKitThreeBounce(
                                                      color: Colors.lightBlue,
                                                      size: size.width * 0.06,
                                                    )),
                                                  );
                                                }
                                              },
                                            )));
                              } else {
                                Center(
                                  child: SpinKitThreeBounce(
                                    color: ColorApp.lightBlue,
                                    size: 30,
                                  ),
                                );
                              }
                            }
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
