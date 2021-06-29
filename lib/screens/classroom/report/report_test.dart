import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:utc2_staff/blocs/student_bloc/student_bloc.dart';
import 'package:utc2_staff/service/firestore/class_database.dart';
import 'package:utc2_staff/service/firestore/post_database.dart';
import 'package:utc2_staff/service/firestore/quiz_database.dart';
import 'package:utc2_staff/service/firestore/student_database.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/service/firestore/test_student_database.dart';
import 'package:utc2_staff/utils/utils.dart';

class ReportTestScreen extends StatefulWidget {
  final Teacher teacher;
  final Class classUtc;
  final List<Post> listPostQuiz;
  final List<Quiz> listQuiz;
  final List<StudentTest> listTest;

  ReportTestScreen(
      {this.teacher,
      this.classUtc,
      this.listPostQuiz,
      this.listQuiz,
      this.listTest});
  @override
  _ReportTestScreenState createState() => _ReportTestScreenState();
}

class _ReportTestScreenState extends State<ReportTestScreen> {
  Widget textHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget textRow(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      softWrap: true,
      maxLines: 2,
      overflow: TextOverflow.clip,
      style: TextStyle(color: ColorApp.black),
    );
  }

  Widget headerTable(List<Quiz> listQuiz) {
    int numberTest = listQuiz.length ?? 0;
    return Container(
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
              flex: numberTest == 0
                  ? 3
                  : numberTest <= 3
                      ? 4
                      : numberTest <= 5 && numberTest > 3
                          ? 8
                          : 12,
              child: Container(
                child: Column(
                  children: [
                    numberTest == 0
                        ? textHeader('Chưa có bài Test')
                        : Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(color: Colors.white),
                                    bottom: BorderSide(color: Colors.white))),
                            child: textHeader('Điểm bài Test')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(numberTest, (index) {
                        return Expanded(
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(color: Colors.white))),
                              child: textHeader(listQuiz[index].titleQuiz)),
                        );
                      }),
                    )
                  ],
                ),
              )),
          Expanded(flex: 4, child: textHeader('Họ và tên')),
          Expanded(flex: 3, child: textHeader('Mã sinh viên')),
          Expanded(flex: 2, child: textHeader('Lớp')),
        ],
      ),
    );
  }

  Widget rowTable(int stt, List<Quiz> listQuiz, List<Post> listPost,
      List<StudentTest> listStudentTest, Student student) {
    int numberTest = listQuiz.length ?? 0;
    return Container(
      color: stt.isEven
          ? ColorApp.lightGrey.withOpacity(.2)
          : Colors.blue.withOpacity(.08),
      margin: EdgeInsets.only(bottom: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
              flex: numberTest == 0
                  ? 3
                  : numberTest <= 3
                      ? 4
                      : numberTest <= 5 && numberTest > 3
                          ? 8
                          : 12,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                      numberTest,
                      (index) => Expanded(
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    border: Border(
                                        right:
                                            BorderSide(color: Colors.white))),
                                child: textRow(listStudentTest
                                        .where((element) =>
                                            element.idStudent == student.id &&
                                            element.idQuiz ==
                                                listPost[index].idQuiz &&
                                            element.idPost ==
                                                listPost[index].id)
                                        .isNotEmpty
                                    ? listStudentTest
                                        .where((element) =>
                                            element.idStudent == student.id &&
                                            element.idQuiz ==
                                                listPost[index].idQuiz &&
                                            element.idPost ==
                                                listPost[index].id)
                                        .first
                                        .score
                                    : '0')),
                          )),
                ),
              )),
          Expanded(flex: 4, child: textRow(student.name)),
          Expanded(flex: 3, child: textRow(student.id)),
          Expanded(flex: 2, child: textRow(student.lop)),
        ],
      ),
    );
  }

  StudentBloc studentBloc = new StudentBloc();
  List score = [];
  @override
  void initState() {
    studentBloc = BlocProvider.of<StudentBloc>(context);
    studentBloc.add(GetListStudentOfClassEvent(widget.classUtc.id));
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
        elevation: 3,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Xem trước',
          style: TextStyle(color: ColorApp.black),
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {},
            icon: Image.asset(
              'assets/icons/pdf.png',
              width: 20,
            ),
            label: Text('In báo cáo'),
          ),
        ],
      ),
      body: Container(
        height: size.height,
        color: Colors.white,
        margin: EdgeInsets.only(top: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return BlocConsumer<StudentBloc, StudentState>(
                        listener: (context, state) {
                          // if (state is LoadedStudentState) {
                          //   for (var student in state.listStudent) {
                          //     for (int i = 0; i < widget.listTest.length; i++) {
                          //       if (widget.listTest[i].idStudent ==
                          //           student.id) {
                          //         score.add(widget.listTest[i].score);
                          //         break;
                          //       }
                          //     }
                          //     score.add('0');
                          //   }
                          //   print(score);
                          // }
                        },
                        builder: (context, state) {
                          return BlocBuilder<StudentBloc, StudentState>(
                            builder: (context, state) {
                              if (state is StudentInitial) {
                                return Center(
                                  child: SpinKitThreeBounce(
                                    color: ColorApp.lightBlue,
                                    size: 30,
                                  ),
                                );
                              } else if (state is LoadingStudentState) {
                                return Center(
                                  child: SpinKitThreeBounce(
                                    color: ColorApp.lightBlue,
                                    size: 30,
                                  ),
                                );
                              } else if (state is LoadedStudentState) {
                                return Container(
                                    height: size.height,
                                    width: widget.listQuiz.length >= 3
                                        ? size.width * 1.6
                                        : size.width * 1.3,
                                    child: Column(children: [
                                      headerTable(widget.listQuiz),
                                      Expanded(
                                          child: ListView.builder(
                                              itemCount:
                                                  state.listStudent.length,
                                              itemBuilder: (contex, index) {
                                                var student =
                                                    state.listStudent[index];

                                                return rowTable(
                                                    index,
                                                    widget.listQuiz,
                                                    widget.listPostQuiz,
                                                    widget.listTest,
                                                    student);
                                              }))
                                    ]));
                              } else if (state is LoadErrorStudentState) {
                                return Center(
                                    child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    state.error,
                                    style: TextStyle(
                                        fontSize: 16, color: ColorApp.red),
                                  ),
                                ));
                              } else
                                return Center(
                                  child: SpinKitThreeBounce(
                                    color: ColorApp.lightBlue,
                                    size: 30,
                                  ),
                                );
                            },
                          );
                        },
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
