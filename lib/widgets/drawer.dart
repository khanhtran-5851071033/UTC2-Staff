import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
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
                  colors: [Color(0xffA4CCCE), Color(0xff4C6E89)])),
          child: ListView.builder(
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                    color: Colors.white,
                    width: .2,
                  ),
                )),
                child: ListTile(
                  onTap: () {
                    // listTab(index);
                  },
                  leading: Icon(
                    Icons.ac_unit,
                    color: Colors.white,
                    // size: 14,
                  ),
                  title: Text(
                    'Trang chủ',
                    style: TextStyle(color: Colors.white),
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
