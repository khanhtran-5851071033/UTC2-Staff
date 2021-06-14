import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utc2_staff/blocs/atttend_student_bloc/attend_bloc.dart';
import 'package:utc2_staff/blocs/atttend_student_bloc/attend_event.dart';
import 'package:utc2_staff/blocs/atttend_student_bloc/attend_state.dart';
import 'package:utc2_staff/service/firestore/class_database.dart';
import 'package:utc2_staff/service/firestore/post_database.dart';
import 'package:utc2_staff/service/firestore/student_database.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/utils/utils.dart';

class InfoAteen extends StatefulWidget {
  final Teacher teacher;
  final Class classUtc;
  final Student student;
  final List<Post> listPost;
  final Post curPost;
  final ScrollController controller;
  InfoAteen(this.teacher, this.classUtc, this.controller, this.student,
      this.listPost, this.curPost);

  @override
  _InfoAteenState createState() => _InfoAteenState();
}

class _InfoAteenState extends State<InfoAteen> {
  bool isCheck = true;

  Future<void> _launchInWebViewWithJavaScript(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  PageController controller;
  ValueNotifier<int> _pageNotifier;
  int _curr = 0;
  // getSudentAttend(idClass, idPost, idStudent) async {
  //   var student = await StudentDatabase.getStudentsOfClassOfAttend(
  //       idClass, idPost, idStudent);
  //   return student;
  // }
  AttendStudentBloc attenStudentBloc = new AttendStudentBloc();
  @override
  void initState() {
    attenStudentBloc = BlocProvider.of<AttendStudentBloc>(context);

    super.initState();
    // attenStudentBloc.add(GetListStudentOfClassOfAttendEvent(
    //   widget.classUtc.id,
    //   widget.curPost.id,
    // ));
    _curr = widget.listPost.indexOf(widget.curPost);
    _pageNotifier = new ValueNotifier<int>(_curr);
    controller = PageController(initialPage: _curr, viewportFraction: 0.9);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(children: [
      Expanded(
          child: ListView.builder(
              controller: widget.controller,
              itemCount: 1,
              itemBuilder: (_, index) {
                return Column(
                  children: [
                    Text('Đợt ' +
                        (widget.listPost.length - _curr).toString() +
                        '/' +
                        widget.listPost.length.toString()),
                    Center(
                      child: DotsIndicator(
                        dotsCount: widget.listPost.length,
                        mainAxisAlignment: MainAxisAlignment.center,
                        position: _pageNotifier.value.toDouble(),
                        decorator: DotsDecorator(
                          color: ColorApp.lightGrey, // Inactive color
                          activeColor: ColorApp.lightBlue,
                          size: Size.square(9.0),
                          activeSize: Size(18.0, 9.0),
                          activeShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: size.height,
                      // padding: EdgeInsets.all(size.width * 0.03),
                      child: PageView.builder(
                          itemCount: widget.listPost.length,
                          controller: controller,
                          onPageChanged: (num) {
                            setState(() {
                              _curr = num;
                              _pageNotifier.value = num;
                            });
                            attenStudentBloc
                                .add(GetListStudentOfClassOfAttendEvent(
                              widget.classUtc.id,
                              widget.listPost[_curr].id,
                            ));
                          },
                          itemBuilder: (BuildContext context, int itemIndex) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.listPost[itemIndex].date !=
                                                        null
                                                    ? 'Thời gian điểm danh : ' +
                                                        DateFormat.EEEE('vi')
                                                            .format(DateFormat(
                                                                    "yyyy-MM-dd HH:mm:ss")
                                                                .parse(widget
                                                                    .listPost[
                                                                        itemIndex]
                                                                    .date)) +
                                                        DateFormat(' ,HH:mm - dd-MM-yyyy')
                                                            .format(DateFormat(
                                                                    "yyyy-MM-dd HH:mm:ss")
                                                                .parse(widget
                                                                    .listPost[itemIndex]
                                                                    .date))
                                                    : '',
                                                softWrap: true,
                                                maxLines: 2,
                                                overflow: TextOverflow.clip,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                widget.listPost[itemIndex]
                                                            .idAtten !=
                                                        null
                                                    ? 'Mã điểm danh : ' +
                                                        widget
                                                            .listPost[itemIndex]
                                                            .idAtten
                                                    : '',
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                widget.listPost[itemIndex]
                                                            .timeAtten !=
                                                        null
                                                    ? 'Hạn : ' +
                                                        DateFormat(
                                                                'HH:mm - dd-MM-yyyy')
                                                            .format(DateFormat(
                                                                    "yyyy-MM-dd HH:mm:ss")
                                                                .parse(widget
                                                                    .listPost[
                                                                        itemIndex]
                                                                    .timeAtten))
                                                    : '',
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                        //qr
                                        Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: ColorApp.blue
                                                    .withOpacity(0.09),
                                                spreadRadius: 3,
                                                blurRadius: 5,
                                                offset: Offset(2,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            // border:
                                            //     Border.all(color: ColorApp.lightGrey)
                                          ),
                                          child: QrImage(
                                            data: widget
                                                .listPost[itemIndex].idAtten,
                                            embeddedImage: AssetImage(
                                                'assets/images/logoUTC.png'),
                                            version: QrVersions.auto,
                                            size: 100,
                                            gapless: false,
                                            embeddedImageStyle:
                                                QrEmbeddedImageStyle(
                                              size: Size(17, 17),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: ColorApp.blue
                                                  .withOpacity(0.02),
                                              spreadRadius: 3,
                                              blurRadius: 5,
                                              offset: Offset(-4,
                                                  4), // changes position of shadow
                                            ),
                                          ],
                                          gradient: LinearGradient(
                                              stops: [0.2, 0.9],
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.white,
                                                ColorApp.lightGrey
                                              ]),
                                          // color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: ColorApp.lightGrey,
                                              width: 0.1)),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(4),
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      ColorApp.lightGrey,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                          widget
                                                              .student.avatar),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    widget.teacher.name != null
                                                        ? 'Sinh viên : ' +
                                                            widget.student.name
                                                        : '',
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    widget.teacher.id != null
                                                        ? 'Mã sinh viên : ' +
                                                            widget.student.id
                                                        : '',
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          //zo day
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          //zo day
                                          BlocBuilder<AttendStudentBloc,
                                              AttendStudentState>(
                                            builder: (context, state) {
                                              if (state is AttendInitial) {
                                                return SpinKitThreeBounce(
                                                  color: ColorApp.lightBlue,
                                                );
                                              } else if (state
                                                  is LoadingAttend) {
                                                return SpinKitThreeBounce(
                                                  color: ColorApp.lightBlue,
                                                );
                                              } else if (state
                                                  is LoadedAttend) {
                                                // if (state.list.isNotEmpty) {
                                                List<StudentAttend>
                                                    listAttenOfStudent = state
                                                        .list
                                                        .where((element) =>
                                                            element.id ==
                                                            widget.student.id)
                                                        .toList();
                                                return listAttenOfStudent
                                                            .length <=
                                                        0
                                                    ? Container(
                                                        child: Text(
                                                            'Chưa điểm danh'),
                                                      )
                                                    : Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  listAttenOfStudent[0]
                                                                              .timeAttend !=
                                                                          null
                                                                      ? 'Có mặt lúc : ' +
                                                                          DateFormat('HH:mm - dd-MM-yyyy')
                                                                              .format(DateFormat("yyyy-MM-dd HH:mm:ss").parse(listAttenOfStudent[0].timeAttend))
                                                                      : '',
                                                                ),
                                                                Icon(
                                                                  isCheck
                                                                      ? Icons
                                                                          .check
                                                                      : Icons
                                                                          .close,
                                                                  size: 17,
                                                                  color: isCheck
                                                                      ? Colors
                                                                          .lightGreen
                                                                      : ColorApp
                                                                          .red,
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      listAttenOfStudent[0].address !=
                                                                              null
                                                                          ? 'Vị trí : ' +
                                                                              listAttenOfStudent[0].address
                                                                          : 'Vị trí : ',
                                                                      softWrap:
                                                                          true,
                                                                      maxLines:
                                                                          3,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .clip,
                                                                    ),
                                                                  ),
                                                                  Icon(
                                                                    isCheck
                                                                        ? Icons
                                                                            .check
                                                                        : Icons
                                                                            .close,
                                                                    size: 17,
                                                                    color: isCheck
                                                                        ? Colors
                                                                            .lightGreen
                                                                        : ColorApp
                                                                            .red,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'Tọa độ : ',
                                                                  ),
                                                                  Expanded(
                                                                    child: InkWell(
                                                                        onTap: () {
                                                                          _launchInWebViewWithJavaScript(
                                                                              'https://www.google.com/maps/place/${listAttenOfStudent[0].location}');
                                                                        },
                                                                        child: Text(
                                                                          listAttenOfStudent[0].location != null
                                                                              ? listAttenOfStudent[0].location
                                                                              : '',
                                                                          style:
                                                                              TextStyle(color: Colors.lightBlue),
                                                                          softWrap:
                                                                              true,
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.clip,
                                                                        )),
                                                                  ),
                                                                  Icon(
                                                                    isCheck
                                                                        ? Icons
                                                                            .check
                                                                        : Icons
                                                                            .close,
                                                                    size: 17,
                                                                    color: isCheck
                                                                        ? Colors
                                                                            .lightGreen
                                                                        : ColorApp
                                                                            .red,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    'Trang thái : ',
                                                                  ),
                                                                  Expanded(
                                                                      child:
                                                                          Text(
                                                                    listAttenOfStudent[0].status !=
                                                                            null
                                                                        ? listAttenOfStudent[0]
                                                                            .status
                                                                        : 'Thất bại',
                                                                    style: TextStyle(
                                                                        color: listAttenOfStudent[0].status ==
                                                                                'Thành công'
                                                                            ? Colors.lightGreen
                                                                            : ColorApp.red),
                                                                  )),
                                                                  Icon(
                                                                    listAttenOfStudent[0].status ==
                                                                            'Thành công'
                                                                        ? Icons
                                                                            .check
                                                                        : Icons
                                                                            .close,
                                                                    size: 17,
                                                                    color: listAttenOfStudent[0].status ==
                                                                            'Thành công'
                                                                        ? Colors
                                                                            .lightGreen
                                                                        : ColorApp
                                                                            .red,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ]);
                                                // } else {
                                                //   return Text('Chưa điểm danh');
                                                // }
                                              } else if (state
                                                  is LoadErrorAttend) {
                                                return Center(
                                                    child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  child: Text(
                                                    state.error,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: ColorApp.red),
                                                  ),
                                                ));
                                              } else
                                                return Center(
                                                    child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  child: Text(
                                                    'Bạn vắng mặt',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: ColorApp.red),
                                                  ),
                                                ));
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ]),
                            );
                          }),
                    ),
                  ],
                );
              })),
    ]);
  }
}
