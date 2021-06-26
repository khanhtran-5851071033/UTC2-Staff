import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:utc2_staff/blocs/comment_bloc/comment_bloc.dart';
import 'package:utc2_staff/blocs/comment_bloc/comment_event.dart';
import 'package:utc2_staff/blocs/comment_bloc/comment_state.dart';
import 'package:utc2_staff/service/firestore/class_database.dart';
import 'package:utc2_staff/service/firestore/comment_database.dart';
import 'package:utc2_staff/service/firestore/post_database.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/service/push_noti_firebase.dart';
import 'package:utc2_staff/utils/utils.dart';

class NewCommentClass extends StatefulWidget {
  final Teacher teacher;
  final String idClass;
  final String idPost;
  final Post post;
  final Class classUtc;
  NewCommentClass(
      {this.teacher, this.idClass, this.idPost, this.post, this.classUtc});
  @override
  _NewCommentClassState createState() => _NewCommentClassState();
}

class _NewCommentClassState extends State<NewCommentClass> {
  CommentBloc commentBloc = new CommentBloc();
  String formatTime(String time) {
    DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(time);
    return DateFormat.yMMMEd('vi').format(parseDate);
  }

  CommentDatabase commentDatabase = new CommentDatabase();
  bool error = false;
  String content;
  @override
  void initState() {
    commentBloc = BlocProvider.of<CommentBloc>(context);
    commentBloc.add(GetCommentEvent(widget.idClass, widget.idPost));
    print(widget.idClass + widget.idPost);
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
            'Nhận xét của lớp học',
            style: TextStyle(color: ColorApp.black),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  commentBloc
                      .add(GetCommentEvent(widget.idClass, widget.idPost));
                },
                icon: Icon(
                  Icons.refresh_rounded,
                  color: Colors.lightBlue,
                ))
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: ColorApp.blue.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(3, -3), // changes position of shadow
              ),
            ],
          ),
          child: TextField(
            onChanged: (val) {
              if (val.isEmpty) {
                setState(() {
                  error = true;
                  content = val;
                });
              } else
                setState(() {
                  error = false;
                  content = val;
                });
            },
            style: TextStyle(fontSize: 16, color: ColorApp.mediumBlue),
            decoration: InputDecoration(
                errorText: error ? 'Vui lòng thêm nhận xét' : null,
                suffixIcon: IconButton(
                  onPressed: () async {
                    if (content != null) {
                      var response = await PushNotiFireBaseAPI.pushNotiTopic(
                          widget.teacher.name +
                              " đã nhận xét bài viết của \n" +
                              widget.post.name,
                          content,
                          {
                            'idNoti': 'newNoti',
                            "isAtten": 'false',
                            "msg": widget.idPost,
                            "content": widget.classUtc.name +
                                "\nĐã nhận xét bài viết của " +
                                widget.post.name +
                                "\n" +
                                content,
                            "avatar": widget.teacher.avatar,
                            "name": widget.teacher.name,
                            "idChannel": widget.idClass,
                            "className": widget.classUtc.name,
                            "classDescription": widget.classUtc.note,
                          },
                          widget.idClass);
                      if (response.statusCode == 200) {
                        print('success');
                        Navigator.pop(context);
                      } else
                        print('fail');
                      var idComment = generateRandomString(5);
                      Map<String, String> dataComment = {
                        'id': idComment,
                        'idClass': widget.idClass,
                        'idPost': widget.idPost,
                        'content': content,
                        'name': widget.teacher.name,
                        'avatar': widget.teacher.avatar,
                        'date': DateTime.now().toString(),
                      };
                      commentDatabase.createComment(dataComment, widget.idClass,
                          widget.idPost, idComment);

                      commentBloc
                          .add(GetCommentEvent(widget.idClass, widget.idPost));
                      setState(() {
                        error = false;
                      });
                    } else {
                      setState(() {
                        error = true;
                      });
                    }
                  },
                  icon: Icon(Icons.send),
                ),
                hintText: 'Thêm nhận xét của lớp học',
                contentPadding: EdgeInsets.all(size.width * 0.03)),
          ),
        ),
        body: Container(
          height: size.height,
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
          child: RefreshIndicator(
            displacement: 60,
            onRefresh: () async {
              commentBloc.add(GetCommentEvent(widget.idClass, widget.idPost));
            },
            child: BlocBuilder<CommentBloc, CommentState>(
                builder: (context, state) {
              if (state is LoadingComment)
                return Container(
                  child: Center(
                      child: SpinKitThreeBounce(
                    color: Colors.lightBlue,
                    size: size.width * 0.06,
                  )),
                );
              else if (state is LoadedComment) {
                return Scrollbar(
                  showTrackOnHover: true,
                  radius: Radius.circular(5),
                  thickness: 5,
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: state.list.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 7),
                          width: size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.white, ColorApp.lightGrey])),
                          child: TextButton(
                            onPressed: () {},
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      child: CircleAvatar(
                                        backgroundColor: ColorApp.lightGrey,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                state.list[index].avatar),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                state.list[index].name,
                                                style: TextStyle(
                                                    color: ColorApp.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                formatTime(
                                                    state.list[index].date),
                                                style: TextStyle(
                                                    color: ColorApp.black
                                                        .withOpacity(.4)),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            state.list[index].content ?? 'null',
                                            softWrap: true,
                                            maxLines: 10,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                color: ColorApp.black,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                );
              } else if (state is LoadErrorComment) {
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
                    size: size.width * 0.06,
                  )),
                );
              }
            }),
          ),
        ));
  }
}
