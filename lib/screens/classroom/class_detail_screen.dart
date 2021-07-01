import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utc2_staff/blocs/file_bloc/file_bloc.dart';
import 'package:utc2_staff/blocs/file_bloc/file_event.dart';
import 'package:utc2_staff/blocs/file_bloc/file_state.dart';
import 'package:utc2_staff/blocs/post_bloc/post_bloc.dart';
import 'package:utc2_staff/blocs/teacher_bloc/teacher_bloc.dart';
import 'package:utc2_staff/models/firebase_file.dart';
import 'package:utc2_staff/screens/classroom/image_page.dart';
import 'package:utc2_staff/screens/classroom/report/info_detail_class.dart';
import 'package:utc2_staff/screens/classroom/new_comment.dart';
import 'package:utc2_staff/screens/classroom/new_notify_class.dart';
import 'package:utc2_staff/screens/classroom/report/report_class.dart';
import 'package:utc2_staff/screens/home_screen.dart';
import 'package:utc2_staff/service/firestore/api_getfile.dart';
import 'package:utc2_staff/service/firestore/class_database.dart';
import 'package:utc2_staff/service/firestore/file_database.dart';
import 'package:utc2_staff/service/firestore/post_database.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/utils/custom_glow.dart';
import 'package:utc2_staff/utils/utils.dart';
import 'package:utc2_staff/widgets/class_drawer.dart';
import 'package:flutter/material.dart';
import 'package:utc2_staff/utils/color_random.dart';

class DetailClassScreen extends StatefulWidget {
  final String className, idClass, description;
  final List<Class> listClass;
  DetailClassScreen(
      {this.className, this.listClass, this.idClass, this.description});
  @override
  _DetailClassScreenState createState() => _DetailClassScreenState();
}

class _DetailClassScreenState extends State<DetailClassScreen> {
  final notifications = FlutterLocalNotificationsPlugin();
  PostBloc postBloc;

  PostDatabase postDatabase = new PostDatabase();
  String deleteOrPin;
  Class _class;
  Teacher teacher;
  List<Post> listPost = [];
  FileBloc fileBloc = new FileBloc();
  List<File> listFile = [];
  @override
  void initState() {
    super.initState();

    _class = widget.listClass
        .where((element) => element.id.contains(widget.idClass))
        .toList()
        .first;
    final settingsAndroid = AndroidInitializationSettings('app_icon');

    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(android: settingsAndroid, iOS: settingsIOS),
        onSelectNotification: onSelectNotification);
    postBloc = BlocProvider.of<PostBloc>(context);
    fileBloc = BlocProvider.of<FileBloc>(context);
    postBloc.add(GetPostEvent(widget.idClass));
  }

  Future onSelectNotification(String payload) async =>
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
              IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: ColorApp.black,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer()),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReportClassScreen(
                            teacher: teacher,
                            classUtc: _class,
                            listPost: listPost,
                          )));
            },
            icon: Image.asset(
              'assets/icons/print.png',
              width: 20,
            ),
            label: Text('In báo cáo'),
          ),
          Builder(
            builder: (context) => Container(
              margin: EdgeInsets.only(right: size.width * 0.03),
              width: 40,
              child: IconButton(
                  tooltip: 'Thông tin lớp học',
                  onPressed: () =>
                      _showBottomSheet(context, size, _class, teacher),
                  icon: Icon(
                    Icons.info,
                    color: Colors.grey,
                  )),
            ),
          ),
        ],
      ),
      drawer: ClassDrawer(
        active: widget.listClass,
        change: (id) {
          postBloc.add(GetPostEvent(id));
          setState(() {
            _class = widget.listClass
                .where((element) => element.id.contains(id))
                .toList()
                .first;
          });
        },
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.white,
        padding: EdgeInsets.all(size.width * 0.03),
        child: Column(
          children: [
            Flexible(flex: 3, child: title(size, _class.name.toUpperCase())),
            SizedBox(
              height: 7,
            ),
            Flexible(
                flex: 2,
                child: comment(
                  size,
                )),
            Flexible(
              flex: 15,
              child: BlocConsumer<PostBloc, PostState>(
                listener: (context, state) {
                  if (state is LoadedPost) {
                    setState(() {
                      fileBloc.add(GetFileEvent(widget.idClass, state.list));
                    });
                  }
                },
                builder: (context, state) {
                  return BlocBuilder<PostBloc, PostState>(
                    builder: (context, state) {
                      if (state is LoadedPost) {
                        listPost = state.list;
                        return Container(
                          // padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: ColorApp.blue.withOpacity(0.02),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(
                                      1, 1), // changes position of shadow
                                ),
                              ],
                              gradient: LinearGradient(
                                  stops: [0.2, 0.9],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.white, ColorApp.lightGrey]),
                              // color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: ColorApp.lightGrey, width: 0.3)),
                          margin: EdgeInsets.only(top: 10),
                          child: RefreshIndicator(
                            onRefresh: () async {
                              postBloc.add(GetPostEvent(widget.idClass));
                            },
                            child: Scrollbar(
                              showTrackOnHover: true,
                              radius: Radius.circular(5),
                              thickness: 5,
                              child: ListView.builder(
                                  itemCount: state.list.length,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.03),
                                  itemBuilder: (context, index) {
                                    var e = state.list[index];

                                    return ItemNoti(
                                      teacher: teacher,
                                      function: (value) {
                                        if (value == 'delete') {
                                          postDatabase.deletePost(
                                              widget.idClass, e.id);
                                          postBloc.add(
                                              GetPostEvent(widget.idClass));
                                        }
                                      },
                                      numberFile: index,
                                      numberComment: index,
                                      post: e,
                                      classUtc: _class,
                                    );
                                  }),
                            ),
                          ),
                        );
                      } else if (state is LoadingPost) {
                        return SpinKitThreeBounce(
                          color: ColorApp.lightBlue,
                          size: 30,
                        );
                      } else if (state is LoadErrorPost) {
                        return Center(
                          child: Text(
                            state.error,
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      } else {
                        return SpinKitThreeBounce(
                          color: ColorApp.lightBlue,
                          size: 30,
                        );
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(
      BuildContext context, Size size, Class _class, Teacher teacher) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.2,
              maxChildSize: 0.95,
              builder: (_, controller) {
                return Container(
                    child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20.0),
                      topRight: const Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Center(
                          child: Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: ColorApp.grey,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(3),
                            topRight: const Radius.circular(3),
                          ),
                        ),
                        height: 3,
                        width: 50,
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Center(
                          child: Text(
                            'Thông tin lớp',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 0.5,
                        height: 5,
                      ),
                      Expanded(
                        child: InfoDetailClass(
                          teacher: teacher,
                          classUtc: _class,
                          controller: controller,
                          listStudent: [],
                        ),
                      ),
                    ],
                  ),
                ));
              },
            ),
          ),
        );
      },
    );
  }

  Widget comment(
    Size size,
  ) {
    return Container(
      width: size.width,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: ColorApp.blue.withOpacity(0.05),
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorApp.lightGrey)),
      child: BlocBuilder<TeacherBloc, TeacherState>(builder: (context, state) {
        if (state is TeacherLoaded) {
          teacher = state.teacher;
          return TextButton(
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewNotify(
                                idClass: widget.idClass,
                                teacher: state.teacher,
                                classUtc: _class,
                              )))
                  .then((value) => postBloc.add(GetPostEvent(widget.idClass)));
            },
            child: Row(
              children: [
                CustomAvatarGlow(
                  glowColor: ColorApp.blue,
                  endRadius: 20.0,
                  duration: Duration(milliseconds: 1000),
                  repeat: true,
                  showTwoGlows: true,
                  repeatPauseDuration: Duration(milliseconds: 100),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    child: CircleAvatar(
                      backgroundColor: ColorApp.lightGrey,
                      backgroundImage:
                          CachedNetworkImageProvider(state.teacher.avatar),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Thông báo gì đó cho lớp học của bạn...',
                  style: TextStyle(color: ColorApp.lightBlue),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      }),
    );
  }

  Widget title(Size size, String name) {
    return Container(
      // height: 100,
      width: size.width,
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
          gradient: new LinearGradient(
              colors: ColorRandom
                  .colors[Random().nextInt(ColorRandom.colors.length)],
              stops: [0.0, 1.0],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomRight,
              tileMode: TileMode.repeated),
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        name,
        softWrap: true,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}

class ItemNoti extends StatelessWidget {
  final Teacher teacher;
  final int numberFile;
  final Function function;
  final int numberComment;
  final Post post;
  final Class classUtc;

  ItemNoti(
      {this.teacher,
      this.numberFile,
      this.function,
      this.numberComment,
      this.post,
      this.classUtc});
  bool isLink(String link) {
    return [
      'http://',
      'https://',
    ].any(link.contains);
  }

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.width * 0.03),
      child: Column(
        children: [
          Container(
            width: size.width,
            padding: EdgeInsets.all(size.width * 0.03),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                border: Border.all(color: ColorApp.lightGrey, width: 1)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      child: CircleAvatar(
                        backgroundColor: ColorApp.lightGrey,
                        radius: 15,
                        backgroundImage:
                            CachedNetworkImageProvider(post.avatar),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.name.toUpperCase(),
                          softWrap: true,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: ColorApp.black, fontSize: 17),
                        ),
                        Text(
                          "Đã đăng  " +
                              DateFormat('HH:mm - dd-MM-yyyy').format(
                                  DateFormat("yyyy-MM-dd HH:mm:ss")
                                      .parse(post.date)),
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                    Spacer(),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        function(value);
                      },
                      child: Icon(Icons.more_horiz_rounded),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                            value: 'pin',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.label_important_outline_rounded,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text('Ghim'),
                              ],
                            )),
                        PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_forever_rounded,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text('Gỡ'),
                              ],
                            )),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                isLink(post.title)
                    ? TextButton(
                        onPressed: () {
                          _launchInWebViewWithJavaScript(post.title);
                        },
                        child: Text(post.title))
                    : Text(
                        post.title,
                        softWrap: true,
                        style: TextStyle(color: ColorApp.black, fontSize: 16),
                      ),
                SizedBox(
                  height: post.content != null ? 5 : 0,
                ),
                post.content != null
                    ? isLink(post.content)
                        ? TextButton(
                            onPressed: () {
                              _launchInWebViewWithJavaScript(post.content);
                            },
                            child: Text(post.content))
                        : Text(
                            post.content,
                            softWrap: true,
                            style: TextStyle(
                                color: ColorApp.black.withOpacity(.6),
                                fontSize: 16),
                          )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                post.idAtten != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Mã điểm danh: ',
                              style: TextStyle(
                                  color: ColorApp.black,
                                  fontWeight: FontWeight.normal),
                              children: <TextSpan>[
                                TextSpan(
                                    text: post.idAtten,
                                    style: TextStyle(
                                      color: ColorApp.red,
                                    )),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Hạn: ',
                              style: TextStyle(
                                  color: ColorApp.black,
                                  fontWeight: FontWeight.normal),
                              children: <TextSpan>[
                                TextSpan(
                                    text: DateFormat('HH:mm').format(
                                        DateFormat("yyyy-MM-dd HH:mm:ss")
                                            .parse(post.timeAtten)),
                                    style: TextStyle(
                                      color: ColorApp.red,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                post.idQuiz != null
                    ? Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Mã làm bài: ',
                                style: TextStyle(
                                    color: ColorApp.black,
                                    fontWeight: FontWeight.normal),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: post.idQuiz,
                                      style: TextStyle(
                                        color: ColorApp.red,
                                      )),
                                ],
                              ),
                            ),
                            Text(post.quizContent),
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                BlocBuilder<FileBloc, FileState>(
                  builder: (context, state) {
                    if (state is LoadedFile) {
                      var numberFile = state.list
                          .where((element) => element.idPost == post.id)
                          .toList()
                          .length;
                      List<File> list = state.list
                          .where((element) => element.idPost == post.id)
                          .toList();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.attachment,
                                color: Colors.grey,
                                size: 15,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                numberFile.toString() + ' Tệp đính kèm',
                                softWrap: true,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                          numberFile > 0
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                      numberFile,
                                      (index) => TextButton(
                                          onPressed: () async {
                                            if (isImage(list[index].nameFile))
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) => ImagePage(
                                                    file: FirebaseFile(
                                                        ref: null,
                                                        name: list[index]
                                                            .nameFile,
                                                        url: list[index].url)),
                                              ));
                                            else
                                              FirebaseApiGetFile.downloadFile(
                                                  list[index].url,
                                                  list[index].nameFile,
                                                  context);
                                          },
                                          child: Row(
                                            children: [
                                              Text(list[index].nameFile),
                                              Spacer(),
                                              isImage(list[index].nameFile)
                                                  ? CircleAvatar(
                                                      backgroundColor:
                                                          ColorApp.lightGrey,
                                                      radius: 20,
                                                      backgroundImage:
                                                          CachedNetworkImageProvider(
                                                              list[index].url),
                                                    )
                                                  : Container(),
                                            ],
                                          ))))
                              : Container()
                        ],
                      );
                    } else
                      return Container();
                  },
                ),
              ],
            ),
          ),
          Container(
              width: size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ColorApp.lightGrey.withOpacity(0.1),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  border: Border.all(color: ColorApp.lightGrey, width: 1)),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewCommentClass(
                                teacher: teacher,
                                idClass: post.idClass,
                                idPost: post.id,
                                classUtc: classUtc,
                                post: post,
                              )));
                },
                child: Text(
                  numberComment != null
                      ? numberComment.toString() + ' nhận xét của lớp học'
                      : 'Thêm nhận xét của lớp học',
                  style: TextStyle(color: Colors.grey),
                ),
              ))
        ],
      ),
    );
  }
}
