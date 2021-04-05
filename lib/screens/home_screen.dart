import 'dart:ui';

import 'package:UTC2_Staff/utils/utils.dart';
import 'package:UTC2_Staff/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.white,
          title: Text(
            'Khánh Trần',
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
            Container(
              margin: EdgeInsets.only(right: size.width * 0.03),
              width: 40,
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(
                    "https://scontent.fsgn2-5.fna.fbcdn.net/v/t1.6435-9/132520813_846603219451783_6386312700226999104_n.jpg?_nc_cat=106&ccb=1-3&_nc_sid=09cbfe&_nc_ohc=o4rFjC9w9mAAX8uytLC&_nc_ht=scontent.fsgn2-5.fna&oh=4c8653b5d4079ba4db437c5a09f2f239&oe=6091F89D"),
              ),
            )
          ],
        ),
        drawer: CustomDrawer(),
        body: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _selectedIndex = index);
            },
            children: <Widget>[
              Container(
                color: Colors.white,
              ),
              Container(
                color: Colors.white,
              ),
              Container(
                color: Colors.white,
              ),
              Container(
                color: Colors.white,
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _selectedIndex,
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.home),
              title: Text('Trang chủ'),
              activeColor: ColorApp.blue,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.date_range),
              title: Text('Lịch trình'),
              activeColor: ColorApp.blue,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.stacked_line_chart_rounded),
              title: Text('Hoạt động'),
              activeColor: ColorApp.blue,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.settings),
              title: Text('Cài đặt'),
              activeColor: ColorApp.blue,
            ),
          ],
        ));
  }
}
