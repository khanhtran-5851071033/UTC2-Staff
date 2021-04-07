import 'package:UTC2_Staff/screens/home_screen.dart';
import 'package:UTC2_Staff/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'Nunito',
          primaryColor: ColorApp.blue,
          appBarTheme: Theme.of(context)
              .appBarTheme
              .copyWith(brightness: Brightness.light)),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
