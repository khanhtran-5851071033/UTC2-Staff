import 'package:UTC2_Staff/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  final Function(String) linkWeb;

  const CustomDrawer({this.linkWeb});
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  List service = [
    {'title': 'Trang chủ', 'icon': Icons.home, 'link': 'https://utc2.edu.vn/'},
    {
      'title': 'Nhập điểm',
      'icon': Icons.table_view,
      'link': 'http://nhapdiem.tms.utc2.edu.vn/TaiKhoangv/#'
    },
    {
      'title': 'Hệ thống Cố vấn học tập, Chủ nhiệm lớp',
      'icon': Icons.fact_check,
      'link': 'http://smart.utc2.edu.vn:85/cvht/gv/login.jsp'
    },
    {
      'title': 'Đăng ký sử dụng phòng học / báo dạy bù',
      'icon': Icons.storage,
      'link': 'http://tmsweb.utc2.edu.vn/Dangkyphong/Dangkyphong'
    },
    {
      'title': 'Đăng ký giấy đi công tác',
      'icon': Icons.flight_land,
      'link': 'http://vanthu.utc2.edu.vn:85/HanhChinhCong/'
    },
    {
      'title': 'Đăng ký giấy giới thiệu',
      'icon': Icons.badge,
      'link': 'http://smart.utc2.edu.vn/dvc/vi-vn'
    },
    {
      'title': 'Đăng ký xe đi công tác',
      'icon': Icons.airport_shuttle,
      'link': 'http://vanthu.utc2.edu.vn:85/HanhChinhCong/'
    },
    {
      'title': 'Đăng ký lịch công tác tuần',
      'icon': Icons.date_range,
      'link': 'http://vanthu.utc2.edu.vn:85/HanhChinhCong/'
    },
    {
      'title': 'Đăng ký ở nhà khách',
      'icon': Icons.night_shelter,
      'link': 'http://vanthu.utc2.edu.vn:85/HanhChinhCong/'
    },
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
        child: new ListView(
      physics: NeverScrollableScrollPhysics(),
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
          height: size.height - AppBar().preferredSize.height * 2,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, ColorApp.lightGrey])),
          child: ListView.builder(
            itemCount: service.length,
            physics: BouncingScrollPhysics(),
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
                    widget.linkWeb(service[index]['link']);
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
