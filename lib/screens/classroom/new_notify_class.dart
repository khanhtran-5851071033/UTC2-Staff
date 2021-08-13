import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/base.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:utc2_staff/blocs/quiz_bloc/quiz_bloc.dart';
import 'package:utc2_staff/blocs/quiz_bloc/quiz_event.dart';
import 'package:utc2_staff/blocs/quiz_bloc/quiz_state.dart';
import 'package:utc2_staff/models/firebase_file.dart';
import 'package:utc2_staff/screens/classroom/image_page.dart';
import 'package:utc2_staff/screens/classroom/new_file.dart';
import 'package:utc2_staff/screens/classroom/new_quiz.dart';
import 'package:utc2_staff/screens/classroom/quiz_screen.dart';
import 'package:utc2_staff/service/firestore/class_database.dart';
import 'package:utc2_staff/service/firestore/post_database.dart';
import 'package:utc2_staff/service/firestore/quiz_database.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/service/geo_service.dart';
import 'package:utc2_staff/service/push_noti_firebase.dart';
import 'package:utc2_staff/utils/utils.dart';

class NewNotify extends StatefulWidget {
  final Teacher teacher;
  final Class classUtc;

  const NewNotify({Key key, this.teacher, this.classUtc}) : super(key: key);
  @override
  _NewNotifyState createState() => _NewNotifyState();
}

class _NewNotifyState extends State<NewNotify> {
  bool expandedAtten = false, isQuiz = false;
  String idAtent = '';
  int _selectedTime = 10;
  PostDatabase postDatabase = PostDatabase();
  String title, content;
  Quiz quizAdd;

  String genId() {
    return DateFormat('HHmmss')
        .format(DateTime.now().add(Duration(minutes: _selectedTime)));
  }

  GlobalKey globalKey = new GlobalKey();
  TextEditingController _controller = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  QuizBloc quizBloc = new QuizBloc();
  List<FirebaseFile> listFile = [];
  GeoService geoService = GeoService();
  var location;
  Geocoding geocoding = Geocoder.local;
  var results;

  @override
  void initState() {
    quizBloc = BlocProvider.of<QuizBloc>(context);
    quizBloc.add(GetQuizEvent(widget.teacher.id));

    initLocation();
    super.initState();
  }

  void initLocation() async {
    //Lay lat long
    location = await getLocation(geoService);
    results = await geocoding.findAddressesFromCoordinates(
        new Coordinates(location.latitude, location.longitude));
  }

  void submitPost() async {
    if (_formKey.currentState.validate()) {
      ///Push noti
      ///
      var response = await PushNotiFireBaseAPI.pushNotiTopic(
          _controller.text.trim(),
          content,
          {
            'idNoti': 'newNoti',
            "isAtten": expandedAtten,
            "msg": idAtent,
            "content": "Đã đăng trong lớp : " +
                widget.classUtc.name +
                "\n" +
                _controller.text.trim(),
            "avatar": widget.teacher.avatar,
            "name": widget.teacher.name,
            "idChannel": widget.classUtc.id,
            "className": widget.classUtc.name,
            "classDescription": widget.classUtc.note,
            "timeAtten": DateFormat('HH:mm').format(
                DateFormat("yyyy-MM-dd HH:mm:ss").parse(DateTime.now()
                    .add(Duration(minutes: _selectedTime))
                    .toString())),
            "idQuiz": quizAdd?.idQuiz,
          },
          widget.classUtc.id);
      if (response.statusCode == 200) {
        print('success');
        Navigator.pop(context);
      } else
        print('fail');

      //gen idPost
      var idPost = generateRandomString(5);

      //create post on firebase
      Map<String, String> dataPost = {
        'id': idPost,
        'idClass': widget.classUtc.id,
        'title': _controller.text.trim(),
        'content': content,
        'name': widget.teacher.name,
        'avatar': widget.teacher.avatar,
        'date': DateTime.now().toString(),
        'idAtten': expandedAtten
            ? idAtent != null
                ? idAtent
                : null
            : null,
        'timeAtten': expandedAtten
            ? DateTime.now().add(Duration(minutes: _selectedTime)).toString()
            : null,
        "idQuiz": isQuiz && quizAdd != null ? quizAdd.idQuiz : null,
        "quizContent": isQuiz && quizAdd != null
            ? quizAdd.titleQuiz +
                ' - ' +
                quizAdd.timePlay +
                ' phút - ' +
                quizAdd.totalQuestion +
                ' câu'
            : null,
        'location': (location?.latitude.toString() ?? '') +
            ',' +
            (location?.longitude.toString() ?? ''),
        'address': results[0].addressLine.toString(),
      };
      await postDatabase.createPost(dataPost, widget.classUtc.id, idPost);
      if (listFile.isNotEmpty) {
        for (var file in listFile) {
          postDatabase.createFileInPost(
              dataPost, widget.classUtc.id, idPost, file);
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          'Thông báo mới',
          style: TextStyle(color: ColorApp.black),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              submitPost();
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
                        height: 40,
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _controller,
                            style: TextStyle(
                                fontSize: 20, color: ColorApp.mediumBlue),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Vui lòng nhập tiêu đề';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                isCollapsed: true,
                                hintText: 'Tiêu đề',
                                hintStyle: TextStyle(
                                    fontSize: 16, color: ColorApp.black)),
                          ),
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
                        IconButton(
                            onPressed: () {
                              setState(() {
                                Get.to(NewFile(idClass: widget.classUtc.id))
                                    .then((value) {
                                  if (value != null) {
                                    for (var item in value) {
                                      setState(() {
                                        listFile.add(item);
                                      });
                                    }
                                    // setState(() {
                                    //   listFile.addAll(value);
                                    // });
                                  }
                                });
                              });
                            },
                            icon: Icon(
                              Icons.add_circle_rounded,
                              color: ColorApp.mediumBlue,
                            ))
                      ],
                    ),
                    AnimatedCrossFade(
                      firstChild: Column(
                        children: List.generate(
                            listFile.length,
                            (index) => TextButton(
                                  onPressed: () async {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          ImagePage(file: listFile[index]),
                                    ));
                                  },
                                  child: Container(
                                    height: 40,
                                    margin: EdgeInsets.symmetric(vertical: 2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                            stops: [0.08, 1],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Colors.white,
                                              ColorApp.lightGrey
                                            ])),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          isImage(listFile[index].name)
                                              ? CircleAvatar(
                                                  backgroundColor:
                                                      ColorApp.lightGrey,
                                                  radius: 15,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                          listFile[index].url),
                                                )
                                              : Container(),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              // height: 25,
                                              child: Text(
                                                listFile[index].name,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                FirebaseStorage.instance
                                                    .ref()
                                                    .child(
                                                        '${widget.classUtc.id}/${listFile[index].name}')
                                                    .delete();
                                                setState(() {
                                                  listFile.removeAt(index);
                                                });
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                size: 20,
                                                color:
                                                    Colors.red.withOpacity(.8),
                                              )),
                                        ]),
                                  ),
                                )),
                      ),
                      secondChild: Container(),
                      crossFadeState: listFile.isNotEmpty
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: Duration(milliseconds: 300),
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
                                expandedAtten
                                    ? expandedAtten = false
                                    : expandedAtten = true;
                                if (expandedAtten) idAtent = genId();
                              });
                            },
                            icon: Icon(
                              expandedAtten
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
                                          idAtent = genId();
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
                      crossFadeState: expandedAtten
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
                              setState(() {
                                isQuiz ? isQuiz = false : isQuiz = true;
                              });
                            },
                            icon: Icon(
                              isQuiz
                                  ? Icons.remove_circle
                                  : Icons.add_circle_rounded,
                              color: ColorApp.mediumBlue,
                            ))
                      ],
                    ),
                    AnimatedCrossFade(
                      firstChild: Container(
                        height: size.height / 2.5,
                        child: ListQuiz(
                          idTeacher: widget.teacher,
                          classUtc: widget.classUtc,
                          setQuiz: (quiz) {
                            setState(() {
                              quizAdd = quiz;
                            });
                          },
                        ),
                      ),
                      secondChild: Container(),
                      crossFadeState: isQuiz
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: Duration(milliseconds: 300),
                    )
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

class ListQuiz extends StatefulWidget {
  final Teacher idTeacher;
  final Class classUtc;
  final Function(Quiz quiz) setQuiz;
  ListQuiz({this.idTeacher, this.setQuiz, this.classUtc});

  @override
  _ListQuizState createState() => _ListQuizState();
}

class _ListQuizState extends State<ListQuiz> {
  List quizSelect = [];

  QuizBloc quizBloc = new QuizBloc();
  @override
  void initState() {
    quizBloc = BlocProvider.of<QuizBloc>(context);
    quizBloc.add(GetQuizEvent(widget.idTeacher.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: size.width,
          child: TextButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewQuiz(
                            idTeacher: widget.idTeacher.id,
                          ))).then(
                  (value) => quizBloc.add(GetQuizEvent(widget.idTeacher.id)));
            },
            label: Text(
              'Tạo mới',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            icon: Icon(
              Icons.add_circle_outline,
              size: 14,
            ),
            style: ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.padded,
                shadowColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.blue)))),
          ),
        ),
        BlocConsumer<QuizBloc, QuizState>(
          listener: (context, state) {
            if (state is LoadedQuiz) {
              for (int i = 0; i < state.list.length; i++) {
                if (quizSelect.length < state.list.length)
                  quizSelect.add(false);
              }
            } else {}
          },
          builder: (context, state) {
            if (state is LoadingQuiz)
              return SpinKitThreeBounce(
                color: ColorApp.lightBlue,
              );
            else if (state is LoadedQuiz) {
              return quizSelect.isNotEmpty
                  ? Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          quizBloc.add(GetQuizEvent(widget.idTeacher.id));
                        },
                        child: ListView.builder(
                            itemCount: state.list.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                        stops: [0.08, 1],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white,
                                          ColorApp.lightGrey
                                        ])),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: quizSelect[index],
                                      activeColor: ColorApp.mediumBlue,
                                      checkColor: Colors.white,
                                      shape: CircleBorder(),
                                      onChanged: (value) {
                                        if (value) {
                                          for (int i = 0;
                                              i < quizSelect.length;
                                              i++) {
                                            if (i == index) {
                                              setState(() {
                                                quizSelect[i] = value;
                                                widget.setQuiz(state.list[i]);
                                              });
                                            } else {
                                              setState(() {
                                                quizSelect[i] = !value;
                                              });
                                            }
                                          }
                                        } else {
                                          setState(() {
                                            quizSelect[index] = value;
                                            widget.setQuiz(null);
                                          });
                                        }
                                        print(quizSelect);
                                      },
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          // height: 25,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(state.list[index].titleQuiz),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(state.list[index]
                                                          .totalQuestion +
                                                      ' câu'),
                                                  Text(state.list[index]
                                                          .timePlay +
                                                      ' min'),
                                                ],
                                              ),
                                            ],
                                          )),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      QuizSreen(
                                                        quiz: state.list[index],
                                                        teacher:
                                                            widget.idTeacher,
                                                        classUtc:
                                                            widget.classUtc,
                                                      )));
                                        },
                                        icon: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: ColorApp.mediumBlue,
                                          size: 13,
                                        ))
                                  ],
                                ),
                              );
                            }),
                      ),
                    )
                  : Container();
            } else if (state is LoadErrorQuiz) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    state.error,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              );
            } else {
              return SpinKitThreeBounce(
                color: ColorApp.lightBlue,
              );
            }
          },
        ),
      ],
    );
  }
}
