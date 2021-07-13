import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:utc2_staff/blocs/class_bloc/class_bloc.dart';
import 'package:utc2_staff/screens/classroom/class_detail_screen.dart';
import 'package:utc2_staff/screens/classroom/new_class.dart';
import 'package:utc2_staff/service/firestore/class_database.dart';
import 'package:utc2_staff/service/firestore/post_database.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/utils/color_random.dart';
import 'package:utc2_staff/utils/utils.dart';
import 'package:flutter/material.dart';

class ActivityPage extends StatefulWidget {
  final Teacher teacher;

  const ActivityPage({Key key, this.teacher}) : super(key: key);
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  ClassDatabase classDatabase = ClassDatabase();
  List<Post> post = [];

  showAlertDialog(BuildContext context, String name, String id) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Thoát"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Kết thúc"),
      onPressed: () async {
        Navigator.pop(context);
        await FirebaseMessaging.instance.unsubscribeFromTopic(id);
        classDatabase.deleteClass(id);
        classBloc.add(GetClassEvent(teacherID: widget.teacher.id));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(name),
      content: Text("Bạn có muốn kết thúc lớp học này ?"),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  var classBloc;
  @override
  void initState() {
    super.initState();

    classBloc = BlocProvider.of<ClassBloc>(context);
    classBloc.add(GetClassEvent(teacherID: widget.teacher.id));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        BlocBuilder<ClassBloc, ClassState>(
          builder: (context, state) {
            if (state is LoadingClass)
              return SpinKitThreeBounce(
                color: ColorApp.lightBlue,
                size: 30,
              );
            else if (state is LoadedClass) {
              return Container(
                child: RefreshIndicator(
                  displacement: 20,
                  onRefresh: () async {
                    classBloc.add(GetClassEvent(teacherID: widget.teacher.id));
                  },
                  child: Scrollbar(
                    showTrackOnHover: true,
                    radius: Radius.circular(5),
                    thickness: 5,
                    child: ListView.builder(
                      itemCount: state.list.length + 1,
                      physics: BouncingScrollPhysics(),
                      // itemCount: snapshot.data.length,
                      itemBuilder: ((context, index) {
                        return index == state.list.length
                            ? Container(
                                height: state.list.length <= 2 ? 500 : 200,
                              )
                            : customList(
                                size,
                                context,
                                state.list[index].name,
                                widget.teacher.name,
                                post,
                                state.list[index].id,
                                state.list,
                                state.list[index].note,
                              );
                      }),
                    ),
                  ),
                ),
              );
            } else if (state is LoadErrorClass) {
              return Center(
                child: Text(
                  state.error,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              );
            } else {
              return Container(
                child: Center(
                    child: SpinKitThreeBounce(
                  color: Colors.lightBlue,
                  size: 30,
                )),
              );
            }
          },
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            splashColor: ColorApp.blue.withOpacity(.4),
            hoverColor: ColorApp.lightGrey,
            foregroundColor: ColorApp.blue,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewClass(
                            teacher: widget.teacher,
                          ))).then((value) =>
                  classBloc.add(GetClassEvent(teacherID: widget.teacher.id)));
            },
            child: Icon(Icons.add),
          ),
        )
      ],
    );
  }

  Widget customList(
      Size size,
      BuildContext context,
      String className,
      String teacherName,
      List<Post> list,
      String id,
      List<Class> listClass,
      String description) {
    return Container(
      margin: EdgeInsets.all(size.width * 0.03),
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          border: Border.all(color: ColorApp.lightGrey, width: 1.5)),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              FirebaseMessaging.instance.subscribeToTopic(id);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailClassScreen(
                            className: className,
                            listClass: listClass,
                            idClass: id,
                            description: description,
                          )));
            },
            child: Container(
              height: 150,
              width: size.width,
              padding: EdgeInsets.all(size.width * 0.03),
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                    colors: ColorRandom
                        .colors[Random().nextInt(ColorRandom.colors.length)],
                    stops: [0.0, 1.0],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomRight,
                    tileMode: TileMode.repeated),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          className.toUpperCase(),
                          softWrap: true,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            showAlertDialog(
                                context, className.toUpperCase(), id);
                          },
                          icon: Icon(
                            Icons.more_horiz_rounded,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  Text(
                    teacherName,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          list.isNotEmpty
              ? Container(
                  width: size.width,
                  padding: EdgeInsets.all(size.width * 0.03),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      border: Border.all(color: ColorApp.lightGrey, width: 1)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(list.length, (index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(list[index].title.toString()),
                          index == list.length - 1
                              ? Container()
                              : Divider(
                                  color: ColorApp.black,
                                )
                        ],
                      );
                    }),
                  ))
              : Container(),
        ],
      ),
    );
  }
}
