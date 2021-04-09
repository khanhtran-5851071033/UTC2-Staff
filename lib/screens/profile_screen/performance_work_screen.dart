import 'package:UTC2_Staff/utils/utils.dart';
import 'package:flutter/material.dart';

class TaskPerformanceScreen extends StatefulWidget {
  @override
  _TaskPerformanceScreenState createState() => _TaskPerformanceScreenState();
}

class _TaskPerformanceScreenState extends State<TaskPerformanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: ColorApp.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Khối lượng công việc',
          style: TextStyle(color: ColorApp.black),
        ),
      ),
    );
  }
}
