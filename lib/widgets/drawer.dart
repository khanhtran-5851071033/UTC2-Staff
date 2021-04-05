import 'package:UTC2_Staff/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  List service = [
    {'title': 'Trang chủ', 'icon': Icons.home},
    {'title': 'Nhập điểm', 'icon': Icons.table_view},
    {
      'title': 'Hệ thống Cố vấn học tập, Chủ nhiệm lớp',
      'icon': Icons.fact_check
    },
    {'title': 'Đăng ký sử dụng phòng học / báo dạy bù', 'icon': Icons.storage},
    {'title': 'Đăng ký giấy đi công tác', 'icon': Icons.flight_land},
    {'title': 'Đăng ký giấy giới thiệu', 'icon': Icons.badge},
    {'title': 'Đăng ký xe đi công tác', 'icon': Icons.airport_shuttle},
    {'title': 'Đăng ký lịch công tác tuần', 'icon': Icons.date_range},
    {'title': 'Đăng ký ở nhà khách', 'icon': Icons.night_shelter},
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
        child: new ListView(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            //   homeTab();
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03, vertical: size.width * 0.02),
            height: AppBar().preferredSize.height,
            color: Colors.white,
            child: CachedNetworkImage(
              imageUrl:
                  'https://utc2.edu.vn/upload/company/logo-15725982242.png',
            ),
          ),
        ),
        Container(
          height: size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, ColorApp.lightGrey])),
          child: ListView.builder(
            itemCount: service.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                    color: ColorApp.grey,
                    width: .2,
                  ),
                )),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  leading: Icon(
                    service[index]['icon'],
                    color: ColorApp.black.withOpacity(.8),
                    // size: 14,
                  ),
                  title: Text(
                    service[index]['title'].toString(),
                    style: TextStyle(
                        color: ColorApp.black.withOpacity(.8),
                        fontSize: size.width * 0.042,
                        wordSpacing: 1.2,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2),
                  ),
                ),
              );
            },
          ),
        )
      ],
    ));
  }
}
