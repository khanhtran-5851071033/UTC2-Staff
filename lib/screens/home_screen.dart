import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utc2_staff/blocs/teacher_bloc/teacher_bloc.dart';
import 'package:utc2_staff/screens/activity_page.dart';
import 'package:utc2_staff/screens/notify_page.dart';
import 'package:utc2_staff/screens/schedule_page.dart';
import 'package:utc2_staff/screens/web_view.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/utils/custom_glow.dart';
import 'package:utc2_staff/screens/home_page.dart';
import 'package:utc2_staff/screens/profile_page.dart';
import 'package:utc2_staff/utils/utils.dart';
import 'package:utc2_staff/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  AppBar appBar = AppBar(title: Text(''));
  TeacherBloc teacherBloc;
  @override
  void initState() {
    super.initState();

    teacherBloc = BlocProvider.of<TeacherBloc>(context);
    teacherBloc.add(GetTeacher());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget utc2 = HomePage();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _selectedIndex == 0 || _selectedIndex == 3
            ? PreferredSize(
                preferredSize: Size(size.width, appBar.preferredSize.height),
                child: BlocBuilder<TeacherBloc, TeacherState>(
                    builder: (context, state) {
                  if (state is TeacherLoaded)
                    return mainAppBar(size, state.teacher);
                  else
                    return loadingAppBar(size);
                }))
            : null,
        drawer: CustomDrawer(linkWeb: (link) {
          setState(() {
            utc2 = Container(
              height: size.height,
              width: size.width,
              color: Colors.white,
            );
          });
          Future.delayed(Duration(milliseconds: 300), () {
            setState(() {
              utc2 = new WebUTC2(link: link);
            });
          });
        }),
        endDrawer: BlocBuilder<TeacherBloc, TeacherState>(builder: (context, state) {
          if (state is TeacherLoaded)
            return Drawer(
                child: ProFilePage(
              teacher: state.teacher,
            ));
          else
            return Container();
        }),
        body: SizedBox.expand(
          child: IndexedStack(
            index: _selectedIndex,
            children: <Widget>[
              utc2,
              NotifyPage(),
              SchedulePage(),
              ActivityPage(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _selectedIndex,
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            _selectedIndex = index;
            utc2 = Container();
            utc2 = HomePage();

            // duration: Duration(milliseconds: 300), curve: Curves.ease);
          }),
          items: [
            BottomNavyBarItem(
                icon: Icon(Icons.home_rounded),
                title: Text('Trang chủ'),
                activeColor: Colors.blue,
                inactiveColor: ColorApp.black),
            BottomNavyBarItem(
                icon: Icon(
                  Icons.notifications,
                ),
                title: Text('Thông báo'),
                activeColor: Colors.blue,
                inactiveColor: ColorApp.black),
            BottomNavyBarItem(
                icon: Icon(Icons.date_range),
                title: Text('Lịch trình'),
                activeColor: Colors.blue,
                inactiveColor: ColorApp.black),
            BottomNavyBarItem(
                icon: Icon(Icons.stacked_line_chart_rounded),
                title: Text('Hoạt động'),
                activeColor: Colors.blue,
                inactiveColor: ColorApp.black),
          ],
        ));
  }

  Widget mainAppBar(Size size, Teacher teacher) {
    return AppBar(
      centerTitle: true,
      elevation: 10,
      backgroundColor: Colors.white,
      title: Text(
        teacher.name,
        style: TextStyle(color: ColorApp.black),
      ),
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
        Builder(
          builder: (context) => Container(
            margin: EdgeInsets.only(right: size.width * 0.03),
            width: 40,
            child: GestureDetector(
              onTap: () {
                Scaffold.of(context).openEndDrawer();
              },
              child: CustomAvatarGlow(
                glowColor: ColorApp.lightBlue,
                endRadius: 20.0,
                duration: Duration(milliseconds: 1000),
                repeat: true,
                showTwoGlows: true,
                repeatPauseDuration: Duration(milliseconds: 100),
                child: Container(
                  padding: EdgeInsets.all(4),
                  child: CircleAvatar(
                    backgroundColor: ColorApp.lightGrey,
                    backgroundImage: NetworkImage(teacher.avatar),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget loadingAppBar(Size size) {
    return AppBar(
        centerTitle: true,
        elevation: 10,
        backgroundColor: Colors.white,
        title: Text(
          '',
          style: TextStyle(color: ColorApp.black),
        ),
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
          Container(),
        ]);
  }
}
