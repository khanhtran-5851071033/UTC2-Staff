import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utc2_staff/blocs/atttend_student_bloc/attend_bloc.dart';
import 'package:utc2_staff/blocs/class_bloc/class_bloc.dart';
import 'package:utc2_staff/blocs/comment_bloc/comment_bloc.dart';
import 'package:utc2_staff/blocs/login_bloc/login_bloc.dart';
import 'package:utc2_staff/blocs/post_bloc/post_bloc.dart';
import 'package:utc2_staff/blocs/question_bloc/question_bloc.dart';
import 'package:utc2_staff/blocs/quiz_bloc/quiz_bloc.dart';
import 'package:utc2_staff/blocs/student_bloc/student_bloc.dart';
import 'package:utc2_staff/screens/home_screen.dart';
import 'package:utc2_staff/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utc2_staff/service/firestore/notify_app_database.dart';
import 'package:utc2_staff/service/local_notification.dart';
import 'package:utc2_staff/utils/utils.dart';
import 'blocs/teacher_bloc/teacher_bloc.dart';
import 'service/firestore/teacher_database.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return HomePage();
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseMessaging _fireBaseMessaging;
  final notifications = FlutterLocalNotificationsPlugin();
  Widget body = Scaffold();
  NotifyAppDatabase notifyAppDatabase = new NotifyAppDatabase();
  @override
  void initState() {
    super.initState();
    final settingsAndroid = AndroidInitializationSettings('app_icon');

    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(android: settingsAndroid, iOS: settingsIOS),
        onSelectNotification: onSelectNotification);
    if (Platform.isIOS) {
      _fireBaseMessaging.requestPermission(
          alert: true, badge: true, sound: true, provisional: true);
    }
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print('MESSAGE>>>>' + message.toString());
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String email = preferences.getString('userEmail');
      var teacher = await TeacherDatabase.getTeacherData(email);
      String id = generateRandomString(5);
      Map<String, String> dataNotifyApp = {
        'id': id ?? '',
        'idUser': teacher.id ?? '', //user đăng nhập
        'content': message.data['content'] ?? '',
        'name': message.data['name'] ?? '', //người đăng
        'avatar': message.data['avatar'] ?? '', //người đăng
        'date': DateTime.now().toString(), //time nhận được
      };
      notifyAppDatabase.createNotifyApp(dataNotifyApp, teacher.id, id);

      createLocalNotify(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Get.to(HomeScreen());
    });
    FirebaseMessaging.instance.subscribeToTopic('fcm_test');
    getTokenFCM();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ClassBloc>(create: (context) => ClassBloc()),
        BlocProvider<PostBloc>(create: (context) => PostBloc()),
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
        BlocProvider<TeacherBloc>(create: (context) => TeacherBloc()),
        BlocProvider<StudentBloc>(create: (context) => StudentBloc()),
        BlocProvider<AttendStudentBloc>(create: (context) => AttendStudentBloc()),
        BlocProvider<CommentBloc>(create: (context) => CommentBloc()),
        BlocProvider<QuizBloc>(create: (context) => QuizBloc()),
        BlocProvider<QuestionBloc>(create: (context) => QuestionBloc()),
      ],
      child: GetMaterialApp(
        theme: ThemeData(
            fontFamily: 'Nunito',
            primaryColor: Colors.orange,
            appBarTheme: Theme.of(context)
                .appBarTheme
                .copyWith(brightness: Brightness.light)),
        debugShowCheckedModeBanner: false,
        home: body,
      ),
    );
  }

  void createLocalNotify(RemoteMessage message) {
    if (message.data['idNoti'] == 'newNoti' &&
        message.data['isAtten'] == 'false') {
      ////  print('Thông báo new Notity--------------------------------------');
      MyLocalNotification.showNotification(
        notifications,
        message.data['idChannel'],
        message.data['className'],
        message.data['classDescription'],
        message.notification.title,
        message.notification.body,
      );
    } else if (message.data['idNoti'] == 'newNoti' &&
        message.data['isAtten'] == 'true') {
      MyLocalNotification.showNotificationAttenden(
        notifications,
        message.data['msg'],
        message.data['idChannel'],
        message.data['className'],
        message.data['classDescription'],
        message.notification.title,
        message.notification.body,
        message.data['timeAtten'],
      );
    } else {
      // print('Thông báo NEW CLASS-------------------------------------');
      MyLocalNotification.showNotificationNewClass(
        notifications,
        message.data['nameTeacher'],
        message.data['msg'], //id lớp học
        message.data['idChannel'], //id lớp học
        message.data['className'], //ten lop
        message.data['classDescription'], //mieu ta
        //day moi show len
        message.notification.title, //ten lop
        message.notification.body, //mieu ta
      );
    }
  }

  getTokenFCM() async {
    try {
      FirebaseMessaging.instance.getToken().then((token) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.getString('userEmail') != null) {
          setState(() {
            body = HomeScreen();
          });
          var student = await TeacherDatabase.getTeacherData(
              prefs.getString('userEmail'));

          Map<String, String> data = {
            'token': token,
          };
          TeacherDatabase.updateTeacherData(student.id, data);
        } else
          setState(() {
            body = LoginScreen();
          });
      });
    } catch (e) {
      print('get token exception : ' + e.toString());
    }
  }

  Future onSelectNotification(String payload) async {
    print(payload);
    // Get.to(DetailClassScreen());
  }
}
