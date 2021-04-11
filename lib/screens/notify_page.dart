import 'package:UTC2_Staff/utils/utils.dart';
import 'package:flutter/material.dart';

class NotifyPage extends StatefulWidget {
  @override
  _NotifyPageState createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        //elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Thông báo',
          style: TextStyle(color: ColorApp.black),
        ),
      ),
      body: Container(
        height: size.height,
        padding: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                stops: [0.2, 0.9],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, ColorApp.lightGrey])),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: ColorApp.blue,
                displacement: 40,
                onRefresh: () {},
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container(
                        width: size.width,
                        height: size.height * 0.12,
                        margin: EdgeInsets.only(bottom: 20),
                        child: ListTile(
                          leading: leading(size, '11-04-2021'),
                          title: title(size,
                              'Lễ trao bằng tốt nghiệp Đại học tháng 4 năm 2021Lễ trao bằng tốt nghiệp Đại học tháng 4 năm 2021'),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget title(Size size, String title) {
  return Container(
    child: Text(
      title,
      maxLines: 3,
      style: TextStyle(fontSize: size.width * 0.052),
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

Widget leading(Size size, String date) {
  return Container(
    alignment: Alignment.center,
    width: size.width * 0.22,
    decoration: BoxDecoration(
        border: Border(
          left: BorderSide(width: 5.0, color: ColorApp.red),
        ),
        gradient: LinearGradient(
            stops: [0.2, 0.9],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ColorApp.lightBlue, ColorApp.mediumBlue])),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          date.split('-')[0],
          style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.bold),
        ),
        Text(
          date.split('-')[1] + "/" + date.split('-')[2],
          style: TextStyle(
            color: Colors.white,
            fontSize: size.width * 0.04,
          ),
        ),
      ],
    ),
  );
}
