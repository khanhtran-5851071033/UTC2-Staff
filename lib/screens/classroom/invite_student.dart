import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:utc2_staff/blocs/student_bloc/student_bloc.dart';
import 'package:utc2_staff/service/firestore/student_database.dart';
import 'package:utc2_staff/utils/utils.dart';

class InviteStudentScreen extends StatefulWidget {
  @override
  _InviteStudentScreenState createState() => _InviteStudentScreenState();
}

class _InviteStudentScreenState extends State<InviteStudentScreen> {
  List user = [];
  bool isAll = false;
  String generation = "Tất cả";
  String course = "Tất cả";
  String nameClass = "Tất cả";
  StudentBloc studentBloc;
  List<Student> listInvite = [];
  List<String> listHeDaoTao = [
    'Tất cả',
    'Chính quy',
    'Vừa học vừa làm',
    'Cao học'
  ];
  int indexHe = 0;
  List listKhoa = [
    ['Tất cả', 'Khoá 58', 'Kh 59', 'Vừa học vừa làm', 'Cao Học'],
    ['Tất cả', 'Khoá 58', 'Khoá 59'],
    ['Tất cả', 'Vừa học vừa làm'],
    ['Tất cả', 'Cao Học'],
  ];

  @override
  void initState() {
    super.initState();
    studentBloc = BlocProvider.of<StudentBloc>(context);
    studentBloc.add(GetListStudentEvent());
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
            'Danh sách sinh viên',
            style: TextStyle(color: ColorApp.black),
          ),
          actions: [
            TextButton.icon(
                onPressed: () {
                  Get.back(result: listInvite);
                },
                icon: Icon(
                  Icons.add_circle,
                  size: 15,
                ),
                label: Text(
                  'Mời',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                )),
            SizedBox(
              width: 15,
            )
          ]),
      body: Container(
        height: size.height,
        padding: EdgeInsets.all(size.width * 0.03),
        child: Column(
          children: [
            Container(
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
                child: Column(
                  children: [
                    Filter(
                      title: 'Hệ đào tạo',
                      value: generation,
                      item: listHeDaoTao,
                      function: (val) {
                        setState(() {
                          generation = val;
                          course = 'Tất cả';
                          indexHe = listHeDaoTao.indexOf(val);
                        });

                        studentBloc.add(FilterListStudentEvent(
                            course, nameClass, generation));
                      },
                    ),
                    Filter(
                      title: 'Khóa',
                      value: course,
                      item: listKhoa[indexHe],
                      function: (val) {
                        setState(() {
                          course = val;
                        });
                        print(course);
                        studentBloc.add(FilterListStudentEvent(
                            course, nameClass, generation));
                      },
                    ),
                    Filter(
                      title: 'Lớp',
                      value: nameClass,
                      item: [
                        'Tất cả',
                        'CQ.58.CNTT',
                        'CQ.59.LOG.1',
                      ],
                      function: (val) {
                        setState(() {
                          nameClass = val;
                        });
                        studentBloc.add(FilterListStudentEvent(
                            course, nameClass, generation));
                      },
                    ),
                  ],
                )),
            Expanded(
              child: BlocConsumer<StudentBloc, StudentState>(
                listener: (context, state) {
                  if (state is LoadedStudentState) {
                    setState(() {
                      user = [];
                      for (int i = 0; i < state.listStudent.length; i++) {
                        user.add(false);
                      }
                    });
                  }
                },
                builder: (context, state) {
                  if (state is LoadedStudentState) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                          ? listInvite.add(state.listStudent[i])
                                          : listInvite = [];
                                    }

                                    isAll = value;
                                  });
                                },
                              ),
                            ),
                            Text('Tất cả (' +
                                state.listStudent.length.toString() +
                                ")"),
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
                                    offset: Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: ListView.builder(
                              itemCount: state.listStudent.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 5),
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
                                                    listInvite.add(state
                                                        .listStudent[index]);
                                                  });
                                                } else {
                                                  setState(() {
                                                    listInvite.remove(state
                                                        .listStudent[index].id);
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
                                              state.listStudent[index].avatar),
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
                                            Text(state.listStudent[index].name),
                                            Text(
                                              state.listStudent[index].id,
                                              style: TextStyle(
                                                  color: ColorApp.black
                                                      .withOpacity(.8),
                                                  fontSize: 16,
                                                  wordSpacing: 1.2,
                                                  letterSpacing: 0.2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  } else
                    return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Filter extends StatelessWidget {
  final String title;
  final String value;
  final List<String> item;
  final Function function;

  Filter({this.title, this.value, this.item, this.function});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(title + ':   '),
          DropdownButton<String>(
            value: value,
            items: item.map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(
                  value,
                  style: TextStyle(color: ColorApp.mediumBlue),
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              function(newValue);
            },
          )
        ],
      ),
    );
  }
}
