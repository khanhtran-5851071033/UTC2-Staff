import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:signature/signature.dart';
import 'package:utc2_staff/service/firestore/class_database.dart';
import 'package:utc2_staff/service/firestore/teacher_database.dart';
import 'package:utc2_staff/utils/utils.dart';

class InfoDetailClass extends StatefulWidget {
  final Teacher teacher;
  final Class classUtc;
  final ScrollController controller;

  InfoDetailClass({this.teacher, this.classUtc, this.controller});

  @override
  _InfoDetailClassState createState() => _InfoDetailClassState();
}

class _InfoDetailClassState extends State<InfoDetailClass> {
  Widget textHeader(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white),
    );
  }

  Widget textRow(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(color: ColorApp.black),
    );
  }

  Widget headerTable() {
    return Container(
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(flex: 1, child: textHeader('STT')),
          Expanded(flex: 5, child: textHeader('Họ và tên')),
          Expanded(flex: 3, child: textHeader('Mã sinh viên')),
          Expanded(flex: 2, child: textHeader('Lớp')),
        ],
      ),
    );
  }

  Widget rowTable(int stt, String name, String msv, String className) {
    return Container(
      color: stt.isEven
          ? ColorApp.lightGrey.withOpacity(.2)
          : Colors.blue.withOpacity(.08),
      margin: EdgeInsets.only(bottom: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(flex: 1, child: textRow(stt.toString())),
          Expanded(flex: 5, child: textRow(name)),
          Expanded(flex: 3, child: textRow(msv)),
          Expanded(flex: 2, child: textRow(className)),
        ],
      ),
    );
  }

  bool isSignature = false;
  Uint8List data;
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1.2,
    penColor: ColorApp.black,
    exportBackgroundColor: Colors.transparent,
  );
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Thoát"),
      style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.padded,
          shadowColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.blue)))),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton.icon(
      icon: Icon(
        Icons.check,
        size: 13,
      ),
      label: Text("Xác nhận"),
      style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.padded,
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
          shadowColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: ColorApp.lightGrey, width: 2)))),
      onPressed: () async {
        if (_controller.isNotEmpty) {
          final Uint8List dataq = await _controller.toPngBytes();
          if (dataq != null) {
            Navigator.pop(context);
            setState(() {
              isSignature = true;
              data = dataq;
            });
          }
        }
      },
    );
    Widget reSignature = TextButton(
      child: Text("Ký lại"),
      style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.padded,
          shadowColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.blue)))),
      onPressed: () {
        _controller.clear();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Chữ ký của bạn'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Signature(
            controller: _controller,
            height: 200,
            width: 300,
            backgroundColor: ColorApp.lightGrey,
          ),
        ],
      ),
      actions: [
        continueButton,
        reSignature,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20.0),
          topRight: const Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: [
          Center(
              child: Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: ColorApp.grey,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(3),
                topRight: const Radius.circular(3),
              ),
            ),
            height: 3,
            width: 50,
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                'Thông tin lớp',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Divider(
            thickness: 0.5,
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              controller: widget.controller,
              itemCount: 1,
              itemBuilder: (_, index) {
                return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    // child:
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(4),
                              child: CircleAvatar(
                                backgroundColor: ColorApp.lightGrey,
                                backgroundImage: CachedNetworkImageProvider(
                                    widget.teacher.avatar),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.teacher.name != null
                                      ? 'Giảng viên phụ trách : ' +
                                          widget.teacher.name
                                      : '',
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.teacher.email != null
                                      ? 'Email giảng viên : ' +
                                          widget.teacher.email
                                      : '',
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.classUtc.name != null
                                      ? 'Tên lớp : ' + widget.classUtc.name
                                      : '',
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.classUtc.id != null
                                      ? 'Mã lớp : ' + widget.classUtc.id
                                      : '',
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.classUtc.note != null
                                      ? 'Mô tả : ' + widget.classUtc.note
                                      : '',
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.classUtc.date != null
                                      ? 'Ngày tạo : ' +
                                          DateFormat('HH:mm - dd-MM-yyyy')
                                              .format(DateFormat(
                                                      "yyyy-MM-dd HH:mm:ss")
                                                  .parse(widget.classUtc.date))
                                      : '',
                                ),
                              ],
                            ),
                            //qr
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorApp.blue.withOpacity(0.09),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(
                                        2, 3), // changes position of shadow
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                // border:
                                //     Border.all(color: ColorApp.lightGrey)
                              ),
                              child: QrImage(
                                data: widget.classUtc.id,
                                embeddedImage:
                                    AssetImage('assets/images/logoUTC.png'),
                                version: QrVersions.auto,
                                size: 100,
                                gapless: false,
                                embeddedImageStyle: QrEmbeddedImageStyle(
                                  size: Size(15, 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            'Danh sách lớp',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        headerTable(),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 2))),
                          child: ListView.builder(
                              itemCount: 30,
                              itemBuilder: (context, index) {
                                return rowTable((index + 1), 'Trần Quốc Khánh',
                                    "5851071033", "CNTT.k58");
                              }),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Hồ Chí Minh, ngày ' +
                                      DateTime.now().day.toString() +
                                      ' tháng ' +
                                      DateTime.now().month.toString() +
                                      ' năm ' +
                                      DateTime.now().year.toString(),
                                ),
                                TextButton.icon(
                                    onPressed: () {
                                      showAlertDialog(context);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      size: 13,
                                    ),
                                    label: Text("Ký tên")),
                                Container(
                                  height: 50,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Opacity(
                                          opacity: 0.08,
                                          child: Image.asset(
                                              'assets/images/logoUTC.png')),
                                      AnimatedCrossFade(
                                          firstChild: data != null
                                              ? Image.memory(
                                                  data,
                                                )
                                              : Container(),
                                          secondChild: Container(),
                                          crossFadeState: isSignature
                                              ? CrossFadeState.showFirst
                                              : CrossFadeState.showSecond,
                                          duration:
                                              Duration(milliseconds: 300)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.teacher.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ));
              },
            ),
          ),
          Image.asset(
            'assets/images/path@2x.png',
            width: size.width,
            fit: BoxFit.fill,
          )
        ],
      ),
    ));
  }
}
