import 'package:UTC2_Staff/utils/utils.dart';
import 'package:UTC2_Staff/widgets/drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Text('Khánh Trần'),
        actions: [
          CircleAvatar(
            backgroundColor: ColorApp.blue,
            child: Image.asset(''),
          )
        ],
      ),
      drawer: CustomDrawer(),
      body: Container(
        width: size.width,
      ),
    );
  }
}
