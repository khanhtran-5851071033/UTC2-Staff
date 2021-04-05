import 'package:UTC2_Staff/screens/home_screen.dart';
import 'package:UTC2_Staff/utils/utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Nunito', primaryColor: ColorApp.blue),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
